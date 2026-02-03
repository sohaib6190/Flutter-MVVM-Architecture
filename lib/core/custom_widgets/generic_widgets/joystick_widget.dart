part of 'generic_widgets.dart';

/// Joystick widget
class Joystick extends StatefulWidget {
  /// Callback, which is called with [period] frequency when the stick is dragged.
  final StickDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Widget that renders joystick base, by default [JoystickBase].
  final Widget? base;

  /// Widget that renders joystick stick, it places in the center of [base] widget, by default [JoystickStick].
  final Widget stick;

  /// Controller allows to control joystick events outside the widget.
  final JoystickController? controller;

  /// Possible directions mode of the joystick stick, by default [JoystickMode.all]
  final JoystickMode mode;

  /// Calculate offset of the stick based on the stick drag start position and the current stick position.
  final StickOffsetCalculator stickOffsetCalculator;

  /// Callback, which is called when the stick starts dragging.
  final Function? onStickDragStart;

  /// Callback, which is called when the stick released.
  final Function? onStickDragEnd;

  /// Decides if the stick's initial movement animation should be included. By default [true].
  final bool includeInitialAnimation;

  const Joystick({
    super.key,
    required this.listener,
    this.period = const Duration(milliseconds: 100),
    this.base,
    this.stick = const JoystickStick(),
    this.mode = JoystickMode.all,
    this.stickOffsetCalculator = const CircleStickOffsetCalculator(),
    this.controller,
    this.onStickDragStart,
    this.onStickDragEnd,
    this.includeInitialAnimation = true,
  });

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  final GlobalKey _baseKey = GlobalKey();

  Offset _stickOffset = Offset.zero;
  Timer? _callbackTimer;
  final double _moveValue = 24.0;
  Offset _startDragStickPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    widget.controller?.onStickDragStart =
        (globalPosition) => _stickDragStart(globalPosition);
    widget.controller?.onStickDragUpdate =
        (globalPosition) => _stickDragUpdate(globalPosition);
    widget.controller?.onStickDragEnd = () => _stickDragEnd();
    if (widget.includeInitialAnimation) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => _animateJoystick(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(_stickOffset.dx, _stickOffset.dy),
      children: [
        Container(
          key: _baseKey,
          child: widget.base ?? JoystickBase(mode: widget.mode),
        ),
        GestureDetector(
          onPanStart: (details) => _stickDragStart(details.globalPosition),
          onPanUpdate: (details) => _stickDragUpdate(details.globalPosition),
          onPanEnd: (details) => _stickDragEnd(),
          child: widget.stick,
        ),
      ],
    );
  }

  void _animateJoystick() async {
    Duration duration = const Duration(milliseconds: 200);
    if (widget.mode == JoystickMode.vertical) {
      await _moveInYAxis(duration);
    } else if (widget.mode == JoystickMode.horizontal) {
      await _moveInXAxis(duration);
    } else {
      duration = const Duration(milliseconds: 160);
      await _moveInXAxis(duration);
      await _moveInYAxis(duration);
    }
  }

  _moveInXAxis(Duration duration) async {
    Offset moveLeft = Offset(-_moveValue, 0);
    Offset moveRight = Offset(_moveValue, 0);
    Offset center = _startDragStickPosition;

    await Future.delayed(
      duration,
      () => _stickDragUpdate(moveLeft),
    );
    await Future.delayed(
      duration,
      () => _stickDragUpdate(moveRight),
    );
    await Future.delayed(
      duration,
      () => _stickDragUpdate(center),
    );
  }

  _moveInYAxis(Duration duration) async {
    Offset moveTop = Offset(0, -_moveValue);
    Offset moveBottom = Offset(0, _moveValue);
    Offset center = _startDragStickPosition;

    await Future.delayed(
      duration,
      () => _stickDragUpdate(moveTop),
    );
    await Future.delayed(
      duration,
      () => _stickDragUpdate(moveBottom),
    );
    await Future.delayed(
      duration,
      () => _stickDragUpdate(center),
    );
  }

  void _stickDragStart(Offset globalPosition) {
    // Calculate the new start position based on the joystick's current offset
    _startDragStickPosition = globalPosition -
        _stickOffset * (_baseKey.currentContext!.size!.width / 2);

    // Start the callback
    _runCallback();

    // Trigger any additional drag start behavior
    widget.onStickDragStart?.call();
  }

  void _stickDragUpdate(Offset globalPosition) {
    final baseRenderBox =
        _baseKey.currentContext!.findRenderObject()! as RenderBox;

    final stickOffset = widget.stickOffsetCalculator.calculate(
      mode: widget.mode,
      startDragStickPosition: _startDragStickPosition,
      currentDragStickPosition: globalPosition,
      baseSize: baseRenderBox.size,
    );

    setState(() {
      _stickOffset = stickOffset;
    });
  }

  void _stickDragEnd() {
    // setState(() {
    //   _stickOffset = Offset.zero;
    // });

    _callbackTimer?.cancel();
    //send zero offset when the stick is released
    widget.listener(StickDragDetails(_stickOffset.dx, _stickOffset.dy));
    // _startDragStickPosition = Offset.zero;
    widget.onStickDragEnd?.call();
  }

  void _runCallback() {
    _callbackTimer = Timer.periodic(widget.period, (timer) {
      widget.listener(StickDragDetails(_stickOffset.dx, _stickOffset.dy));
    });
  }

  @override
  void dispose() {
    _callbackTimer?.cancel();
    super.dispose();
  }
}

