import 'package:floor/floor.dart';
import 'package:qr_master/models/model_base.dart';

@Entity(tableName: 'wifi_credentials')
class WifiCredentials extends ModelBase {
  final String? ssid;                   // Nombre de la red WiFi
  final String? password;              // Contraseña (puede ser null para redes abiertas)
  final String? authType;              // WEP, WPA, WPA2, nopass, etc.
  final bool? hidden;                  // Si la red está oculta

  WifiCredentials({
    required super.serverId,
    super.id,
    super.needToSynchronize,
    super.uuid,
    this.ssid,
    this.password,
    this.authType,
    this.hidden,
  });

  // CopyWith method
  WifiCredentials copyWith({
    int? serverId,
    int? id,
    bool? needToSynchronize,
    String? uuid,
    String? ssid,
    String? password,
    String? authType,
    bool? hidden,
  }) {
    return WifiCredentials(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      needToSynchronize: needToSynchronize ?? this.needToSynchronize,
      uuid: uuid ?? this.uuid,
      ssid: ssid ?? this.ssid,
      password: password ?? this.password,
      authType: authType ?? this.authType,
      hidden: hidden ?? this.hidden,
    );
  }

  // Helper methods
  bool get isOpenNetwork => password == null || password!.isEmpty;
  bool get isSecureNetwork => !isOpenNetwork;
  bool get isHiddenNetwork => hidden == true;

  String get securityType {
    if (isOpenNetwork) return 'Abierta';
    switch (authType?.toLowerCase()) {
      case 'wep':
        return 'WEP';
      case 'wpa':
        return 'WPA';
      case 'wpa2':
        return 'WPA2';
      case 'wpa3':
        return 'WPA3';
      default:
        return 'Protegida';
    }
  }

  // Equality comparison
  @override
  bool operator ==(Object other) => identical(this, other) ||
      other is WifiCredentials &&
          runtimeType == other.runtimeType &&
          serverId == other.serverId &&
          id == other.id &&
          needToSynchronize == other.needToSynchronize &&
          uuid == other.uuid &&
          ssid == other.ssid &&
          password == other.password &&
          authType == other.authType &&
          hidden == other.hidden;

  @override
  int get hashCode =>
      serverId.hashCode ^
      id.hashCode ^
      needToSynchronize.hashCode ^
      uuid.hashCode ^
      ssid.hashCode ^
      password.hashCode ^
      authType.hashCode ^
      hidden.hashCode;

  @override
  String toString() {
    return 'WifiCredentials{serverId: $serverId, ssid: $ssid, password: ${password != null ? '***' : 'null'}, authType: $authType, hidden: $hidden}';
  }

  // Serialization
  factory WifiCredentials.fromJson(Map<String, dynamic> json) {
    return WifiCredentials(
      serverId: json['id'] as int,
      ssid: json['ssid'] as String,
      password: json['password'] as String?,
      authType: json['auth_type'] as String?,
      hidden: json['hidden'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'ssid': ssid,
      'password': password,
      'auth_type': authType,
      'hidden': hidden,
    };
  }

  // Factory para nuevas credenciales WiFi
  factory WifiCredentials.createNew() {
    return WifiCredentials(
      serverId: 0,
    );
  }

  // Método para generar el formato de texto para código QR WiFi
  String get wifiQrString {
    final String auth = authType?.toLowerCase() ?? (isOpenNetwork ? 'nopass' : 'WPA');
    final String pwd = password ?? '';
    final String hide = hidden == true ? 'true' : 'false';
    
    return 'WIFI:S:$ssid;T:$auth;P:$pwd;H:$hide;;';
  }

  // Método para obtener resumen de la red
  String get networkSummary {
    final List<String> parts = ['SSID: $ssid'];
    
    parts.add('Seguridad: $securityType');
    if (hidden == true) parts.add('Red oculta');
    if (password != null) parts.add('Contraseña: ***');
    
    return parts.join('\n');
  }
}



WifiCredentials? parseWifiQr(String raw) {
  if (raw.isEmpty) return null;
  String input = raw.trim();

  // Debe comenzar con WIFI:
  const prefix = 'WIFI:';
  if (!input.toUpperCase().startsWith(prefix)) return null;
  input = input.substring(prefix.length);

  // Función para des-escapar \; \: \\ \"
  String unescape(String s) {
    final sb = StringBuffer();
    bool esc = false;
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];
      if (esc) {
        // Aceptamos ; : \ "
        if (ch == 'n') {
          // algunos generadores ponen \n
          sb.write('\n');
        } else {
          sb.write(ch);
        }
        esc = false;
      } else if (ch == r'\') {
        esc = true;
      } else {
        sb.write(ch);
      }
    }
    return sb.toString();
  }

  // Quita comillas si todo el valor está entre comillas
  String stripQuotes(String s) {
    if (s.length >= 2 && s.startsWith('"') && s.endsWith('"')) {
      return s.substring(1, s.length - 1);
    }
    return s;
  }

  // Parseo de pares clave:valor separados por ';' (permitiendo escapes)
  final Map<String, String> kv = {};
  final sbKey = StringBuffer();
  final sbVal = StringBuffer();
  bool readingKey = true;
  bool esc = false;

  void commitPair() {
    final key = sbKey.toString();
    final val = sbVal.toString();
    if (key.isNotEmpty) {
      final k = key.toUpperCase();
      final v = stripQuotes(unescape(val));
      kv[k] = v;
    }
    sbKey.clear();
    sbVal.clear();
    readingKey = true;
  }

  for (int i = 0; i < input.length; i++) {
    final ch = input[i];

    if (esc) {
      (readingKey ? sbKey : sbVal).write(ch);
      esc = false;
      continue;
    }
    if (ch == r'\') {
      esc = true;
      continue;
    }

    if (ch == ':' && readingKey) {
      readingKey = false;
      continue;
    }
    if (ch == ';') {
      // fin de par o separador vacío
      commitPair();
      continue;
    }

    (readingKey ? sbKey : sbVal).write(ch);
  }
  // Si terminó sin ';', registrar el último par
  if (sbKey.isNotEmpty || sbVal.isNotEmpty) {
    commitPair();
  }

  // Extrae campos principales
  final ssid = kv['S'] ?? '';
  if (ssid.isEmpty) return null;

  final password = kv['P'];
  final authType = kv['T'];
  final hiddenStr = (kv['H'] ?? kv['HIDDEN']);
  final hidden = hiddenStr == null
      ? null
      : (hiddenStr.toLowerCase() == 'true' || hiddenStr == '1');

  return WifiCredentials(
    serverId: 2,
    ssid: ssid,
    password: password,
    authType: authType,
    hidden: hidden,
  );
}

