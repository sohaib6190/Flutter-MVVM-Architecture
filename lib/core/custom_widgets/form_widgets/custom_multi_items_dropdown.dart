part of 'form_widgets.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final String hintText;
  final List<CustomDropDownOption> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final Widget? suffixIcon;
  final Widget? error;
  final Color? fillColor;

  const CustomMultiSelectDropdown({
    super.key,
    required this.hintText,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.suffixIcon,
    this.error,
    this.fillColor,
  });

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              selectedValues.isEmpty
                  ? widget.hintText
                  : widget.options
                      .where((opt) => selectedValues.contains(opt.value))
                      .map((opt) => opt.displayOption)
                      .join(', '),
              style: context.bodyText.copyWith(
                fontSize: 14,
                color: AppColorTheme().blue,
              ),
              maxLines: 2,
            ),
            items:
                widget.options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.value,
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = selectedValues.contains(
                          option.value,
                        );
                        return InkWell(
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? selectedValues.remove(option.value)
                                  : selectedValues.add(option.value);
                              widget.onChanged(selectedValues);
                            });
                            menuSetState(() {});
                          },
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color:
                                      isSelected
                                          ? Theme.of(context).primaryColor
                                          : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    option.displayOption,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
            value: null,
            selectedItemBuilder: (_) {
              return List.generate(widget.options.length, (index) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedValues
                        .map(
                          (id) =>
                              widget.options
                                  .firstWhere((opt) => opt.value == id)
                                  .displayOption,
                        )
                        .join(', '),
                    style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                );
              });
            },

            onChanged: (_) {},
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(left: 16, right: 8),
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: AppColorTheme().black20),
                borderRadius: BorderRadius.circular(8),
                color: widget.fillColor ?? Colors.transparent,
              ),
            ),
            dropdownStyleData: const DropdownStyleData(maxHeight: 300),
            iconStyleData: IconStyleData(
              icon: widget.suffixIcon ?? const Icon(Icons.arrow_drop_down),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        if (widget.error != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: widget.error!),
      ],
    );
  }
}
