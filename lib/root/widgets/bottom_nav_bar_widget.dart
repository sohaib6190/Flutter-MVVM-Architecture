part of 'widgets.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTapMaps,
    required this.onTapJobs,
    required this.onTapSocial,
    required this.onTapAds,
    required this.onTapMore,
  });

  final int currentIndex;
  final VoidCallback onTapMaps;
  final VoidCallback onTapJobs;
  final VoidCallback onTapSocial;
  final VoidCallback onTapAds;
  final VoidCallback onTapMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkTheme
            ? AerialColorTheme().black20
            : AerialColorTheme().white,
        border: Border(
          top: BorderSide(
            color: AerialColorTheme().lightGrey.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BottomNavBarItem(
            icon: AerialIcons().maps,
            isSelected: 0 == currentIndex,
            label: translate(context, 'maps'),
            onTap: onTapMaps,
          ),
          _BottomNavBarItem(
            key: jobsBottomNavKey,
            icon: AerialIcons().jobs,
            isSelected: 1 == currentIndex,
            label: translate(context, 'jobs'),
            onTap: onTapJobs,
          ),
          _BottomNavBarItem(
            key: socialBottomNavKey,
            icon: AerialIcons().social,
            isSelected: 2 == currentIndex,
            label: translate(context, 'social'),
            onTap: onTapSocial,
          ),
          _BottomNavBarItem(
            key: adsBottomNavKey,
            icon: AerialIcons().ads,
            isSelected: 3 == currentIndex,
            label: translate(context, 'ads'),
            onTap: onTapAds,
          ),
          _BottomNavBarItem(
            key: moreBottomNavKey,
            icon: AerialIcons().more,
            isSelected: 4 == currentIndex,
            label: translate(context, 'more'),
            onTap: onTapMore,
          ),
        ],
      ),
    );
  }
}

class _BottomNavBarItem extends StatelessWidget {
  const _BottomNavBarItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: isSelected ? 1 : 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isSelected
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: AerialColorTheme().primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          child: Icon(
                            icon,
                            color: AerialColorTheme().white,
                            size: 24,
                          ),
                        ),
                      )
                    : Icon(
                        icon,
                        color: context.monochromeColor,
                        size: 24,
                      ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: context.bodyText.copyWith(
                    overflow: TextOverflow.ellipsis,
                    color: context.monochromeColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
