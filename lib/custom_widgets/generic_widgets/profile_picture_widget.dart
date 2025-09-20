part of 'generic_widgets.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget(
      {super.key, required this.onTap, this.radius, this.profilePic,});

  final void Function() onTap;
  final double? radius;
  final String? profilePic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius ?? 24,
        backgroundColor: AppColorTheme().lightGrey,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.monochromeColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: profilePic != null
                ? Image.network(
                    '${AppApis.baseUrl}$profilePic',
                    fit: BoxFit.cover,
                    height: double.maxFinite,
                    width: double.maxFinite,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return ShimmerWidget.fromColors(
                          baseColor: context.shimmerBaseColor,
                          highlightColor: context.shimmerHighlightColor,
                          child: Container(
                            color: AppColorTheme().white,
                          ),
                        );
                      } else {
                        return child;
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        AppIcons().profile,
                        color: AppColorTheme().primary,
                      );
                    },
                  )
                : Icon(AppIcons().profile,
                    color: AppColorTheme().primary),
          ),
        ),
      ),
    );
  }
}
