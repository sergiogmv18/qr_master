import 'package:floor/floor.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/content_type.dart';
import 'package:qr_master/models/model_base.dart';

@Entity(tableName: 'qr_records')
class QrRecord extends ModelBase {
  final String? content;               // valor crudo (ej. URL, texto, vCard)
  final DateTime? createdAt;
  final String? imagePath;            // si lo creaste y guardaste PNG/JPG
  final String? fgColorHex;           // color de módulos (hex)
  final String? bgColorHex;           // color de fondo (hex)
  final String? logoPath;             // logo incrustado (opcional)
  final String? meta;   // wifi: ssid/auth; vcard: campos, etc.
  final BarcodeFormat? symbology; 
  final int? type;
  
  QrRecord({
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
    this.symbology,
    this.type,
  });

  static const int typeScan = 1;
  static const int typeCreate = 2;


  // CopyWith method for immutable updates
  QrRecord copyWith({
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
    BarcodeFormat? symbology,
    int? type
  }) {
    return QrRecord(
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
      symbology : symbology ?? this.symbology,
      type: type ?? this.type
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) => identical(this, other) ||
      other is QrRecord &&
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
          symbology == other.symbology &&
          type == other.type &&
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
      symbology.hashCode ^
      type.hashCode ^
      meta.hashCode;

  @override
  String toString() {
    return 'QrRecord{serverId: $serverId, id: $id, symbology:${symbology?.name} ,type:$type, needToSynchronize: $needToSynchronize, uuid: $uuid, content: $content, createdAt: $createdAt, imagePath: $imagePath, fgColorHex: $fgColorHex, bgColorHex: $bgColorHex, logoPath: $logoPath, meta: $meta}';
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
      "symbology":symbology?.name,
      "type":type
    };
  }


  
  // String get displayType {
  //   if (content.startsWith('BEGIN:VCARD')) return 'Contacto';
  //   if (content.startsWith('WIFI:')) return 'WiFi';
  //   if (content.startsWith('mailto:')) return 'Email';
  //   if (isUrl) return 'URL';
  //   return 'Texto';
  // }

  // Factory for creating new QR records (without serverId)
  factory QrRecord.empyt() {
    return QrRecord(
      serverId: 0,
    );
  }


  getAllTypeOfQR(){
    List<Map<String,dynamic>> allTypeOfQR = [
      {
        "name":translate("web site"),
        "url": "",
        "icon":"",
      },
      {
        "name":translate("contact"),
        "url": "",
        "icon":"",
      },
      {
        "name":translate("text"),
        "url": "",
        "icon":"",
      },
      {
        "name":translate("email address"),
        "url": "",
        "icon":"",
      },
      {
        "name":translate("wifi"),
        "url": "",
        "icon":"",
      },
      {
        "name":translate("location"),
        "url": "",
        "icon":"",
      },
      {
        "name":translate("event"),
        "url": "",
        "icon":"",
      },
      {
        "name":translate("SMS"),
        "url": "",
        "icon":"",
      },
    ];
    return allTypeOfQR;
  }

