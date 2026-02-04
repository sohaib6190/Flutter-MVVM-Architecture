part of 'widgets.dart';

class PlanToggleSwitch extends StatefulWidget {
  final bool isYearly;
  final Function(bool) onToggle;

  const PlanToggleSwitch({
    super.key,
    required this.isYearly,
    required this.onToggle,
  });

  @override
  State<PlanToggleSwitch> createState() => _PlanToggleSwitchState();
}

class _PlanToggleSwitchState extends State<PlanToggleSwitch> {
  late bool isYearly;

  @override
  void initState() {
    super.initState();
    isYearly = widget.isYearly;
  }

  void toggle() {
    setState(() {
      isYearly = !isYearly;
      widget.onToggle(isYearly);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Container(
        height: 28,
        width: 140,
        decoration: BoxDecoration(
          color: AppColorTheme().lightGrey70,
          borderRadius: BorderRadius.circular(62),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment:
                  isYearly ? Alignment.centerRight : Alignment.centerLeft,
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                width: 70,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColorTheme().primary,
                  borderRadius: BorderRadius.circular(62),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Monthly',
                      style: context.bodyText.copyWith(
                        fontSize: 14,
                        color: isYearly
                            ? AppColorTheme().black
                            : AppColorTheme().white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Yearly',
                      style: context.bodyText.copyWith(
                        fontSize: 14,
                        color: isYearly
                            ? AppColorTheme().white
                            : AppColorTheme().black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
