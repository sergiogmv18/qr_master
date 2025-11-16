import 'package:flutter/material.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';

class AppDropdown<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final String label;
  final double? width;
  final bool enableFilter;
  final Widget? leadingIcon;
  const AppDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.label,
    this.width,
    this.enableFilter = false,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {   // texto secundario     // cian de tu bottom bar
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white), // const TextStyle( color: textPri, fontSize: 16, fontWeight: FontWeight.w600),
          menuStyle: MenuStyle(
            backgroundColor: const WidgetStatePropertyAll(CustomColors.secundaryColor),
            elevation: const WidgetStatePropertyAll(12),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.borderRadius)),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            iconColor: CustomColors.primary,
            prefixIconColor: CustomColors.primary,
            fillColor: CustomColors.primaryDark,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
            hintStyle:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              borderSide: const BorderSide(color: CustomColors.white, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              borderSide: BorderSide(color: CustomColors.white, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              borderSide: const BorderSide(color: CustomColors.primary, width: 1.6),
            ),
          ),
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
            border: Border.all( color: CustomColors.white),
        ),
        child: DropdownMenu<T>(
          width: width,
          trailingIcon:Icon(Icons.keyboard_arrow_down, color: CustomColors.white),
          selectedTrailingIcon: Icon(Icons.keyboard_arrow_up, color: CustomColors.white),
          controller: enableFilter ? TextEditingController() : null,
          enableFilter: enableFilter,
          requestFocusOnTap: false,
          menuHeight: 320,
          label: Text(label),
          leadingIcon: leadingIcon,
          dropdownMenuEntries: items,
          initialSelection: value,
          onSelected: onChanged,
        ),
      ),
    );
  }
}
