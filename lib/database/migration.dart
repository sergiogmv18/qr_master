import 'package:floor/floor.dart';

class Migrations {

  /*
   * migration version 1 to 2
   * @author  SGV
   * @version 1.0 - 20220606 - initial release
   * @return  Migration
  */
  Migration _databaseMigrationVersion1To2(){
    final migration1to2 = Migration(1, 2, (database) async {
      await database.execute('CREATE TABLE IF NOT EXISTS `VersionsApp` (`versionApp` TEXT, `updateVersion` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER)');
      await database.execute('CREATE TABLE IF NOT EXISTS `CategoryApp` (`dataInJson` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER)');
      await database.execute('CREATE TABLE IF NOT EXISTS `FinalUserData` (`dataInJson` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER)');
      await database.execute('CREATE TABLE IF NOT EXISTS `CredictRequest` (`dataInJson` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER)');
      await database.execute('CREATE TABLE IF NOT EXISTS `CashbackBase` (`dataInJson` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER)');
    });
    return migration1to2;
  }
  List<Migration> getMigrations(){
    List<Migration> migrations = [
      _databaseMigrationVersion1To2(),
    ];
    return migrations;
  }
}