typedef StickDragCallback = void Function(StickDragDetails details);

/// Contains the stick offset from the center of the base.
class StickDragDetails {
  /// x - the stick offset in the horizontal direction. Can be from -1.0 to +1.0.
  final double x;

  /// y - the stick offset in the vertical direction. Can be from -1.0 to +1.0.
  final double y;

  StickDragDetails(this.x, this.y);
}

/// Possible directions of the joystick stick.
enum JoystickMode {
  /// allow move the stick in any direction: vertical, horizontal and diagonal.
  all,

  /// allow move the stick only in vertical direction.
  vertical,

  /// allow move the stick only in horizontal direction.
  horizontal,

  /// allow move the stick only in horizontal and vertical directions, not diagonal.
  horizontalAndVertical,
}

/// Allow to place the joystick in any place where user click.
/// Just need to place other widgets as child of [JoystickArea] widget.
class JoystickArea extends StatefulWidget {
  /// The [child] contained by the joystick area.
  final Widget? child;

  /// Initial joystick alignment relative to the joystick area, by default [Alignment.bottomCenter].
  final Alignment initialJoystickAlignment;

  /// Callback, which is called with [period] frequency when the stick is dragged.
  final StickDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Widget that renders joystick base, by default [JoystickBase].
  final Widget? base;

  /// Widget that renders joystick stick, it places in the center of [base] widget, by default [JoystickStick].
  final Widget stick;

  /// Mode possible direction
  final JoystickMode mode;

  /// Calculate offset of the stick based on the stick drag start position and the current stick position.
  final StickOffsetCalculator stickOffsetCalculator;

  /// Callback, which is called when the stick starts dragging.
  final Function? onStickDragStart;

  /// Callback, which is called when the stick released.
  final Function? onStickDragEnd;

  /// Decides if the stick's initial movement animation should be included. By default [true].
  final bool includeInitialAnimation;

  const JoystickArea({
    super.key,
    this.child,
    this.initialJoystickAlignment = Alignment.bottomCenter,
    required this.listener,
    this.period = const Duration(milliseconds: 100),
    this.base,
    this.stick = const JoystickStick(),
    this.mode = JoystickMode.all,
    this.stickOffsetCalculator = const CircleStickOffsetCalculator(),
    this.onStickDragStart,
    this.onStickDragEnd,
    this.includeInitialAnimation = true,
  });

  @override
  State<JoystickArea> createState() => _JoystickAreaState();
}

class _JoystickAreaState extends State<JoystickArea> {
  final _areaKey = GlobalKey();
  final _joystickKey = GlobalKey();
  final _controller = JoystickController();
  late Alignment _joystickAlignment;

