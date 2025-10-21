import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/botton_navigator_bar_provider.dart';
import 'package:qr_master/qr_master.dart';
import 'package:qr_master/services/service_locator.dart';





void main() async {  // Añade async aquí
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await setupLocator();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,            // fondo blanco
      statusBarIconBrightness: Brightness.dark, // Android: íconos oscuros
      statusBarBrightness: Brightness.dark,     // iOS: contenido oscuro
    )
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TranslationController.getInstance()),
        ChangeNotifierProvider<BottonNavigationBarProvider>(create: (_) => BottonNavigationBarProvider()),
      ],
      child: const QrMaster(),
    )
  );
}
