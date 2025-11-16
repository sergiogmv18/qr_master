import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';

textFormPhoneNumber(BuildContext context, {required TextEditingController? textFieldController, PhoneNumber? initialValue, required void Function(PhoneNumber)? onInputChanged, bool requiredField = true}){
    return InternationalPhoneNumberInput(
      keyboardAction: TextInputAction.next,
      initialValue: initialValue,
      textFieldController:textFieldController,
      onInputChanged:onInputChanged,
      ignoreBlank:requiredField,
      locale:TranslationController.getInstance().defaultLocale,
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
     
      errorMessage:translate("invalid phone number"),
      selectorTextStyle:  Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
      textStyle:  Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
      formatInput: true,
      inputDecoration:InputDecoration(
        hintText:translate("phone number"),
        labelText:translate("phone number"),
        contentPadding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
        labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
        fillColor:CustomColors.primaryDark,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,  
        errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith( color: Theme.of(context).colorScheme.error),
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
        border: OutlineInputBorder(
          gapPadding: 4,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(color: CustomColors.white, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(color: CustomColors.error, width: 1),
        ),
        // BORDE HABILITADO
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(color: CustomColors.white, width: 1),
        ),

        // BORDE ENFOCADO
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(
            color: CustomColors.white,
            width: 1.2,
          ),
        ),
        // BORDE ERROR
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(color: CustomColors.error, width: 1),
        ),
      ),
      searchBoxDecoration: InputDecoration(
        labelText: translate("search and select country"),
        labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primaryDark),
        fillColor: CustomColors.white,
        filled: true,
      ),
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
     
    );
  }