
import 'package:flutter/material.dart';
import 'package:qr_master/screen/home/home_screen.dart';
import 'package:qr_master/screen/splash_screen.dart';

class RouteAppName {
  static String splashScreen = "/";
  static String homeScreen = "/home";


}



final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  RouteAppName.splashScreen: (BuildContext context) => const SplashScreen(),
  RouteAppName.homeScreen: (BuildContext context) => const HomeScreen(),
  // MAIN
//  RouteApp.initalApp: (BuildContext context) => const SplashScreen(),
 // '/verify/error': (BuildContext context) => VerifyVersionScreen(errorCode: ModalRoute.of(context)!.settings.arguments as int?),
 // '/notification/setting': (BuildContext context) => NotificationSettingScreen(activating: ModalRoute.of(context)!.settings.arguments as bool?),
//  '/redirect/firebase': (BuildContext context) => RedirectFirebaseScreen( data: ModalRoute.of(context)!.settings.arguments as Map?),
};
