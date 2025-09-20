part of 'generic_widgets.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.popPage(),
      child: CircleAvatar(
        backgroundColor: context.isDarkTheme
            ? AppColorTheme().secondary
            : AppColorTheme().white,
        radius: 18,
        child: Icon(
          AppIcons().back,
          size: 15,
          color: context.monochromeColor,
        ),
      ),
    );
  }
}