  @override
  void didChangeDependencies() {
    _joystickAlignment = widget.initialJoystickAlignment;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _areaKey,
      onPanStart: _startDrag,
      onPanUpdate: _updateDrag,
      onPanEnd: _endDrag,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Stack(
          children: [
            if (widget.child != null) Align(child: widget.child),
            Align(
              alignment: _joystickAlignment,
              child: Joystick(
                key: _joystickKey,
                controller: _controller,
                listener: widget.listener,
                period: widget.period,
                mode: widget.mode,
                base: widget.base,
                stick: widget.stick,
                onStickDragStart: widget.onStickDragStart,
                onStickDragEnd: widget.onStickDragEnd,
                includeInitialAnimation: widget.includeInitialAnimation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startDrag(DragStartDetails details) {
    final localPosition = details.localPosition;
    final joystickSize = _joystickKey.currentContext!.size!;

    final areaBox = _areaKey.currentContext!.findRenderObject()! as RenderBox;

    final halfWidth = areaBox.size.width / 2;
    final halfHeight = areaBox.size.height / 2;

    final xAlignment =
        (localPosition.dx - halfWidth) / (halfWidth - joystickSize.width / 2);
    final yAlignment = (localPosition.dy - halfHeight) /
        (halfHeight - joystickSize.height / 2);

    setState(() {
      _joystickAlignment = Alignment(xAlignment, yAlignment);
    });
    _controller.start(details.globalPosition);
  }

  void _updateDrag(DragUpdateDetails details) {
    _controller.update(details.globalPosition);
  }

  void _endDrag(DragEndDetails details) {
    setState(() {
      _joystickAlignment = widget.initialJoystickAlignment;
    });

    _controller.end();
  }
}

class JoystickArrows extends StatefulWidget {
  final JoystickMode mode;
  final double size;
  final JoystickArrowsDecoration? decoration;

  const JoystickArrows({
    super.key,
    required this.mode,
    required this.size,
    this.decoration,
  });

  @override
  State<JoystickArrows> createState() => _JoystickArrowsState();
}

class _JoystickArrowsState extends State<JoystickArrows>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 2);

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: _ArrowPainter(
          value: (controller.value * 100).toInt(),
          mode: widget.mode,
          decoration: widget.decoration ?? JoystickArrowsDecoration(),
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final int value;
  final JoystickMode mode;
  final JoystickArrowsDecoration decoration;

  _ArrowPainter({
    required this.value,
    required this.mode,
    required this.decoration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    drawVerticalArrows(canvas, paint, size);
    drawHorizontalArrows(canvas, paint, size);
  }

  void drawVerticalArrows(
    Canvas canvas,
    Paint paint,
    Size size,
  ) {
    if (mode != JoystickMode.horizontal) {
      double xPosition = size.width / 2;
      double top = -36;
      double bottom = size.height - 36;
      double rotationAngle = math.pi;
      double moveX = size.width;

      canvas.translate(moveX, 0);
      canvas.rotate(rotationAngle);
      _drawArrow(
        canvas,
        paint,
        xPosition,
        top,
      );
      canvas.translate(moveX, 0);
      canvas.rotate(-rotationAngle);
      _drawArrow(
        canvas,
        paint,
        xPosition,
        bottom,
      );
      canvas.translate(0, 0);
    }
  }

  void drawHorizontalArrows(
    Canvas canvas,
    Paint paint,
    Size size,
  ) {
    if (mode != JoystickMode.vertical) {
      double yPosition = size.height / 2 - 36;
      double left = 0;
      double right = size.width;
      double rotationAngle = math.pi / 2;
      double moveXLeft = size.width / 2;
      double moveXRight = size.width;
      double moveY = size.height / 2;

      canvas.translate(
        moveXLeft,
        moveY,
      );
      canvas.rotate(rotationAngle);
      _drawArrow(
        canvas,
        paint,
        left,
        yPosition,
      );
      canvas.translate(
        moveXRight,
        0,
      );
      canvas.rotate(math.pi);
      _drawArrow(
        canvas,
        paint..color,
        right,
        yPosition,
      );
    }
  }

  void _drawArrow(
    Canvas canvas,
    Paint paint,
    double xPosition,
    double yPosition,
  ) {
    var path = Path();
    path.moveTo(xPosition - 5, yPosition - 12);
    path.lineTo(xPosition, yPosition - 8);
    path.lineTo(xPosition + 5, yPosition - 12);
    canvas.drawPath(
      path,
      paint..color = evaluateColor(value < 33),
    );

    path = Path();
    path.moveTo(xPosition - 7, yPosition - 5);
    path.lineTo(xPosition, yPosition);
    path.lineTo(xPosition + 7, yPosition - 5);
    canvas.drawPath(
      path,
      paint..color = evaluateColor(value > 33 && value < 66),
    );

    path = Path();
    path.moveTo(xPosition - 10, yPosition + 2);
    path.lineTo(xPosition, yPosition + 9);
    path.lineTo(xPosition + 10, yPosition + 2);
    canvas.drawPath(path, paint..color = evaluateColor(value > 66));
  }

  evaluateColor(bool condition) {
    Color resultColor = decoration.color;
    if (!condition && decoration.enableAnimation) {
      resultColor = ColorUtils.darken(decoration.color, 0.14);
    }
    return resultColor;
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => oldDelegate.value != value;
}

@immutable
class JoystickArrowsDecoration {
  final Color color;
  final bool enableAnimation;

  const JoystickArrowsDecoration._internal({
    required this.color,
    required this.enableAnimation,
  });

  factory JoystickArrowsDecoration({
    Color? color,
    bool enableAnimation = true,
  }) {
    return JoystickArrowsDecoration._internal(
      color: color ?? ColorUtils.defaultArrowsColor,
      enableAnimation: enableAnimation,
    );
  }
}

class JoystickBase extends StatelessWidget {
  final JoystickMode mode;
  final double size;
  final JoystickBaseDecoration? decoration;
  final Widget? joystickArrows;
  final JoystickArrowsDecoration? arrowsDecoration;

  const JoystickBase({
    this.mode = JoystickMode.all,
    this.size = 200,
    this.decoration,
    this.joystickArrows,
    this.arrowsDecoration,
    super.key,
  }) : assert(joystickArrows == null || arrowsDecoration == null);

  @override
  Widget build(BuildContext context) {
    final baseDecoration = decoration ?? JoystickBaseDecoration();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: baseDecoration.boxShadows),
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _JoystickBasePainter(
                decoration: baseDecoration,
              ),
            ),
          ),
          if (baseDecoration.drawArrows)
            joystickArrows ??
                JoystickArrows(
                  mode: mode,
                  size: size,
                  decoration: arrowsDecoration,
                ),
        ],
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  final JoystickBaseDecoration decoration;

  _JoystickBasePainter({
    required this.decoration,
  });

  static const double borderStrokeWidthPercentage = 0.05;
  static const double innerCircleRadiusReductionPercentage = 0.06;
  static const double outermostCircleRadiusReductionPercentage = 0.3;

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.width;
    final radius = diameter / 2;
    final center = Offset(radius, radius);

    drawCircles(canvas, center, diameter);
  }

  void drawCircles(Canvas canvas, Offset center, double diameter) {
    drawOuterCircle(canvas, center, diameter);
    drawMiddleCircle(canvas, center, diameter);
    drawInnerCircle(canvas, center, diameter);
  }

  void drawInnerCircle(Canvas canvas, Offset center, double diameter) {
    if (decoration.drawInnerCircle) {
      final innerPaint = Paint()
        ..color = decoration.innerCircleColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          center,
          diameter / 2 - outermostCircleRadiusReductionPercentage * diameter,
          innerPaint);
    }
  }

  void drawMiddleCircle(Canvas canvas, Offset center, double diameter) {
    if (decoration.drawMiddleCircle) {
      final paint = Paint()
        ..color = decoration.middleCircleColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          center,
          diameter / 2 - innerCircleRadiusReductionPercentage * diameter,
          paint);
    }
  }

