import 'package:floor/floor.dart';
import 'package:qr_master/dao/repository_base_dao.dart';
import 'package:qr_master/models/qr_record.dart';

@dao
abstract class QrRecordEntityDao extends RepositoryBaseDao<QrRecord> {
  @Query('SELECT * FROM qr_records')
  Future<List<QrRecord?>> fetchAll();

  @Query('SELECT * FROM qr_records WHERE id = :id')
  Future<QrRecord?> fetchById(int id);

  @Query('SELECT * FROM qr_records WHERE type = :type')
  Future<List<QrRecord>> fetchAllType(int type);

  @Query('DELETE FROM qr_records')
  Future<void> deleteAll();

}