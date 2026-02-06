part of 'generic_widgets.dart';

class CustomGlobalTable extends StatelessWidget {
  const CustomGlobalTable({
    super.key,
    required this.title,
    this.isTextBold = false,
    this.value = '----',
    this.textColor,
    this.isOnlyTextCell = false,
    this.isStatusCell = false,
    this.isIconCell = false,
    this.isImageWithTextCell = false,
    this.isStatusButtonIcon = false,
    this.isOnTapText = false,
    this.isDropDownCell = false,
    this.isLineGraphCell = false,
    this.isProfileCell = false,
    this.isCheckBoxCell = false,
    this.isCheckBoxFill = false,
    this.isIconWithtextCell = false,
    this.isCenter = false,
    this.buttonText,
    this.icons,
    this.onTapFunctions,
    this.onTapText,
    this.imageText,
    this.image,
    this.buttonColor = Colors.amber,
    this.dropdowbuttonColor = Colors.black,
    this.dropdownbuttonText = "",
    this.menuItems,
    this.progress = 0,
    this.profileText = "",
    this.icon,
    this.iconColors,
    this.onItemSelected,
    this.onChanged,
  });

  final String title;
  final bool? isTextBold;
  final Color? textColor;
  final bool? isOnlyTextCell;
  final bool? isStatusCell;
  final bool? isIconCell;
  final bool? isImageWithTextCell;
  final bool? isStatusButtonIcon;
  final bool? isDropDownCell;
  final bool? isOnTapText;
  final bool? isLineGraphCell;
  final bool? isProfileCell;
  final bool? isCheckBoxCell;
  final bool? isCheckBoxFill;
  final bool? isIconWithtextCell;
  final bool? isCenter;
  final List<IconData>? icons;
  final VoidCallback? onTapText;
  final ValueChanged<bool>? onChanged;

  final List<VoidCallback>? onTapFunctions;
  final List<Color>? iconColors;
  final String? image;
  final String? imageText;
  final IconData? icon;

  final String? value;
  final String? buttonText;
  final Color? buttonColor;

  //Dropdown
  final String? dropdownbuttonText;
  final Color? dropdowbuttonColor;
  final List<String>? menuItems;
  final ValueChanged<String>? onItemSelected;

  //Percent Indicator
  final int? progress;

  //Profile
  final String? profileText;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildTitleCell(title, context),

