// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:qr_master/dao/qr_record_dao.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/date_time_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'qr_master_database.g.dart';




@TypeConverters([DateTimeConverter])
@Database(
  entities: [
    QrRecordEntity,
  ], 
  version: 1
)

abstract class QrMasterDatabase extends FloorDatabase {
  QrRecordEntityDao get qrRecordEntityDao;
  

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