import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qr_master/controllers/navigation_service_controller.dart';
import 'package:qr_master/screen/splash_screen.dart';
import 'package:qr_master/services/service_locator.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;




class NotificationService {
 
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); 

  // Usa un id lowercase, estable y único por app
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
    'quantax_high',                 // id (no cambiar después de publicar)
    'High Importance Notifications',// name visible al usuario
    description: 'General high-priority alerts',
    importance: Importance.high,
  );

  // Construye detalles una sola vez y reutilízalo
  late final NotificationDetails defaultNotificationDetails;


  /*
   * initialize config flutter local notification
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @return  void
   */
  Future<void> init() async {
  // 1) Permisos por plataforma
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission(); // Android 13+
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2) Settings por plataforma
    const androidInit = AndroidInitializationSettings('@drawable/ic_notification');
    const iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    // 3) Inicializa callbacks (tap en notificación)
    await flutterLocalNotificationsPlugin.initialize(initSettings,onDidReceiveNotificationResponse: (NotificationResponse details) {
        switch (details.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            // Maneja el tap en la notificación
            selectNotification(details.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            // Maneja acciones si las defines
            break;
        }
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // 4) Crea el canal en Android (Oreo+)
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    // 5) Configura NotificationDetails reusable
    defaultNotificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        threadIdentifier: 'thread_id_orders',
        categoryIdentifier: 'ORDER_CATEGORY',
        sound: 'notif.caf',
      ),
    );
    // 6) Timezones (si se va a usar zonedSchedule)
    tz.initializeTimeZones();
  }

  /*
   * config notification details
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @return  void
   */
  Future<void> configNotificationDetails()async{
  // config android here
    if (TargetPlatform.android == defaultTargetPlatform) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
      var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_notification');
      defaultNotificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          //channel.description,
          icon: initializationSettingsAndroid.defaultIcon,
          // importance: Importance.max,
          priority: Priority.high,
        ),
      );
    }
  // config ios here
    if(TargetPlatform.iOS == defaultTargetPlatform){
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      defaultNotificationDetails = const NotificationDetails(iOS: DarwinNotificationDetails(threadIdentifier: 'thread_id'));
    }
  }


  /*
   * select notification
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @param String payload
   * @return  void
   */
  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
    Map<String, dynamic> data = payload != null ? json.decode(payload) : {};
    await startSession();
    await setupLocator();
    if(data['route'] != null){
      Navigator.push(NavigationService.navigatorKey.currentContext!, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const SplashScreen()));
      return;
    }
    Navigator.push(NavigationService.navigatorKey.currentContext!, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const SplashScreen()));
  }

  /*
   * show notification
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @param int id
   * @param String title
   * @param String body
   * @return  void
   */
  Future<void> showNotification({required int id, String? title, String? body, String? payload})async{
      // show notification
    await flutterLocalNotificationsPlugin.show(id,title, body,defaultNotificationDetails, payload: payload);
  }

  /*
   * schedule notification
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @param int id
   * @param String title
   * @param String body
   * @param DateTime scheduledNotificationDate
   * @return  void
   */
  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledNotificationDate)async{
    if(!tz.TZDateTime.now(tz.local).isBefore(scheduledNotificationDate)){
      return;
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      androidScheduleMode:AndroidScheduleMode.inexact,
      tz.TZDateTime.from(scheduledNotificationDate, tz.local),
      defaultNotificationDetails,
      
      // androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  /*
   * periodically show
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @param int id
   * @param String title
   * @param String body
   * @param String payload
   * @return  void
   */
  Future<void> periodicallyShow(int id, String? title, String? body, String payload)async{
    flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      defaultNotificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexact,
      payload: payload
    );
  }

  /*
   * cancel notification
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @param int id
   * @return  void
   */
  Future<void> cancelNotification(int id)async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /*
   * cancel all notification
   * @author SGV
   * @version 1.0 - 20251010 - initial release
   * @param int id
   * @return  void
   */
  Future<void> cancelAllNotification()async{
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}