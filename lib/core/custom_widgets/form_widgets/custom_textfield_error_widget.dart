part of 'form_widgets.dart';

class CustomTextfieldErrorWidget extends StatelessWidget {
  const CustomTextfieldErrorWidget({
    super.key,
    required this.title,
    this.padding,
    this.spacing,
  });

  final String? title;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return title != null
        ? Padding(
            padding: padding ?? const EdgeInsets.only(left: 15, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(AppIcons().error,
                    size: 16, color: AppColorTheme().red),
                SizedBox(width: spacing ?? 16),
                Flexible(
                  child: Text(title!,
                      style: context.lightText.copyWith(
                          color: AppColorTheme().red, fontSize: 14)),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
