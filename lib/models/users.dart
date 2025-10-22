import 'package:floor/floor.dart';
import 'package:qr_master/models/model_base.dart';

@Entity(tableName: 'users')
class User extends ModelBase {
  final String? platformId;           // ID de Google Play/App Store (obfuscatedAccountId)
  final String? email;                // Opcional para notificaciones
  final String? deviceId;             // Identificador del dispositivo
  final int? createdAt;               // Fecha de creación en timestamp
  final String? password;             // Contraseña (hasheada)

  User({
    required super.serverId,
    super.id,
    super.needToSynchronize,
    super.uuid,
    this.platformId,
    this.email,
    this.deviceId,
    this.createdAt,
    this.password,
  });

  // CopyWith method for immutable updates
  User copyWith({
    int? serverId,
    int? id,
    bool? needToSynchronize,
    String? uuid,
    String? platformId,
    String? email,
    String? deviceId,
    int? createdAt,
    String? password,
  }) {
    return User(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      needToSynchronize: needToSynchronize ?? this.needToSynchronize,
      uuid: uuid ?? this.uuid,
      platformId: platformId ?? this.platformId,
      email: email ?? this.email,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) => identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          serverId == other.serverId &&
          id == other.id &&
          needToSynchronize == other.needToSynchronize &&
          uuid == other.uuid &&
          platformId == other.platformId &&
          email == other.email &&
          deviceId == other.deviceId &&
          createdAt == other.createdAt &&
          password == other.password;

  @override
  int get hashCode =>
      serverId.hashCode ^
      id.hashCode ^
      needToSynchronize.hashCode ^
      uuid.hashCode ^
      platformId.hashCode ^
      email.hashCode ^
      deviceId.hashCode ^
      createdAt.hashCode ^
      password.hashCode;

  @override
  String toString() {
    return 'User{serverId: $serverId, id: $id, needToSynchronize: $needToSynchronize, uuid: $uuid, platformId: $platformId, email: $email, deviceId: $deviceId, createdAt: $createdAt, password: ${password != null ? '***' : 'null'}}';
  }

  /* Creates an User object from JSON API response.
  * @author  SGV - 20250812
  * @version 1.0 - 20250812 - initial release
  *
  * @param   json - API response map
  * @return  User - Parsed user object
  *
  * Handles:
  * - Type conversion
  * - Null safety for all fields
  * - API field name mapping
  */
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      serverId: json['id'] as int,
      platformId: json['platform_id']?.toString(),
      email: json['email']?.toString(),
      deviceId: json['device_id']?.toString(),
      createdAt: json['created_at'] as int?,
      password: json['password']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'platform_id': platformId,
      'email': email,
      'device_id': deviceId,
      'created_at': createdAt,
      'password': password,
    };
  }

  // Factory for creating new user (without serverId)
  factory User.createNew({
    String? platformId,
    String? email,
    String? deviceId,
    String? password,
  }) {
    return User(
      serverId: 0, // Temporary until synced
      platformId: platformId,
      email: email,
      deviceId: deviceId,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      password: password, // En producción, esto debería estar hasheado
    );
  }

  // Helper methods
  bool get hasEmail => email != null && email!.isNotEmpty;
  
  bool get hasPlatformId => platformId != null && platformId!.isNotEmpty;
  
  bool get hasPassword => password != null && password!.isNotEmpty;

  // Para actualizar la última actividad (si necesitas tracking de uso)
  User updateLastActivity() {
    return copyWith(
      // Podrías agregar un campo lastActivityAt si lo necesitas
    );
  }

  // Para verificar credenciales básicas (si implementas login)
  bool validateCredentials(String inputEmail, String inputPassword) {
    return email == inputEmail && password == inputPassword;
  }

  // Para uso seguro - nunca loguear la contraseña real
  Map<String, dynamic> toSafeJson() {
    final json = toJson();
    json['password'] = password != null ? '***' : null;
    return json;
  }
}