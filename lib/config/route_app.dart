
import 'package:flutter/material.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/screen/home/home_screen.dart';
import 'package:qr_master/screen/qr/created_qr_screen.dart';
import 'package:qr_master/screen/qr/specific_qr_screen.dart';
import 'package:qr_master/screen/scan/scan_qr_screen.dart';
import 'package:qr_master/screen/splash_screen.dart';

class RouteAppName {
  static String splashScreen = "/";
  static String homeScreen = "/home";
  static String scanScreen = "/scan-qr";
  static String createdQrScreen = "/created-qr-screen";
  static String specificQrScreen = "/specific-qr-screen";


}



final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  RouteAppName.splashScreen: (BuildContext context) => const SplashScreen(),
  RouteAppName.homeScreen: (BuildContext context) => const HomeScreen(),
  RouteAppName.scanScreen: (BuildContext context) => const ScanQrScreen(),
  RouteAppName.createdQrScreen: (BuildContext context) => CreatedQrScreen(data: ModalRoute.of(context)!.settings.arguments as String), 
  RouteAppName.specificQrScreen: (BuildContext context) => SpecificQrScreen(qrRecord: ModalRoute.of(context)!.settings.arguments as QrRecord), 

  
  // MAIN
//  RouteApp.initalApp: (BuildContext context) => const SplashScreen(),
 // '/verify/error': (BuildContext context) => VerifyVersionScreen(errorCode: ModalRoute.of(context)!.settings.arguments as int?),
 // '/notification/setting': (BuildContext context) => NotificationSettingScreen(activating: ModalRoute.of(context)!.settings.arguments as bool?),
//  '/redirect/firebase': (BuildContext context) => RedirectFirebaseScreen( data: ModalRoute.of(context)!.settings.arguments as Map?),
};
