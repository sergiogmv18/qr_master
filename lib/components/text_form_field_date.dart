


import 'package:flutter/material.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/services/function_class.dart';

Future<DateTime?> selectDate({required BuildContext context, DateTime? initialDate, DateTime? currentDate, DateTime? firstDate, DateTime? lastDate }) async {
  
  // Ajustar initialDate para que no sea anterior a firstDate
  DateTime effectiveInitialDate = initialDate ?? lastDate ?? DateTime.now();
  DateTime effectiveFirstDate = firstDate ?? DateTime(1900);
  if (effectiveInitialDate.isBefore(effectiveFirstDate)) {
    effectiveInitialDate = effectiveFirstDate;
  }
  
  // Ajustar lastDate para que no sea anterior a firstDate
  DateTime effectiveLastDate = lastDate ?? FunctionsClass.add20YearsToNow(initialDate: initialDate);
  if (effectiveLastDate.isBefore(effectiveFirstDate)) {
    effectiveLastDate = FunctionsClass.add20YearsToNow(initialDate:initialDate);
  }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode:DatePickerEntryMode.calendarOnly,
      initialDate: effectiveInitialDate,
      cancelText: translate("cancel"),
      confirmText: "Ok",
      locale: TranslationController.getInstance().locale,
      firstDate:firstDate ??  DateTime(1900),
      lastDate: effectiveLastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomColors.primary,   // color principal (header, botón ok)
              onPrimary: CustomColors.white,            // texto del header
              onSurface: CustomColors.primaryDark, // color de los días/números
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.dark, // color del botón CANCELAR / OK
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return pickedDate;
  }