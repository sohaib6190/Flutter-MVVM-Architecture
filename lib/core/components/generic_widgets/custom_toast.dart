
part of 'generic_widgets.dart';
class CustomToast {
  static void success(BuildContext context, String message) {
    // CherryToast.success(
    //   title: Text(message, style: TextStyle(color: AppPalette.darkGreyColor)),
    // ).show(context);
    _showToast(
      context,
      message,
      ToastificationType.success,
      primaryColor: const Color(0xFF2E7D32),
      backgroundColor: const Color(0xFFE8F5E9),
    );
  }

  static void error(BuildContext context, String message) {
    // CherryToast.error(
    //   animationType: AnimationType.fromTop,
    //   animationCurve: Curves.easeInOut,
    //   backgroundColor: Colors.redAccent.withAlpha(220),
    //   displayCloseButton: true,
    //   borderRadius: 10,
    //   toastDuration: Duration(seconds: 4),
    //   animationDuration: Duration(seconds: 1),
    //   title: Text(
    //     message,
    //     style: TextStyle(
    //       //color: AppPalette.darkGreyColor,
    //       color: Colors.white,
    //     ),
    //   ),
    // ).show(context);
    _showToast(
      context,
      message,
      ToastificationType.error,
      primaryColor: const Color(0xFFC62828),
      backgroundColor: const Color(0xFFFFEBEE),
    );
  }

  static void warning(BuildContext context, String message) {
    _showToast(
      context,
      message,
      ToastificationType.warning,
      primaryColor: Colors.orange.shade700,
      backgroundColor: Colors.orange.shade50,
    );
  }

  static void info(BuildContext context, String message) {
    _showToast(
      context,
      message,
      ToastificationType.info,
      primaryColor: Colors.blue.shade700,
      backgroundColor: Colors.blue.shade50,
    );
  }

  static void _showToast(
    BuildContext context,
    String message,
    ToastificationType type, {
    required Color primaryColor,
    required Color backgroundColor,
  }) {
    toastification.dismissAll(delayForAnimation: false);
    toastification.show(
      context: context,
      title: Text(message),
      type: type,
      style: ToastificationStyle.minimal,
      alignment: Alignment.topCenter,
      dragToClose: true,
      margin: EdgeInsets.symmetric(horizontal: 40.r),
      autoCloseDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      primaryColor: primaryColor,
      icon: Icon(Icons.info_outline, color: primaryColor),
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.endToStart,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onTap) {
          return GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(Icons.close),
            ),
          );
        },
      ),
    );
  }
}
