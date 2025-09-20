part of 'generic_widgets.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onYesTap,
    this.onNoTap,
  });

  final String title;
  final String content;
  final void Function() onYesTap;
  final void Function()? onNoTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.isDarkTheme
          ? AppColorTheme().secondary
          : AppColorTheme().lightBackground,
      title: Text(
        title,
        style: context.headingText.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
      ),
      content: Text(
        content,
        style: context.bodyText.copyWith(fontSize: 16),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: onNoTap ?? () => context.popPage(),
              child: Text(
                translate(context, 'no'),
                style: context.headingText.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: onYesTap,
              child: Text(
                translate(context, 'yes'),
                style: context.headingText.copyWith(
                  color: AppColorTheme().primary,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
