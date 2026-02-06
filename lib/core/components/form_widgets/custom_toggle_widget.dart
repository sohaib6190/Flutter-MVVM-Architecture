part of 'form_widgets.dart';

class CustomToggleWidget extends StatelessWidget {
  const CustomToggleWidget({
    super.key,
    this.title,
    this.onChanged,
    this.value,
    this.isToggled = false,
  });
  final String? title;
  final bool? value;
  final bool? isToggled;

  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        SizedBox(
          height: 24,
          child: Transform.scale(
            scale: 0.84,

            child: Switch(
              activeTrackColor: AppColorTheme().primaryGradient1,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),

              inactiveTrackColor: Colors.grey.shade300,
              inactiveThumbColor: AppColorTheme().white,

              padding: const EdgeInsets.all(0),
              value: value ?? false,
              onChanged: (value) {
                onChanged?.call(value);
              },
            ),
          ),
        ),
        Text(
          title ?? "",
          style: context.lightText.copyWith(
            color: AppColorTheme().darkBlue,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
