import 'package:floor/floor.dart';
import 'package:qr_master/dao/repository_base_dao.dart';
import 'package:qr_master/models/users.dart';

@dao
abstract class UserDao extends RepositoryBaseDao<User> {
  @Query('SELECT * FROM users')
  Future<List<User>> fetchAll();

  @Query('SELECT * FROM users WHERE id = :id')
  Future<User?> fetchById(int id);

  @Query('DELETE FROM users')
  Future<void> deleteAll();

   @Query('SELECT * FROM users WHERE email = :email')
  Future<User?> getUserByEmail(String email);

  @Query('SELECT * FROM users WHERE device_id = :deviceId')
  Future<User?> getUserByDeviceId(String deviceId);

  @Query('SELECT * FROM users WHERE platform_id = :platformId')
  Future<User?> getUserByPlatformId(String platformId);

  @Query('SELECT * FROM users LIMIT 1')
  Future<User?> getFirstUser();

  @Query('SELECT COUNT(*) FROM users WHERE email = :email')
  Future<int?> checkEmailExists(String email);

  @Query('DELETE FROM users WHERE uuid = :uuid')
  Future<void> deleteByUuid(String uuid);

}