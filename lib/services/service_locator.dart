
import 'package:get_it/get_it.dart';
import 'package:qr_master/database/qr_master_database.dart';
import 'package:qr_master/services/notification_services.dart';
import 'package:qr_master/services/session.dart';


GetIt serviceLocator = GetIt.instance;

/*
  * Register global instance of session and database
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @return  void
  */
Future<void> setupLocator() async { 
  if (!serviceLocator.isRegistered<NotificationService>()) {
    final notificationService = NotificationService();
    await notificationService.init();
    serviceLocator.registerSingleton<NotificationService>(notificationService);
  }   
  if (!serviceLocator.isRegistered<QrMasterDatabase>()) {
   // CoolzDatabase databaseInstance = await $FloorCoolzDatabase.databaseBuilder('coolz_database.db').addMigrations(Migrations().getMigrations()).build();
    QrMasterDatabase databaseInstance = await $FloorQrMasterDatabase.databaseBuilder('qr_master_database.db').build();
    serviceLocator.registerSingleton<QrMasterDatabase>(databaseInstance);
  }
  if (!serviceLocator.isRegistered<Session>()) {
    Session session = Session();
    serviceLocator.registerSingleton<Session>(session);
  }
  
}

/*
  * set data session
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @return  void
  */
Future startSession() async {

}