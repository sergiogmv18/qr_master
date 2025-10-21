// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

/// 1) Paleta centralizada (cambia aquí = cambia en toda la app).
class CustomColors {
  CustomColors._();

  // Brand / básicos (más divertidos)
  static const Color primary       = Color(0xFF00E5FF); // teal eléctrico
  static const Color primaryDark   = Color(0xFF0D1826);
  static const Color dark          = Colors.black;
  static const Color white          = Colors.white;
  static const Color secundaryColor = Color(0XFF07598C);
  static const Color secundary      = Color(0xFF7C3AED);
  static const Color blueSecundary  = Color(0XFF2A24BF);

  // Estados
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFD166);
  static const Color error   = Color(0xFFFF4D4D);

}



 
/// 2) ThemeData (Material 3) usando la paleta nueva.
/// Nota: desde Flutter 3.18, no uses ColorScheme.background/onBackground.
class QrMasterTheme {

 final ThemeData theme = ThemeData(
    useMaterial3: false,
    fontFamily: 'Inter',
    primaryColor: CustomColors.white,
    primaryColorDark:  CustomColors.dark,
    colorScheme: ColorScheme.fromSwatch().copyWith(primary: CustomColors.dark),
    iconTheme: IconThemeData(color:  CustomColors.dark),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: ThemeData().textTheme.bodySmall,
      hintStyle: ThemeData().textTheme.bodySmall,
    ),
  );

}