  void drawOuterCircle(Canvas canvas, Offset center, double diameter) {
    if (decoration.drawOuterCircle) {
      final outerCirclePaint = Paint()
        ..color = decoration.outerCircleColor
        ..strokeWidth = borderStrokeWidthPercentage * diameter
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, diameter / 2, outerCirclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JoystickSquareBase extends StatelessWidget {
  final test = JoystickBaseDecoration();
  final JoystickMode mode;
  final double size;
  final JoystickBaseDecoration? decoration;

  JoystickSquareBase({
    this.mode = JoystickMode.all,
    this.size = 200,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = this.decoration ?? JoystickBaseDecoration();
    final padding = 10 / 200 * size;
    return Container(
      width: size,
      height: size,
      decoration: decoration.drawOuterCircle
          ? BoxDecoration(
              border: Border.all(color: decoration.outerCircleColor, width: 10))
          : null,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          width: size - padding * 2,
          height: size - padding * 2,
          color: decoration.middleCircleColor,
          child: decoration.drawArrows
              ? CustomPaint(
                  painter: _JoystickSquareBaseArrowPainter(
                      mode: mode, decoration: decoration),
                )
              : null,
        ),
      ),
    );
  }
}

class _JoystickSquareBaseArrowPainter extends CustomPainter {
  final JoystickMode mode;
  final JoystickBaseDecoration decoration;

  _JoystickSquareBaseArrowPainter({
    required this.mode,
    required this.decoration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lineWidth = 20.0 / 180 * size.width;
    final lineHeight = 40.0 / 180 * size.height;
    final linePosition = 30.0 / 180 * size.width;
    final double arrowSpacing = 15.0 / 180 * size.width;
    final linePaint = Paint()
      ..color = decoration.innerCircleColor
      ..strokeWidth = 5 / 180 * size.width
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    if (mode != JoystickMode.horizontal) {
      // draw vertical arrows
      canvas.drawLine(Offset(center.dx - lineWidth, center.dy - linePosition),
          Offset(center.dx, center.dy - linePosition - lineHeight), linePaint);
      canvas.drawLine(Offset(center.dx + lineWidth, center.dy - linePosition),
          Offset(center.dx, center.dy - linePosition - lineHeight), linePaint);

      canvas.drawLine(Offset(center.dx - lineWidth, center.dy + linePosition),
          Offset(center.dx, center.dy + linePosition + lineHeight), linePaint);
      canvas.drawLine(Offset(center.dx + lineWidth, center.dy + linePosition),
          Offset(center.dx, center.dy + linePosition + lineHeight), linePaint);
    }

    if (mode != JoystickMode.vertical) {
      // draw horizontal arrows
      canvas.drawLine(Offset(center.dx - linePosition, center.dy - lineWidth),
          Offset(center.dx - linePosition - lineHeight, center.dy), linePaint);
      canvas.drawLine(Offset(center.dx - linePosition, center.dy + lineWidth),
          Offset(center.dx - linePosition - lineHeight, center.dy), linePaint);
      canvas.drawLine(Offset(center.dx + linePosition, center.dy - lineWidth),
          Offset(center.dx + linePosition + lineHeight, center.dy), linePaint);
      canvas.drawLine(Offset(center.dx + linePosition, center.dy + lineWidth),
          Offset(center.dx + linePosition + lineHeight, center.dy), linePaint);
    }

    if (mode == JoystickMode.all) {
      // draw diagonal arrows
      canvas.drawLine(
          Offset(center.dx + lineWidth, center.dy - linePosition),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + linePosition, center.dy - lineWidth),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + lineWidth, center.dy + linePosition),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + linePosition, center.dy + lineWidth),
          Offset(center.dx + lineWidth + arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - lineWidth, center.dy - linePosition),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - linePosition, center.dy - lineWidth),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy - linePosition - 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - lineWidth, center.dy + linePosition),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - linePosition, center.dy + lineWidth),
          Offset(center.dx - lineWidth - arrowSpacing,
              center.dy + linePosition + 5),
          linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

@immutable
class JoystickBaseDecoration {
  final bool drawArrows;

