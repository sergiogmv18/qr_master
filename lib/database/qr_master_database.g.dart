// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_master_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $QrMasterDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $QrMasterDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $QrMasterDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<QrMasterDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorQrMasterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $QrMasterDatabaseBuilderContract databaseBuilder(String name) =>
      _$QrMasterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $QrMasterDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$QrMasterDatabaseBuilder(null);
}

class _$QrMasterDatabaseBuilder implements $QrMasterDatabaseBuilderContract {
  _$QrMasterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $QrMasterDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $QrMasterDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<QrMasterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$QrMasterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$QrMasterDatabase extends QrMasterDatabase {
  _$QrMasterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  QrRecordEntityDao? _qrRecordEntityDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `qr_records` (`content` TEXT, `createdAt` INTEGER, `imagePath` TEXT, `fgColorHex` TEXT, `bgColorHex` TEXT, `logoPath` TEXT, `meta` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER NOT NULL, `uuid` TEXT, `needToSynchronize` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  QrRecordEntityDao get qrRecordEntityDao {
    return _qrRecordEntityDaoInstance ??=
        _$QrRecordEntityDao(database, changeListener);
  }
}

class _$QrRecordEntityDao extends QrRecordEntityDao {
  _$QrRecordEntityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _qrRecordEntityInsertionAdapter = InsertionAdapter(
            database,
            'qr_records',
            (QrRecordEntity item) => <String, Object?>{
                  'content': item.content,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'imagePath': item.imagePath,
                  'fgColorHex': item.fgColorHex,
                  'bgColorHex': item.bgColorHex,
                  'logoPath': item.logoPath,
                  'meta': item.meta,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                }),
        _qrRecordEntityUpdateAdapter = UpdateAdapter(
            database,
            'qr_records',
            ['id'],
            (QrRecordEntity item) => <String, Object?>{
                  'content': item.content,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'imagePath': item.imagePath,
                  'fgColorHex': item.fgColorHex,
                  'bgColorHex': item.bgColorHex,
                  'logoPath': item.logoPath,
                  'meta': item.meta,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                }),
        _qrRecordEntityDeletionAdapter = DeletionAdapter(
            database,
            'qr_records',
            ['id'],
            (QrRecordEntity item) => <String, Object?>{
                  'content': item.content,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'imagePath': item.imagePath,
                  'fgColorHex': item.fgColorHex,
                  'bgColorHex': item.bgColorHex,
                  'logoPath': item.logoPath,
                  'meta': item.meta,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QrRecordEntity> _qrRecordEntityInsertionAdapter;

  final UpdateAdapter<QrRecordEntity> _qrRecordEntityUpdateAdapter;

  final DeletionAdapter<QrRecordEntity> _qrRecordEntityDeletionAdapter;

  @override
  Future<List<QrRecordEntity>> fetchAll() async {
    return _queryAdapter.queryList('SELECT * FROM qr_records',
        mapper: (Map<String, Object?> row) => QrRecordEntity(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            content: row['content'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int?),
            imagePath: row['imagePath'] as String?,
            fgColorHex: row['fgColorHex'] as String?,
            bgColorHex: row['bgColorHex'] as String?,
            logoPath: row['logoPath'] as String?,
            meta: row['meta'] as String?));
  }

  @override
  Future<QrRecordEntity?> fetchById(int id) async {
    return _queryAdapter.query('SELECT * FROM qr_records WHERE id = ?1',
        mapper: (Map<String, Object?> row) => QrRecordEntity(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            content: row['content'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int?),
            imagePath: row['imagePath'] as String?,
            fgColorHex: row['fgColorHex'] as String?,
            bgColorHex: row['bgColorHex'] as String?,
            logoPath: row['logoPath'] as String?,
            meta: row['meta'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM qr_records');
  }

  @override
  Future<int> insertLocally(QrRecordEntity object) {
    return _qrRecordEntityInsertionAdapter.insertAndReturnId(
        object, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateLocally(QrRecordEntity object) {
    return _qrRecordEntityUpdateAdapter.updateAndReturnChangedRows(
        object, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteLocally(QrRecordEntity object) {
    return _qrRecordEntityDeletionAdapter.deleteAndReturnChangedRows(object);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
