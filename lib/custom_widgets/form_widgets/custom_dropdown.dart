part of 'form_widgets.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.options = const [],
    this.value,
    this.onChanged,
    this.isDense = true,
    this.filled = true,
    this.fillColor,
    this.dropdownColor,
    this.suffixIcon,
    this.prefixIcon,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.contentPadding,
    this.placeholderText,
    this.placeholderStyle,
    this.expandIconColor,
    this.error,
  });

  final List<CustomDropDownOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool? isDense;
  final bool? filled;
  final Color? fillColor;
  final Color? dropdownColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final EdgeInsetsGeometry? contentPadding;
  final String? placeholderText;
  final TextStyle? placeholderStyle;
  final Color? expandIconColor;
  final Widget? error;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: false,
      dropdownColor: dropdownColor ??
          (context.isDarkTheme
              ? AppColorTheme().secondary
              : AppColorTheme().white),
      borderRadius: BorderRadius.circular(16),
      icon: Icon(
        Icons.expand_more,
        color: expandIconColor ?? context.monochromeColor,
      ),
      hint: Text(
        placeholderText ?? 'Select',
        style: placeholderStyle ??
            context.bodyText.copyWith(
                color: context.monochromeColor.withValues(alpha: 0.4),
                fontSize: 16),
      ),
      items: options.map((option) {
        return DropdownMenuItem(
            value: option.value,
            child: Text(
              option.displayOption,
              style: context.bodyText.copyWith(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ));
      }).toList(),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        filled: filled,
        fillColor: fillColor ??
            (context.isDarkTheme
                ? AppColorTheme().secondary
                : AppColorTheme().white),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
        errorBorder: errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
        focusedErrorBorder: focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
        isDense: isDense,
        error: error,
      ),
      style: context.bodyText,
      value: value,
      onChanged: onChanged,
    );
  }
}

class CustomDropDownOption<T> {
  final T value;
  final String displayOption;

  const CustomDropDownOption({
    required this.value,
    required this.displayOption,
  });
}
