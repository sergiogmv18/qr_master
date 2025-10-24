import 'package:qr_master/database/qr_master_database.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/service_locator.dart';

class QrRecordController {

  Future<QrRecord> saveQrRecord({required QrRecord qrRecord})async{
    int id = await serviceLocator<QrMasterDatabase>().qrRecordEntityDao.saveLocally(qrRecord);
    qrRecord = qrRecord.copyWith(
      id: id
    );
    return qrRecord;
  }
}
