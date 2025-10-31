import 'package:qr_master/models/model_base.dart';

class QrTypeSMS extends ModelBase {
  final String? isoCode;              // Código ISO del país (ej: "US", "MX")
  final String? phoneNumber;          // Número de teléfono
  final String? isoPhoneNumber;       // Número con código internacional
  final String? message;              // Mensaje de texto

  QrTypeSMS({
    required super.serverId,
    super.id,
    super.needToSynchronize,
    super.uuid,
    this.isoCode,
    this.phoneNumber,
    this.isoPhoneNumber,
    this.message,
  });

  // CopyWith method
  QrTypeSMS copyWith({
    int? serverId,
    int? id,
    bool? needToSynchronize,
    String? uuid,
    String? isoCode,
    String? phoneNumber,
    String? isoPhoneNumber,
    String? message,
  }) {
    return QrTypeSMS(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      needToSynchronize: needToSynchronize ?? this.needToSynchronize,
      uuid: uuid ?? this.uuid,
      isoCode: isoCode ?? this.isoCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isoPhoneNumber: isoPhoneNumber ?? this.isoPhoneNumber,
      message: message ?? this.message,
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) => identical(this, other) ||
      other is QrTypeSMS &&
          runtimeType == other.runtimeType &&
          serverId == other.serverId &&
          id == other.id &&
          needToSynchronize == other.needToSynchronize &&
          uuid == other.uuid &&
          isoCode == other.isoCode &&
          phoneNumber == other.phoneNumber &&
          isoPhoneNumber == other.isoPhoneNumber &&
          message == other.message;

  @override
  int get hashCode =>
      serverId.hashCode ^
      id.hashCode ^
      needToSynchronize.hashCode ^
      uuid.hashCode ^
      isoCode.hashCode ^
      phoneNumber.hashCode ^
      isoPhoneNumber.hashCode ^
      message.hashCode;

  @override
  String toString() {
    return 'QrTypeSMS{serverId: $serverId, isoCode: $isoCode, phoneNumber: $phoneNumber, isoPhoneNumber: $isoPhoneNumber, message: ${message != null ? '"${message!.length > 20 ? '${message!.substring(0, 20)}...' : message}"' : 'null'}}';
  }

  // Serialization
  factory QrTypeSMS.fromJson(Map<String, dynamic> json) {
    return QrTypeSMS(
      serverId: json['id'] as int,
      isoCode: json['iso_code'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isoPhoneNumber: json['iso_phone_number'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'iso_code': isoCode,
      'phone_number': phoneNumber,
      'iso_phone_number': isoPhoneNumber,
      'message': message,
    };
  }

  // Factory para nuevos SMS
  factory QrTypeSMS.createNew() {
    return QrTypeSMS(
      serverId: 0,
    );
  }

  static QrTypeSMS parseSmsToQrTypeSMS(String input) {
    String raw = input.trim();
    String? phone;
    String? message;

    // 1) Caso SMSTO:NUMERO:MENSAJE
    final smstoPrefix = RegExp(r'^smsto:', caseSensitive: false);
    if (smstoPrefix.hasMatch(raw)) {
      final start = raw.indexOf(':') + 1; // después de "SMSTO:"
      final rest = raw.substring(start);

      // Partimos por el primer ":" -> izquierda = número, derecha = mensaje (puede contener ":" dentro)
      final firstColon = rest.indexOf(':');
      if (firstColon == -1) {
        phone = _cleanPhone(rest);
        message = null;
      } else {
        phone = _cleanPhone(rest.substring(0, firstColon));
        message = _unescapeSmsText(rest.substring(firstColon + 1));
      }
    } else if (raw.toLowerCase().startsWith('sms:')) {
      // 2) Caso sms:+NUM?body=MENSAJE (URL estándar)
      // Uri.parse maneja path y query
      final uri = Uri.parse(raw);
      // En 'sms:' el path suele traer el(los) número(s) separados por comas o punto y coma
      final path = uri.path; // p.ej: "+55885855545" o "+1, +2"
      if (path.isNotEmpty) {
        // Toma el primero si hay varios
        final parts = path.split(RegExp(r'[;,]'));
        phone = _cleanPhone(parts.first);
      }

      // body en query (?body=...)
      final body = uri.queryParameters['body'];
      if (body != null && body.isNotEmpty) {
        message = _unescapeSmsText(body);
      }
    } else {
      // 3) Fallback: "NUMERO:MENSAJE" o solo "NUMERO"
      final firstColon = raw.indexOf(':');
      if (firstColon == -1) {
        phone = _cleanPhone(raw);
        message = null;
      } else {
        phone = _cleanPhone(raw.substring(0, firstColon));
        message = _unescapeSmsText(raw.substring(firstColon + 1));
      }
    }
    QrTypeSMS smsWk = QrTypeSMS.createNew();
    smsWk = smsWk.copyWith(
      phoneNumber: phone?.isEmpty == true ? null : phone,
      message: message?.isEmpty == true ? null : message,
    );
    return smsWk;
  }
  
  static String _unescapeSmsText(String s) {
  // Decodifica %XX, maneja \n y \\ ->\
    final decoded = Uri.decodeComponent(s);
    return decoded
        .replaceAll(r'\\n', '\n')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\\', r'\');
  }

  static String _cleanPhone(String s) {
    // Quita espacios y separadores comunes al principio/fin
    // (si quieres normalizar más, añade reglas aquí)
    return s.trim();
  }

}