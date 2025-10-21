import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/navigation_service_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';

class QrMaster extends StatelessWidget {
  const QrMaster({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Master: Scanner & Creator',
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: const[
        TranslationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: routes,
      theme: QrMasterTheme().theme,
      supportedLocales: TranslationController.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
} 