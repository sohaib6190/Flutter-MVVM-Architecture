part of 'widgets.dart';

class AuthCard extends StatelessWidget {
  final String imageUrl;
  final void Function()? onTap;
  const AuthCard({super.key, required this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColorTheme().lightBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Image.asset(imageUrl),
        ),
      ),
    );
  }
}