  geAllType2Dcode(){
    List<Map<String,dynamic>> allTypeOfQR2D = [
      {
        "name":translate("QR code"),
        "url": "",
        "barcode":BarcodeFormat.qrCode,
        "descriptions":translate("text"),
        "icon":"",
      },
      {
        "name":translate("data matrix"),
        "url": "",
        "barcode":BarcodeFormat.dataMatrix,
        "descriptions":translate("text without special characters"),
        "icon":"",
      },
      {
        "name":translate("PDF 417"),
        "url": "",
        "barcode":BarcodeFormat.pdf417,
        "descriptions":translate(""),
        "icon":"",
      },
      {
        "name":translate("AZtec"),
        "url": "",
        "barcode":BarcodeFormat.aztec,
        "descriptions":translate("text without special characters"),
        "icon":"",
      },
      {
        "name":translate("EAN 13"),
        "url": "",
        "barcode":BarcodeFormat.ean13,
        "descriptions":translate("12 digits + 1 checksum digit"),
        "icon":"",
      },
      {
        "name":translate("EAN 8"),
        "url": "",
        "barcode":BarcodeFormat.ean8,
        "descriptions":translate("8 digit"),
        "icon":"",
      },
      {
        "name":translate("UPC E"),
        "url": "",
        "barcode":BarcodeFormat.upcE,
        "descriptions":translate("7 digits + checksum digits"),
        "icon":"",
      },
      {
        "name":translate("UPC A"),
        "url": "",
        "barcode":BarcodeFormat.upcA,
        "descriptions":translate("11 digits + checksum digits"),
        "icon":"",
      },
      {
        "name":translate("code 128"),
        "url": "",
        "barcode":BarcodeFormat.code128,
        "descriptions":translate("11 digits + checksum digits"),
        "icon":"",
      },
      {
        "name":translate("code 93"),
        "url": "",
        "barcode":BarcodeFormat.code93,
        "descriptions":translate("uppercase text without special characters"),
        "icon":"",
      },
      {
        "name":translate("code 39"),
        "url": "",
        "barcode":BarcodeFormat.code39,
        "descriptions":translate("uppercase text without special characters"),
        "icon":"",
      },
      {
        "name":translate("codabar"),
        "url": "",
        "barcode":BarcodeFormat.codebar,
        "descriptions":translate("digits"),
        "icon":"",
      },
       {
        "name":translate("ITF"),
        "url": "",
        "barcode":BarcodeFormat.itf,
        "descriptions":translate("even-digit numbers"),
        "icon":"",
      },
    ];
    return allTypeOfQR2D;
  }



  String mapFormatTo2DName(BarcodeFormat? f) {
    switch (f) {
      case BarcodeFormat.qrCode:
        return translate("QR code");
      case BarcodeFormat.dataMatrix:
        return translate("data matrix");
      case BarcodeFormat.pdf417:
        return translate("PDF 417");
      case BarcodeFormat.aztec:
        return translate("AZtec");
      case BarcodeFormat.ean13:
        return translate("EAN 13");
      case BarcodeFormat.ean8:
        return translate("EAN 8");
      case BarcodeFormat.upcE:
        return translate("UPC E");
      case BarcodeFormat.upcA:
        return translate("UPC A");
      case BarcodeFormat.code128:
        return translate("code 128");
      case BarcodeFormat.code93:
        return translate("code 93");
      case BarcodeFormat.code39:
        return translate("code 39");
      case BarcodeFormat.codabar:
        return translate("codabar");
      case BarcodeFormat.itf:
        return translate("ITF");
      default:
        return translate("QR code"); // fallback razonable
    }
  }



  // Detecta el tipo de contenido a partir del texto crudo.
  ContentType detectContentType(String raw) {
    final s = raw.trim();
    // WiFi (formato estándar)
    if (s.startsWith('WIFI:')) return ContentType.wifi;
    // Evento (vCalendar / vEvent)
    if (s.contains('BEGIN:VEVENT') || s.contains('BEGIN:VCALENDAR')) {
      return ContentType.event;
    }
    // Contacto (vCard / MeCard)
    if (s.startsWith('BEGIN:VCARD') || s.startsWith('MECARD:')) {
      return ContentType.contact;
    }
    // SMS
    final lower = s.toLowerCase();
    if (lower.startsWith('sms:') || lower.startsWith('smsto:')) {
      return ContentType.sms;
    }
    // Ubicación (geo:)
    if (lower.startsWith('geo:')) return ContentType.location;
    // Email
    if (lower.startsWith('mailto:')) return ContentType.email;
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (emailRegex.hasMatch(s)) return ContentType.email;
    // Website / URL
    final urlLike = RegExp(
      r'^(https?:\/\/|www\.)[^\s]+$',
      caseSensitive: false,
    );
    if (urlLike.hasMatch(s)) return ContentType.website;
    // Evitar confundir códigos puramente numéricos (EAN/UPC) con texto especial
    final onlyDigits = RegExp(r'^\d+$');
    if (onlyDigits.hasMatch(s)) return ContentType.text;
    // Por defecto, texto libre
    return ContentType.text;
  }

}