  final bool drawOuterCircle;
  final Color outerCircleColor;
  final bool drawMiddleCircle;
  final Color middleCircleColor;
  final bool drawInnerCircle;
  final Color innerCircleColor;

  final List<BoxShadow>? boxShadows;

  const JoystickBaseDecoration._internal({
    required this.drawArrows,
    required this.drawOuterCircle,
    required this.outerCircleColor,
    required this.drawMiddleCircle,
    required this.middleCircleColor,
    required this.drawInnerCircle,
    required this.innerCircleColor,
    required this.boxShadows,
  });

  factory JoystickBaseDecoration({
    Color? color,
    bool drawArrows = true,
    bool drawOuterCircle = true,
    Color? outerCircleColor,
    bool drawMiddleCircle = true,
    Color? middleCircleColor,
    bool drawInnerCircle = true,
    Color? innerCircleColor,
    List<BoxShadow>? boxShadows,
    Color? boxShadowColor,
  }) {
    assert(boxShadows == null || boxShadowColor == null);
    assert(color == null ||
        outerCircleColor == null ||
        middleCircleColor == null ||
        innerCircleColor == null);
    Color baseColor = color ?? ColorUtils.defaultBaseColor;
    return JoystickBaseDecoration._internal(
      drawArrows: drawArrows,
      drawOuterCircle: drawOuterCircle,
      outerCircleColor: outerCircleColor ?? baseColor,
      drawMiddleCircle: drawMiddleCircle,
      middleCircleColor:
          middleCircleColor ?? ColorUtils.lighten(baseColor, 0.05),
      drawInnerCircle: drawInnerCircle,
      innerCircleColor: innerCircleColor ?? baseColor,
      boxShadows: boxShadows ??
          [
            BoxShadow(
              color: boxShadowColor ?? baseColor.withValues(alpha: 0.16),
              spreadRadius: 10,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
    );
  }
}

class JoystickController {
  void Function(Offset globalPosition)? onStickDragStart;
  void Function(Offset globalPosition)? onStickDragUpdate;
  void Function()? onStickDragEnd;

  void start(Offset globalPosition) {
    onStickDragStart?.call(globalPosition);
  }

  void update(Offset globalPosition) {
    onStickDragUpdate?.call(globalPosition);
  }

  void end() {
    onStickDragEnd?.call();
  }
}

class JoystickStick extends StatelessWidget {
  final double size;
  final JoystickStickDecoration? decoration;

  const JoystickStick({
    this.size = 50,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = this.decoration ?? JoystickStickDecoration();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: decoration.shadowColor,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorUtils.darken(decoration.color),
            ColorUtils.lighten(decoration.color),
          ],
        ),
      ),
    );
  }
}

