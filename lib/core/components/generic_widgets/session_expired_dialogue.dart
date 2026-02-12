part of 'generic_widgets.dart';



class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key, required this.onLoginTap});

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.isDarkTheme
          ? AppColorTheme().secondary
          : AppColorTheme().lightBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Icon(Icons.info_outline, color: AppColorTheme().primary, size: 48),
          12.verticalSpace,
          Text(
            "Session Expired",
            style: context.headingText.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        "Your session has expired. Please login again to continue.",
        style: context.bodyText.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: CustomElevatedButton(title: "Login", onTap: onLoginTap),
        ),
      ],
    );
  }
}