                Divider(
                  color: AppColorTheme().lightGrey60,
                  height: 1,
                ), // Divider below title
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Vertical Divider between Title and Value
          Container(width: 1, color: AppColorTheme().lightGrey60),
          const SizedBox(width: 8),
          if (isOnlyTextCell!)
            Expanded(
              child: Column(
                children: [
                  _buildValueCell(
                    value!,
                    context,
                    isTextBold,
                    textColor ?? AppColorTheme().darkBlue,
                    onTapText ?? () {},
                    isOnTapText!,
                  ),

                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),

          if (isIconWithtextCell!)
            Expanded(
              child: Column(
                children: [
                  _buildIconWithTextCell(icon!, value!, context),

                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),

          if (isCheckBoxCell!)
            Expanded(
              child: Column(
                children: [
                  _buildCheckBoxCell(
                    context,
                    isCheckBoxFill!,
                    onChanged ?? (onChanged) {},
                  ),

                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),
          if (isProfileCell!)
            Expanded(
              child: Column(
                children: [
                  _buildProfileWithImageCell(value!, profileText!, context),

                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),

          if (isLineGraphCell!)
            Expanded(
              child: Column(
                children: [
                  _buildLineGraph(progress!, context),
                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),

          if (isIconCell!)
            Expanded(
              child: Column(
                children: [
                  _buildIconCell(
                    icons!,
                    onTapFunctions!,
                    AppColorTheme().darkBlue,
                    iconColors,
                    context,
                  ),
                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),
          if (isDropDownCell!)
            Expanded(
              child: Column(
                children: [
                  _buildDropDownWithButtonCell(
                    dropdownbuttonText!,
                    dropdowbuttonColor!,
                    menuItems!,
                    onItemSelected ?? (onItemSelected) {},
                    context,
                  ),
                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),

          if (isImageWithTextCell!)
            Expanded(
              child: Column(
                children: [
                  _buildTextWithImageCell(
                    image!,
                    imageText!,
                    isTextBold!,
                    context,
                  ),
                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),

          if (isStatusCell!)
            Expanded(
              child: Column(
                children: [
                  _buildStatusCell(
                    buttonText!,
                    buttonColor!,
                    isStatusButtonIcon!,
                    context,
                  ),
                  Divider(
                    color: AppColorTheme().lightGrey60,
                    height: 1,
                  ), // Divider below value
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildValueCell(
    String value,
    BuildContext context,
    bool? isTextBold,
    Color textColor,
    VoidCallback onTap,
    bool isOnTapText,
  ) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: AppColorTheme().white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child:
                    isOnTapText
                        ? GestureDetector(
                          onTap: onTap,
                          child: Text(
                            value,
                            style: context.bodyText.copyWith(
                              fontSize: 12,
                              color: textColor,
                              fontWeight:
                                  isTextBold!
                                      ? AppFontWeight.bold
                                      : AppFontWeight.regular,
                            ),
                          ),
                        )
                        : Text(
                          value,
                          style: context.bodyText.copyWith(
                            fontSize: 12,
                            color: textColor,
                            fontWeight:
                                isTextBold!
                                    ? AppFontWeight.bold
                                    : AppFontWeight.regular,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCell(String text, BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: AppColorTheme().darkGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
          child: Text(
            text,
            style: context.bodyText.copyWith(
              fontSize: 12,
              color: AppColorTheme().darkBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCell(
    String buttonText,
    Color buttonColor,
    bool isButtonIcon,

    BuildContext context,
  ) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: buttonColor.withValues(alpha: 0.16),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: context.bodyText.copyWith(
                        fontSize: 12,
                        color: buttonColor,
                      ),
                    ),
                  ),
                ),
              ),

              if (isButtonIcon) ...[
                const SizedBox(width: 6), // Text aur icon ke beech gap
                Icon(
                  AppIcons().downArrow,
                  color: AppColorTheme().darkBlue,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownWithButtonCell(
    String dropdownselectedItem,
    Color dropbuttoncolor,
    final List<String>? menuItems,
    final ValueChanged<String>? onItemSelected,

    BuildContext context,
  ) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Menu(
            buttonColor: dropbuttoncolor,
            buttonText: dropdownselectedItem,
            menuItems: menuItems,
            onItemSelected: (selectedItem) {
              onItemSelected!(selectedItem);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLineGraph(int progress, BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                "$progress %",
                style: context.lightText.copyWith(
                  fontSize: 16,
                  color: AppColorTheme().darkBlue,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(12),
                  value: progress / 100,
                  backgroundColor: AppColorTheme().lightGrey60,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColorTheme().primaryGradient1,
                  ),
                  minHeight: 8.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCell(
    List<IconData> icons,
    List<VoidCallback> onTapFunctions, // List of onTap functions
    Color iconColor,
    List<Color>? iconColors,
    BuildContext context,
  ) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center align icons
            children: List.generate(icons.length, (index) {
              return Flexible(
                child: GestureDetector(
                  onTap: onTapFunctions[index], // Assign tap function
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ), // Space between icons
                    child: Icon(
                      icons[index],
                      color:
                          (iconColors != null && iconColors.length > index)
                              ? iconColors[index] // Use specific color if provided
                              : AppColorTheme()
                                  .darkBlue, // Default color
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithTextCell(
    IconData icon,
    String text, // List of onTap functions

    BuildContext context,
  ) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.start, // Center align icons
            children: [
              Icon(icon, color: AppColorTheme().primaryGradient1),
              Text(
                text,
                style: context.lightText.copyWith(
                  fontSize: 12,

                  color: AppColorTheme().primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextWithImageCell(
    String image,
    String text,
    bool imageTextBold,

    BuildContext context,
  ) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  image,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                    ); // fallback if image fails to load
                  },
                ),
              ),

              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: context.bodyText.copyWith(
                    fontSize: 12,
                    fontWeight:
                        imageTextBold
                            ? AppFontWeight.bold
                            : AppFontWeight.regular,
                    color: AppColorTheme().darkBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileWithImageCell(
  String text,
  String profileText,

  BuildContext context,
) {
  return Expanded(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColorTheme().lightGrey60,
            radius: 20,
            child: Text(
              profileText,
              style: context.lightText.copyWith(
                fontSize: 16,

                color: AppColorTheme().darkGrey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: context.bodyText.copyWith(
              fontSize: 12,

              color: AppColorTheme().darkBlue,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCheckBoxCell(
  BuildContext context,
  bool value,
  ValueChanged<bool>? onChanged,
) {
  return Expanded(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
     
    ),
  );
}

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    this.buttonColor = Colors.black,
    this.buttonText = "",
    this.menuItems,
    this.isButton = true,
    this.onItemSelected,
  });

  final Color? buttonColor;
  final String? buttonText;
  final List<String>? menuItems; // CHANGED to List<String>
  final bool? isButton;
  final ValueChanged<String>? onItemSelected;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final MenuController _menuController = MenuController();
  String? _selectedText;

  void _toggleMenu() {
    _menuController.isOpen ? _menuController.close() : _menuController.open();
  }

  void _selectItem(String value) {
    setState(() {
      _selectedText = value;
    });
    _menuController.close();
    widget.onItemSelected?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.isButton!)
          Container(
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.buttonColor!.withValues(alpha: .16),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  _selectedText ?? widget.buttonText!,
                  style: context.bodyText.copyWith(
                    fontSize: 10,
                    color: widget.buttonColor,
                  ),
                ),
              ),
            ),
          ),
        MenuAnchor(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColorTheme().white,
            ),
            padding: WidgetStateProperty.all(const EdgeInsets.all(24)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          controller: _menuController,
          menuChildren:
              widget.menuItems!
                  .map(
                    (text) => GestureDetector(
                      onTap: () => _selectItem(text),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          text,
                          style: context.bodyText.copyWith(
                            color: AppColorTheme().black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          builder: (_, MenuController controller, Widget? child) {
            return GestureDetector(
              onTap: _toggleMenu,
              child: Icon(
                AppIcons().downArrow,
                color: AppColorTheme().darkBlue,
                size: 24,
              ),
            );
          },
        ),
      ],
    );
  }
}
