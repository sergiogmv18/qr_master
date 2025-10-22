// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:qr_master/dao/qr_record_dao.dart';
import 'package:qr_master/dao/subscription_purchases_dao.dart';
import 'package:qr_master/dao/user_dao.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/models/suscriptions.dart';
import 'package:qr_master/models/users.dart';
import 'package:qr_master/services/date_time_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'qr_master_database.g.dart';




@TypeConverters([DateTimeConverter])
@Database(
  entities: [
    QrRecordEntity,
    SubscriptionPurchase,
    User,
  ], 
  version: 1
)

abstract class QrMasterDatabase extends FloorDatabase {
  QrRecordEntityDao get qrRecordEntityDao;
  SubscriptionPurchasesDao get subscriptionPurchasesDao;
  UserDao get userDao;
  
  

 /*
  * clear all tables
  * @author  SGV
  * @version 1.0 - 20250915 - initial release
  * @return  void
  */
  Future<void> clearAllTables() async {
    await database.execute('DELETE FROM Versions');
  }
}