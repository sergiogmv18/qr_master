import 'package:floor/floor.dart';
import 'package:qr_master/dao/repository_base_dao.dart';
import 'package:qr_master/models/qr_record.dart';

@dao
abstract class QrRecordEntityDao extends RepositoryBaseDao<QrRecordEntity> {
  @Query('SELECT * FROM qr_records')
  Future<List<QrRecordEntity>> fetchAll();

  @Query('SELECT * FROM qr_records WHERE id = :id')
  Future<QrRecordEntity?> fetchById(int id);

  @Query('DELETE FROM qr_records')
  Future<void> deleteAll();

}