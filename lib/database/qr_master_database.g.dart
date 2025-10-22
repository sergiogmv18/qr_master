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

  SubscriptionPurchasesDao? _subscriptionPurchasesDaoInstance;

  UserDao? _userDaoInstance;

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
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subscription_purchases` (`productId` TEXT, `purchaseToken` TEXT, `orderId` TEXT, `purchaseDate` INTEGER, `expiryDate` INTEGER, `status` TEXT, `autoRenewing` INTEGER, `packageName` TEXT, `obfuscatedAccountId` TEXT, `obfuscatedProfileId` TEXT, `purchaseType` TEXT, `originalJson` TEXT, `verificationData` TEXT, `userId` TEXT, `quantity` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER NOT NULL, `uuid` TEXT, `needToSynchronize` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`platformId` TEXT, `email` TEXT, `deviceId` TEXT, `createdAt` INTEGER, `password` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `serverId` INTEGER NOT NULL, `uuid` TEXT, `needToSynchronize` INTEGER NOT NULL)');

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

  @override
  SubscriptionPurchasesDao get subscriptionPurchasesDao {
    return _subscriptionPurchasesDaoInstance ??=
        _$SubscriptionPurchasesDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
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

class _$SubscriptionPurchasesDao extends SubscriptionPurchasesDao {
  _$SubscriptionPurchasesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subscriptionPurchaseInsertionAdapter = InsertionAdapter(
            database,
            'subscription_purchases',
            (SubscriptionPurchase item) => <String, Object?>{
                  'productId': item.productId,
                  'purchaseToken': item.purchaseToken,
                  'orderId': item.orderId,
                  'purchaseDate': _dateTimeConverter.encode(item.purchaseDate),
                  'expiryDate': _dateTimeConverter.encode(item.expiryDate),
                  'status': item.status,
                  'autoRenewing': item.autoRenewing == null
                      ? null
                      : (item.autoRenewing! ? 1 : 0),
                  'packageName': item.packageName,
                  'obfuscatedAccountId': item.obfuscatedAccountId,
                  'obfuscatedProfileId': item.obfuscatedProfileId,
                  'purchaseType': item.purchaseType,
                  'originalJson': item.originalJson,
                  'verificationData': item.verificationData,
                  'userId': item.userId,
                  'quantity': item.quantity,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                }),
        _subscriptionPurchaseUpdateAdapter = UpdateAdapter(
            database,
            'subscription_purchases',
            ['id'],
            (SubscriptionPurchase item) => <String, Object?>{
                  'productId': item.productId,
                  'purchaseToken': item.purchaseToken,
                  'orderId': item.orderId,
                  'purchaseDate': _dateTimeConverter.encode(item.purchaseDate),
                  'expiryDate': _dateTimeConverter.encode(item.expiryDate),
                  'status': item.status,
                  'autoRenewing': item.autoRenewing == null
                      ? null
                      : (item.autoRenewing! ? 1 : 0),
                  'packageName': item.packageName,
                  'obfuscatedAccountId': item.obfuscatedAccountId,
                  'obfuscatedProfileId': item.obfuscatedProfileId,
                  'purchaseType': item.purchaseType,
                  'originalJson': item.originalJson,
                  'verificationData': item.verificationData,
                  'userId': item.userId,
                  'quantity': item.quantity,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                }),
        _subscriptionPurchaseDeletionAdapter = DeletionAdapter(
            database,
            'subscription_purchases',
            ['id'],
            (SubscriptionPurchase item) => <String, Object?>{
                  'productId': item.productId,
                  'purchaseToken': item.purchaseToken,
                  'orderId': item.orderId,
                  'purchaseDate': _dateTimeConverter.encode(item.purchaseDate),
                  'expiryDate': _dateTimeConverter.encode(item.expiryDate),
                  'status': item.status,
                  'autoRenewing': item.autoRenewing == null
                      ? null
                      : (item.autoRenewing! ? 1 : 0),
                  'packageName': item.packageName,
                  'obfuscatedAccountId': item.obfuscatedAccountId,
                  'obfuscatedProfileId': item.obfuscatedProfileId,
                  'purchaseType': item.purchaseType,
                  'originalJson': item.originalJson,
                  'verificationData': item.verificationData,
                  'userId': item.userId,
                  'quantity': item.quantity,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubscriptionPurchase>
      _subscriptionPurchaseInsertionAdapter;

  final UpdateAdapter<SubscriptionPurchase> _subscriptionPurchaseUpdateAdapter;

  final DeletionAdapter<SubscriptionPurchase>
      _subscriptionPurchaseDeletionAdapter;

  @override
  Future<List<SubscriptionPurchase>> fetchAll() async {
    return _queryAdapter.queryList('SELECT * FROM subscription_purchases',
        mapper: (Map<String, Object?> row) => SubscriptionPurchase(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            productId: row['productId'] as String?,
            purchaseToken: row['purchaseToken'] as String?,
            orderId: row['orderId'] as String?,
            purchaseDate:
                _dateTimeConverter.decode(row['purchaseDate'] as int?),
            expiryDate: _dateTimeConverter.decode(row['expiryDate'] as int?),
            status: row['status'] as String?,
            autoRenewing: row['autoRenewing'] == null
                ? null
                : (row['autoRenewing'] as int) != 0,
            packageName: row['packageName'] as String?,
            obfuscatedAccountId: row['obfuscatedAccountId'] as String?,
            obfuscatedProfileId: row['obfuscatedProfileId'] as String?,
            purchaseType: row['purchaseType'] as String?,
            originalJson: row['originalJson'] as String?,
            verificationData: row['verificationData'] as String?,
            userId: row['userId'] as String?,
            quantity: row['quantity'] as int));
  }

  @override
  Future<SubscriptionPurchase?> fetchById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM subscription_purchases WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SubscriptionPurchase(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            productId: row['productId'] as String?,
            purchaseToken: row['purchaseToken'] as String?,
            orderId: row['orderId'] as String?,
            purchaseDate:
                _dateTimeConverter.decode(row['purchaseDate'] as int?),
            expiryDate: _dateTimeConverter.decode(row['expiryDate'] as int?),
            status: row['status'] as String?,
            autoRenewing: row['autoRenewing'] == null
                ? null
                : (row['autoRenewing'] as int) != 0,
            packageName: row['packageName'] as String?,
            obfuscatedAccountId: row['obfuscatedAccountId'] as String?,
            obfuscatedProfileId: row['obfuscatedProfileId'] as String?,
            purchaseType: row['purchaseType'] as String?,
            originalJson: row['originalJson'] as String?,
            verificationData: row['verificationData'] as String?,
            userId: row['userId'] as String?,
            quantity: row['quantity'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM subscription_purchases');
  }

  @override
  Future<SubscriptionPurchase?> getSubscriptionByUuid(String uuid) async {
    return _queryAdapter.query(
        'SELECT * FROM subscription_purchases WHERE uuid = ?1',
        mapper: (Map<String, Object?> row) => SubscriptionPurchase(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            productId: row['productId'] as String?,
            purchaseToken: row['purchaseToken'] as String?,
            orderId: row['orderId'] as String?,
            purchaseDate:
                _dateTimeConverter.decode(row['purchaseDate'] as int?),
            expiryDate: _dateTimeConverter.decode(row['expiryDate'] as int?),
            status: row['status'] as String?,
            autoRenewing: row['autoRenewing'] == null
                ? null
                : (row['autoRenewing'] as int) != 0,
            packageName: row['packageName'] as String?,
            obfuscatedAccountId: row['obfuscatedAccountId'] as String?,
            obfuscatedProfileId: row['obfuscatedProfileId'] as String?,
            purchaseType: row['purchaseType'] as String?,
            originalJson: row['originalJson'] as String?,
            verificationData: row['verificationData'] as String?,
            userId: row['userId'] as String?,
            quantity: row['quantity'] as int),
        arguments: [uuid]);
  }

  @override
  Future<List<SubscriptionPurchase>> getSubscriptionsByProductId(
      String productId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subscription_purchases WHERE product_id = ?1',
        mapper: (Map<String, Object?> row) => SubscriptionPurchase(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            productId: row['productId'] as String?,
            purchaseToken: row['purchaseToken'] as String?,
            orderId: row['orderId'] as String?,
            purchaseDate:
                _dateTimeConverter.decode(row['purchaseDate'] as int?),
            expiryDate: _dateTimeConverter.decode(row['expiryDate'] as int?),
            status: row['status'] as String?,
            autoRenewing: row['autoRenewing'] == null
                ? null
                : (row['autoRenewing'] as int) != 0,
            packageName: row['packageName'] as String?,
            obfuscatedAccountId: row['obfuscatedAccountId'] as String?,
            obfuscatedProfileId: row['obfuscatedProfileId'] as String?,
            purchaseType: row['purchaseType'] as String?,
            originalJson: row['originalJson'] as String?,
            verificationData: row['verificationData'] as String?,
            userId: row['userId'] as String?,
            quantity: row['quantity'] as int),
        arguments: [productId]);
  }

  @override
  Future<List<SubscriptionPurchase>> getSubscriptionsByUserId(
      String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subscription_purchases WHERE user_id = ?1',
        mapper: (Map<String, Object?> row) => SubscriptionPurchase(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            productId: row['productId'] as String?,
            purchaseToken: row['purchaseToken'] as String?,
            orderId: row['orderId'] as String?,
            purchaseDate:
                _dateTimeConverter.decode(row['purchaseDate'] as int?),
            expiryDate: _dateTimeConverter.decode(row['expiryDate'] as int?),
            status: row['status'] as String?,
            autoRenewing: row['autoRenewing'] == null
                ? null
                : (row['autoRenewing'] as int) != 0,
            packageName: row['packageName'] as String?,
            obfuscatedAccountId: row['obfuscatedAccountId'] as String?,
            obfuscatedProfileId: row['obfuscatedProfileId'] as String?,
            purchaseType: row['purchaseType'] as String?,
            originalJson: row['originalJson'] as String?,
            verificationData: row['verificationData'] as String?,
            userId: row['userId'] as String?,
            quantity: row['quantity'] as int),
        arguments: [userId]);
  }

  @override
  Future<SubscriptionPurchase?> getActiveSubscription(int currentDate) async {
    return _queryAdapter.query(
        'SELECT * FROM subscription_purchases      WHERE status = 1 AND expiry_date > ?1     ORDER BY purchase_date DESC     LIMIT 1',
        mapper: (Map<String, Object?> row) => SubscriptionPurchase(serverId: row['serverId'] as int, id: row['id'] as int?, needToSynchronize: (row['needToSynchronize'] as int) != 0, uuid: row['uuid'] as String?, productId: row['productId'] as String?, purchaseToken: row['purchaseToken'] as String?, orderId: row['orderId'] as String?, purchaseDate: _dateTimeConverter.decode(row['purchaseDate'] as int?), expiryDate: _dateTimeConverter.decode(row['expiryDate'] as int?), status: row['status'] as String?, autoRenewing: row['autoRenewing'] == null ? null : (row['autoRenewing'] as int) != 0, packageName: row['packageName'] as String?, obfuscatedAccountId: row['obfuscatedAccountId'] as String?, obfuscatedProfileId: row['obfuscatedProfileId'] as String?, purchaseType: row['purchaseType'] as String?, originalJson: row['originalJson'] as String?, verificationData: row['verificationData'] as String?, userId: row['userId'] as String?, quantity: row['quantity'] as int),
        arguments: [currentDate]);
  }

  @override
  Future<void> updateSubscriptionStatus(
    String uuid,
    int newStatus,
    int updatedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE subscription_purchases      SET status = ?2, updated_at = ?3      WHERE uuid = ?1',
        arguments: [uuid, newStatus, updatedAt]);
  }

  @override
  Future<int?> countActiveSubscriptions(int currentDate) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM subscription_purchases      WHERE status = 1 AND expiry_date > ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [currentDate]);
  }

  @override
  Future<int> insertLocally(SubscriptionPurchase object) {
    return _subscriptionPurchaseInsertionAdapter.insertAndReturnId(
        object, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateLocally(SubscriptionPurchase object) {
    return _subscriptionPurchaseUpdateAdapter.updateAndReturnChangedRows(
        object, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteLocally(SubscriptionPurchase object) {
    return _subscriptionPurchaseDeletionAdapter
        .deleteAndReturnChangedRows(object);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'platformId': item.platformId,
                  'email': item.email,
                  'deviceId': item.deviceId,
                  'createdAt': item.createdAt,
                  'password': item.password,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'platformId': item.platformId,
                  'email': item.email,
                  'deviceId': item.deviceId,
                  'createdAt': item.createdAt,
                  'password': item.password,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'platformId': item.platformId,
                  'email': item.email,
                  'deviceId': item.deviceId,
                  'createdAt': item.createdAt,
                  'password': item.password,
                  'id': item.id,
                  'serverId': item.serverId,
                  'uuid': item.uuid,
                  'needToSynchronize': item.needToSynchronize ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> fetchAll() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            platformId: row['platformId'] as String?,
            email: row['email'] as String?,
            deviceId: row['deviceId'] as String?,
            createdAt: row['createdAt'] as int?,
            password: row['password'] as String?));
  }

  @override
  Future<User?> fetchById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            platformId: row['platformId'] as String?,
            email: row['email'] as String?,
            deviceId: row['deviceId'] as String?,
            createdAt: row['createdAt'] as int?,
            password: row['password'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM users');
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => User(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            platformId: row['platformId'] as String?,
            email: row['email'] as String?,
            deviceId: row['deviceId'] as String?,
            createdAt: row['createdAt'] as int?,
            password: row['password'] as String?),
        arguments: [email]);
  }

  @override
  Future<User?> getUserByDeviceId(String deviceId) async {
    return _queryAdapter.query('SELECT * FROM users WHERE device_id = ?1',
        mapper: (Map<String, Object?> row) => User(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            platformId: row['platformId'] as String?,
            email: row['email'] as String?,
            deviceId: row['deviceId'] as String?,
            createdAt: row['createdAt'] as int?,
            password: row['password'] as String?),
        arguments: [deviceId]);
  }

  @override
  Future<User?> getUserByPlatformId(String platformId) async {
    return _queryAdapter.query('SELECT * FROM users WHERE platform_id = ?1',
        mapper: (Map<String, Object?> row) => User(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            platformId: row['platformId'] as String?,
            email: row['email'] as String?,
            deviceId: row['deviceId'] as String?,
            createdAt: row['createdAt'] as int?,
            password: row['password'] as String?),
        arguments: [platformId]);
  }

  @override
  Future<User?> getFirstUser() async {
    return _queryAdapter.query('SELECT * FROM users LIMIT 1',
        mapper: (Map<String, Object?> row) => User(
            serverId: row['serverId'] as int,
            id: row['id'] as int?,
            needToSynchronize: (row['needToSynchronize'] as int) != 0,
            uuid: row['uuid'] as String?,
            platformId: row['platformId'] as String?,
            email: row['email'] as String?,
            deviceId: row['deviceId'] as String?,
            createdAt: row['createdAt'] as int?,
            password: row['password'] as String?));
  }

  @override
  Future<int?> checkEmailExists(String email) async {
    return _queryAdapter.query('SELECT COUNT(*) FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [email]);
  }

  @override
  Future<void> deleteByUuid(String uuid) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM users WHERE uuid = ?1', arguments: [uuid]);
  }

  @override
  Future<int> insertLocally(User object) {
    return _userInsertionAdapter.insertAndReturnId(
        object, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateLocally(User object) {
    return _userUpdateAdapter.updateAndReturnChangedRows(
        object, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteLocally(User object) {
    return _userDeletionAdapter.deleteAndReturnChangedRows(object);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
