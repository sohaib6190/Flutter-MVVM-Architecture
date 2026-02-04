part of 'widgets.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.icon,
    this.suffixIcon,
    this.prefixIcon,
    required this.error,
  });

  final String? initialValue;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final IconData? icon;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? error;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText,
      filled: false,
      hintText: hintText,
      hintStyle: context.bodyText.copyWith(
          fontSize: 14, color: AppColorTheme().black.withValues(alpha: 0.5)),
      contentStyle: context.bodyText
          .copyWith(fontSize: 14, color: AppColorTheme().black),
      prefixIcon: prefixIcon ??
          Icon(
            icon,
            color: AppColorTheme().primary,
          ),
      contentPadding: EdgeInsets.zero,
      suffixIcon: suffixIcon,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      ),
      error: error,
    );
  }
}
