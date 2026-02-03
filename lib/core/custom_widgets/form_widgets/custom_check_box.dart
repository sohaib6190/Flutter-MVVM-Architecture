part of 'form_widgets.dart';

class GradientCheckbox extends StatelessWidget {
  const GradientCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.height,
    this.width,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        height: height ?? 24,
        width: width ?? 24,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          gradient: value
              ? LinearGradient(
                  colors: [
                    AppColorTheme().primaryGradient1,
                    AppColorTheme().primaryGradient2,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: value ? null : AppColorTheme().white,
          border: Border.all(
            color: value ? Colors.transparent : context.monochromeColor,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                color: AppColorTheme().white,
                size: 18,
              )
            : null,
      ),
    );
  }
}
