part of 'generic_widgets.dart';

class CustomHorizontalStepper extends StatefulWidget {
  final bool isTiteVisible;
  final List<ProfileStepDataModel> steps;
  final bool Function(int currentStep, List<ProfileStepDataModel> steps)?
      onStepValidation;
  final VoidCallback? onStepTapped;

  final void Function({
    required VoidCallback nextStep,
    required VoidCallback previousStep,
    required bool Function() isLastStep,
    required int Function() getCurrentStep,
    required void Function(int step) markStepAsCompleted,
  })? onReady;

  const CustomHorizontalStepper(
      {super.key,
      required this.steps,
      this.onReady,
      this.isTiteVisible = true,
      this.onStepValidation,
      this.onStepTapped});

  @override
  State<CustomHorizontalStepper> createState() =>
      _CustomHorizontalStepperState();
}

class _CustomHorizontalStepperState extends State<CustomHorizontalStepper> {
  int selectedStep = 0;
  Set<int> completedSteps = <int>{}; // Track completed steps

  void _updateParentCallbacks() {
    widget.onReady?.call(
      nextStep: nextStep,
      previousStep: previousStep,
      isLastStep: () => selectedStep == widget.steps.length - 1,
      getCurrentStep: () => selectedStep,
      markStepAsCompleted: markStepAsCompleted,
    );
  }

  @override
  void initState() {
    super.initState();
    _updateParentCallbacks();
  }

  void markStepAsCompleted(int step) {
    setState(() {
      completedSteps.add(step);
    });
  }

  void nextStep() {
    if (selectedStep < widget.steps.length - 1) {
      // Validate current step before proceeding
      if (widget.onStepValidation != null &&
          !widget.onStepValidation!(selectedStep, widget.steps)) {
        return; // Don't proceed if validation fails
      }

      // Mark current step as completed
      completedSteps.add(selectedStep);

      setState(() {
        selectedStep++;
      });

      _updateParentCallbacks();
    }
  }

  void previousStep() {
    if (selectedStep > 0) {
      setState(() {
        selectedStep--;
      });

      _updateParentCallbacks();
    }
  }

  bool _canNavigateToStep(int targetStep) {
    // Can always go to current step
    if (targetStep == selectedStep) return true;

    // Can go backward to any completed step or step 0
    if (targetStep < selectedStep) {
      return targetStep == 0 || completedSteps.contains(targetStep);
    }

    // Can only go forward to the immediate next step if current step is completed
    if (targetStep == selectedStep + 1) {
      return completedSteps.contains(selectedStep);
    }

    // Cannot skip steps forward
    return false;
  }

  void _navigateToStep(int targetStep) {
    if (_canNavigateToStep(targetStep)) {
      setState(() {
        selectedStep = targetStep;
      });
      widget.onStepTapped?.call();
      _updateParentCallbacks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final grey = Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal Stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.steps.length, (index) {
              final isActive = index == selectedStep;
              final isDone = completedSteps.contains(index);
              final canNavigate = _canNavigateToStep(index);

              return index < widget.steps.length - 1
                  ? Expanded(
                      child: Row(
                        children: [
                          _buildStepCircle(
                              index, isActive, isDone, canNavigate),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: isDone ? Colors.black : grey,
                              margin: EdgeInsets.only(left: 4),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildStepCircle(index, isActive, isDone, canNavigate);
            }),
          ),
          14.verticalSpace,

          if (widget.isTiteVisible) ...[
            Text(
              widget.steps[selectedStep].title,
              style: AppTextTheme().bodyText.copyWith(fontSize: 16),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(color: Color.fromRGBO(10, 38, 73, 0.4)),
            ),
          ],
          Expanded(child: widget.steps[selectedStep].child),
          120.verticalSpace
        ],
      ),
    );
  }

  Widget _buildStepCircle(
    int index,
    bool isActive,
    bool isDone,
    bool canNavigate,
  ) {
    final black = Colors.black;
    final grey = Colors.grey;
    final disabledGrey = Colors.grey.shade300;

    return GestureDetector(
      onTap: canNavigate
          ? () => _navigateToStep(index)
          : null, // Disable tap if navigation not allowed
      child: Container(
        width: 32,
        height: 32,
        margin: index != 0 ? EdgeInsets.only(left: 5) : null,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDone ? black : Colors.transparent,
          border: Border.all(
            color: !canNavigate
                ? disabledGrey
                : isDone
                    ? black
                    : isActive
                        ? black
                        : grey,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: !canNavigate
                ? disabledGrey
                : isDone
                    ? Colors.white
                    : isActive
                        ? AppColorTheme().primary
                        : grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProfileStepDataModel {
  final String title;
  final Widget child;

  ProfileStepDataModel({required this.title, required this.child});
}
