import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:qr_master/services/notification_services.dart';
import 'package:qr_master/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PushNotificationController {
  /*
   * initialize firebase service
   * @author SGV
   * @version 1.0 - 20250810 - initial release
   * @return  void
   */
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();
    await PushNotificationController.configNotificationDetails(showIosNotification: false);
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // onBackgroundMessage
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(firebaseMessagingFrontHandler);
    // get device token
    await PushNotificationController().getDeviceToken();
  }


  /*
  * get device token
  * @author SGV
  * @version 1.0 - 20250810 - initial release
  * @param <bool> - changeDeviceToken - true = detete device token 
  *                                   - false = no change device token  
  * @return  String|null
  */
  Future<String?> getDeviceToken([bool changeDeviceToken = false]) async {
    if (changeDeviceToken) {
      await FirebaseMessaging.instance.deleteToken();
    }
    final prefs = await SharedPreferences.getInstance();
    String? deviceToken;
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
      FunctionsClass.debugDumpAndDie("############### My DeviceToken #################");
     FunctionsClass.debugDumpAndDie(deviceToken ?? "device token null");
      prefs.setString('platformIdentifier', deviceToken!);
    } catch (e) {
      deviceToken = null;
      FunctionsClass.debugDumpAndDie("############## Failed to get deviceToken #############");
    }
    return deviceToken;
  }

 /*
  * config notification details
  * @author SGV
  * @version 1.0 - 20250810 - initial release
  * @return  void
  */
  static Future<void> configNotificationDetails({bool showIosNotification = false}) async {
    // config ios here
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      await FirebaseMessaging.instance.requestPermission(alert: showIosNotification, badge: showIosNotification, sound: showIosNotification, criticalAlert: true);
      await FirebaseMessaging.instance.setAutoInitEnabled(showIosNotification);
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: showIosNotification, badge: showIosNotification, sound: showIosNotification);
    }
  }

  /*
   * show notification
   * @author SGV
   * @version 1.0 - 20250810 - initial release
   * @param <Map> data <indexed Map> with <bool> showNotificationForUser
   *                                      <String >title
   *                                      <String >body
   * @return  void
   */
  static void showNotification(Map<String, dynamic> data, String title, String body) {
    // show notification
    serviceLocator<NotificationService>().showNotification(id: data.hashCode, title:title, body:body, payload: json.encode(data));
  }

  /*
  * execute action requested by server
  * @author SGV
  * @version 1.0 - 20250810 - initial release
  * @param <RemoteMessage> message
  * @return  void
  */
  static Future<void> executeActionRequestedByServer(RemoteMessage message) async {
      FunctionsClass.debugDumpAndDie('******************execute firebase **********************');
      FunctionsClass.debugDumpAndDie(message.data.toString());
      await PushNotificationController.configNotificationDetails();
      //Map<String, dynamic> data = message.data;
// create your action here...
      // await BaseController().runWeekendReminder();  
  }

  /*
  * verification notifycation setting in ios
  * @author SGVn n 
  * @version 1.0 - 20250810 - initial release
  * @return  bool
  */
  verifyStatusOfNotification() async {
    bool notificationSettingEnabled = false;
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional) {
      notificationSettingEnabled = true;
    }
    return notificationSettingEnabled;
  }
  
}

/*
 * firebase messaging background handler
 * @author SGV
 * @version 1.0 - 20250810 - initial release
 * @return  void
**/
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //await PushNotificationController.configNotificationDetails(showIosNotification: false);
  FunctionsClass.debugDumpAndDie('Firebase background handler');
  await PushNotificationController.configNotificationDetails(showIosNotification: false);
  await PushNotificationController.executeActionRequestedByServer(message);
}

/*
* firebase messaging front handler
* @author SGV
* @version 1.0 - 20250810 - initial release
* @return  void
*/
Future<void> firebaseMessagingFrontHandler(RemoteMessage message) async {
  FunctionsClass.debugDumpAndDie('Firebase *front* handler');
  await PushNotificationController.configNotificationDetails(showIosNotification: true);
  await PushNotificationController.executeActionRequestedByServer(message);
}