@immutable
class JoystickStickDecoration {
  final Color color;
  final Color shadowColor;

  const JoystickStickDecoration._internal({
    required this.color,
    required this.shadowColor,
  });

  factory JoystickStickDecoration({
    Color color = ColorUtils.defaultStickColor,
    Color? shadowColor,
  }) {
    return JoystickStickDecoration._internal(
      color: color,
      shadowColor: shadowColor ?? color.withValues(alpha: 0.5),
    );
  }
}

abstract class StickOffsetCalculator {
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  });
}

class CircleStickOffsetCalculator implements StickOffsetCalculator {
  const CircleStickOffsetCalculator();

  @override
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;
    final radius = baseSize.width / 2;

    final isPointInCircle = x * x + y * y < radius * radius;

    if (!isPointInCircle) {
      final mult = math.sqrt(radius * radius / (y * y + x * x));
      x *= mult;
      y *= mult;
    }

    final xOffset = x / radius;
    final yOffset = y / radius;

    switch (mode) {
      case JoystickMode.all:
        return Offset(xOffset, yOffset);
      case JoystickMode.vertical:
        return Offset(0.0, yOffset);
      case JoystickMode.horizontal:
        return Offset(xOffset, 0.0);
      case JoystickMode.horizontalAndVertical:
        return Offset(xOffset.abs() > yOffset.abs() ? xOffset : 0,
            yOffset.abs() > xOffset.abs() ? yOffset : 0);
    }
  }
}

class RectangleStickOffsetCalculator implements StickOffsetCalculator {
  const RectangleStickOffsetCalculator();

  @override
  Offset calculate({
    required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;

    final xOffset = _normalizeOffset(x / (baseSize.width / 2));
    final yOffset = _normalizeOffset(y / (baseSize.height / 2));

    switch (mode) {
      case JoystickMode.all:
        return Offset(xOffset, yOffset);
      case JoystickMode.vertical:
        return Offset(0.0, yOffset);
      case JoystickMode.horizontal:
        return Offset(xOffset, 0.0);
      case JoystickMode.horizontalAndVertical:
        return Offset(xOffset.abs() > yOffset.abs() ? xOffset : 0,
            yOffset.abs() > xOffset.abs() ? yOffset : 0);
    }
  }

  double _normalizeOffset(double point) {
    if (point > 1) {
      return 1;
    }
    if (point < -1) {
      return -1;
    }
    return point;
  }
}

class ColorUtils {
  static const Color defaultBaseColor = Colors.grey;
  static const Color defaultArrowsColor = Colors.white;
  static const Color defaultStickColor = Colors.blue;

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
