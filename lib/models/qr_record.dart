import 'package:floor/floor.dart';
import 'package:qr_master/models/model_base.dart';

@Entity(tableName: 'qr_records')
class QrRecordEntity extends ModelBase {
  final String? content;               // valor crudo (ej. URL, texto, vCard)
  final DateTime? createdAt;
  final String? imagePath;            // si lo creaste y guardaste PNG/JPG
  final String? fgColorHex;           // color de módulos (hex)
  final String? bgColorHex;           // color de fondo (hex)
  final String? logoPath;             // logo incrustado (opcional)
  final String? meta;   // wifi: ssid/auth; vcard: campos, etc.

  QrRecordEntity({
    required super.serverId,
    super.id,
    super.needToSynchronize,
    super.uuid,
    this.content,
    this.createdAt,
    this.imagePath,
    this.fgColorHex,
    this.bgColorHex,
    this.logoPath,
    this.meta,
  });

  // CopyWith method for immutable updates
  QrRecordEntity copyWith({
    int? serverId,
    int? id,
    bool? needToSynchronize,
    String? uuid,
    String? content,
    DateTime? createdAt,
    String? imagePath,
    String? fgColorHex,
    String? bgColorHex,
    String? logoPath,
    String? meta,
  }) {
    return QrRecordEntity(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      needToSynchronize: needToSynchronize ?? this.needToSynchronize,
      uuid: uuid ?? this.uuid,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      imagePath: imagePath ?? this.imagePath,
      fgColorHex: fgColorHex ?? this.fgColorHex,
      bgColorHex: bgColorHex ?? this.bgColorHex,
      logoPath: logoPath ?? this.logoPath,
      meta: meta ?? this.meta,
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) => identical(this, other) ||
      other is QrRecordEntity &&
          runtimeType == other.runtimeType &&
          serverId == other.serverId &&
          id == other.id &&
          needToSynchronize == other.needToSynchronize &&
          uuid == other.uuid &&
          content == other.content &&
          createdAt == other.createdAt &&
          imagePath == other.imagePath &&
          fgColorHex == other.fgColorHex &&
          bgColorHex == other.bgColorHex &&
          logoPath == other.logoPath &&
          meta == other.meta;



  @override
  int get hashCode =>
      serverId.hashCode ^
      id.hashCode ^
      needToSynchronize.hashCode ^
      uuid.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      imagePath.hashCode ^
      fgColorHex.hashCode ^
      bgColorHex.hashCode ^
      logoPath.hashCode ^
      meta.hashCode;

  @override
  String toString() {
    return 'QrRecordEntity{serverId: $serverId, id: $id, needToSynchronize: $needToSynchronize, uuid: $uuid, content: $content, createdAt: $createdAt, imagePath: $imagePath, fgColorHex: $fgColorHex, bgColorHex: $bgColorHex, logoPath: $logoPath, meta: $meta}';
  }

  /* Creates an QrRecordEntity object from JSON API response.
  * @author  SGV - 20250812
  * @version 1.0 - 20250812 - initial release
  *
  * @param   json - API response map
  * @return  QrRecordEntity - Parsed QR record object
  *
  * Handles:
  * - Type conversion (int/double to String)
  * - Null safety for all fields
  * - API field name mapping
  * - DateTime parsing
  */
  factory QrRecordEntity.fromJson(Map<String, dynamic> json) {
    return QrRecordEntity(
      serverId: json['id'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      imagePath: json['image_path']?.toString(),
      fgColorHex: json['fg_color_hex']?.toString(),
      bgColorHex: json['bg_color_hex']?.toString(),
      logoPath: json['logo_path']?.toString(),
      // meta: json['meta'] != null 
      //     ? Map<String, dynamic>.from(json['meta'] as Map)
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'image_path': imagePath,
      'fg_color_hex': fgColorHex,
      'bg_color_hex': bgColorHex,
      'logo_path': logoPath,
      'meta': meta,
    };
  }

  // Additional helper methods for QR functionality
  bool get hasCustomDesign => fgColorHex != null || bgColorHex != null || logoPath != null;
  
  bool get isUrl => content!.startsWith(RegExp(r'https?://'));
  
  // String get displayType {
  //   if (content.startsWith('BEGIN:VCARD')) return 'Contacto';
  //   if (content.startsWith('WIFI:')) return 'WiFi';
  //   if (content.startsWith('mailto:')) return 'Email';
  //   if (isUrl) return 'URL';
  //   return 'Texto';
  // }

  // Factory for creating new QR records (without serverId)
  factory QrRecordEntity.createNew({
    required String content,
    String? imagePath,
    String? fgColorHex,
    String? bgColorHex,
    String? logoPath,
    String? meta,
  }) {
    return QrRecordEntity(
      serverId: 0, // Temporary until synced
      content: content,
      createdAt: DateTime.now(),
      imagePath: imagePath,
      fgColorHex: fgColorHex,
      bgColorHex: bgColorHex,
      logoPath: logoPath,
      meta: meta,
    );
  }
}