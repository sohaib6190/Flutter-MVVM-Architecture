part of 'generic_widgets.dart';

class CustomSelectChipWidget extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final void Function(int) onSelected;

  const CustomSelectChipWidget({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? AppColorTheme().primary : AppColorTheme().darkBackground,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(20),
                ),
              ),
              child: Text(
                options[index],
                style: AppTextTheme().bodyText.copyWith(
                  color: isSelected ? AppColorTheme().white : AppColorTheme().red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
