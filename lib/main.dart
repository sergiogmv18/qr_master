import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/botton_navigator_bar_provider.dart';
import 'package:qr_master/provider/provider_history.dart';
import 'package:qr_master/provider/provider_native_ad.dart';
import 'package:qr_master/provider/provider_scanqr.dart';
import 'package:qr_master/provider/qr_create_provider.dart';
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
        ChangeNotifierProvider<ScanQrProvider>(create: (_) => ScanQrProvider()),
        ChangeNotifierProvider<ProviderHistory>(create: (_) => ProviderHistory()),
        ChangeNotifierProvider<QrCreateProvider>(create: (_) => QrCreateProvider()),
        
        ChangeNotifierProvider(
          create: (_) => NativeAdProvider(
            adUnitId: _kNativeUnitId, // troque pelo seu
            factoryId: 'install_card', // deve existir no Android/iOS
          )..load(),
        )
            
      ],
      child: const QrMaster(),
    )
  );
}

const _kNativeUnitId = String.fromEnvironment(
  'NATIVE_AD_UNIT',
  defaultValue: 'ca-app-pub-3940256099942544/2247696110', // TESTE
);
