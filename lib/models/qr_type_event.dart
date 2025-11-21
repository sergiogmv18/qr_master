import 'package:qr_master/models/model_base.dart';

class QrTypeEvent extends ModelBase {
  final String? title;                 // Título del evento
  final DateTime? initialDate;         // Fecha de inicio del evento
  final DateTime? finalDate;           // Fecha de finalización del evento
  final String? description;           // Descripción del evento
  final String? addressEvent;          // Dirección/lugar del evento

  QrTypeEvent({
    required super.serverId,
    super.id,
    super.needToSynchronize,
    super.uuid,
    this.title,
    this.initialDate,
    this.finalDate,
    this.description,
    this.addressEvent,
  });

  // CopyWith method
  QrTypeEvent copyWith({
    int? serverId,
    int? id,
    bool? needToSynchronize,
    String? uuid,
    String? title,
    DateTime? initialDate,
    DateTime? finalDate,
    String? description,
    String? addressEvent,
  }) {
    return QrTypeEvent(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      needToSynchronize: needToSynchronize ?? this.needToSynchronize,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      initialDate: initialDate ?? this.initialDate,
      finalDate: finalDate ?? this.finalDate,
      description: description ?? this.description,
      addressEvent: addressEvent ?? this.addressEvent,
    );
  }
  // Equality comparison
  @override
  bool operator ==(Object other) => identical(this, other) ||
      other is QrTypeEvent &&
          runtimeType == other.runtimeType &&
          serverId == other.serverId &&
          id == other.id &&
          needToSynchronize == other.needToSynchronize &&
          uuid == other.uuid &&
          title == other.title &&
          initialDate == other.initialDate &&
          finalDate == other.finalDate &&
          description == other.description &&
          addressEvent == other.addressEvent;

  @override
  int get hashCode =>
      serverId.hashCode ^
      id.hashCode ^
      needToSynchronize.hashCode ^
      uuid.hashCode ^
      title.hashCode ^
      initialDate.hashCode ^
      finalDate.hashCode ^
      description.hashCode ^
      addressEvent.hashCode;

  @override
  String toString() {
    return 'QrTypeEvent{serverId: $serverId, title: $title, initialDate: $initialDate, finalDate: $finalDate, description: $description, addressEvent: $addressEvent}';
  }

  // Serialization
  factory QrTypeEvent.fromJson(Map<String, dynamic> json) {
    return QrTypeEvent(
      serverId: json['id'] as int,
      title: json['title'] as String?,
      initialDate: json['initial_date'] != null 
          ? DateTime.parse(json['initial_date'] as String)
          : null,
      finalDate: json['final_date'] != null 
          ? DateTime.parse(json['final_date'] as String)
          : null,
      description: json['description'] as String?,
      addressEvent: json['address_event'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'title': title,
      'initial_date': initialDate?.toIso8601String(),
      'final_date': finalDate?.toIso8601String(),
      'description': description,
      'address_event': addressEvent,
    };
  }

  // Factory para nuevos eventos
  factory QrTypeEvent.createNew() {
    return QrTypeEvent(
      serverId: 0,
    );
  }




  // Utils: quitar escapes de iCal (\n, \, \; y \\)
static String _icsUnescape(String s) {
  return s
      .replaceAll(r'\\n', '\n')
      .replaceAll(r'\n', '\n')      // por si viene con un solo backslash
      .replaceAll(r'\\,', ',')
      .replaceAll(r'\\;', ';')
      .replaceAll(r'\\\\', r'\');
}

// Utils: “unfold” de iCal (líneas que continúan comenzando con espacio o tab)
static String _unfoldLines(String input) {
  final lines = input.replaceAll('\r\n', '\n').split('\n');
  final out = <String>[];
  for (final line in lines) {
    if (line.isEmpty) continue;
    if (line.startsWith(' ') || line.startsWith('\t')) {
      if (out.isNotEmpty) {
        out[out.length - 1] += line.substring(1); // concat sin el espacio/tab
      }
    } else {
      out.add(line);
    }
  }
  return out.join('\n');
}

// Utils: parse de fecha/hora de iCal (YYYYMMDD o YYYYMMDDThhmmss[Z])
static DateTime? _parseIcsDateTime(String? raw) {
  if (raw == null || raw.isEmpty) return null;

  // ISO-8601 con Z -> DateTime.parse lo soporta directo
  final zRe = RegExp(r'^\d{8}T\d{6}Z$');
  if (zRe.hasMatch(raw)) {
    return DateTime.parse(
        '${raw.substring(0,4)}-${raw.substring(4,6)}-${raw.substring(6,8)}'
        'T${raw.substring(9,11)}:${raw.substring(11,13)}:${raw.substring(13,15)}Z');
  }

  // Local/floating time: YYYYMMDDThhmmss (sin Z)
  final localRe = RegExp(r'^\d{8}T\d{6}$');
  if (localRe.hasMatch(raw)) {
    final y = int.parse(raw.substring(0, 4));
    final m = int.parse(raw.substring(4, 6));
    final d = int.parse(raw.substring(6, 8));
    final hh = int.parse(raw.substring(9, 11));
    final mm = int.parse(raw.substring(11, 13));
    final ss = int.parse(raw.substring(13, 15));
    // Interpretamos como hora local
    return DateTime(y, m, d, hh, mm, ss);
  }

  // Fecha solamente: YYYYMMDD (se asume 00:00 local)
  final dateOnlyRe = RegExp(r'^\d{8}$');
  if (dateOnlyRe.hasMatch(raw)) {
    final y = int.parse(raw.substring(0, 4));
    final m = int.parse(raw.substring(4, 6));
    final d = int.parse(raw.substring(6, 8));
    return DateTime(y, m, d);
  }

  // Último intento: DateTime.parse si viniera en ISO estándar
  try {
    return DateTime.parse(raw);
  } catch (_) {
    return null;
  }
}

/// Parsea un bloque VEVENT y devuelve un QrTypeEvent.
/// - `serverId` lo pasas tú (tipo según tu ModelBase).
/// - `uuid` es opcional por si quieres asignarlo aquí.
/// Nota: iCal trata `DTEND` como fin exclusivo; ajusta en tu dominio si lo necesitas inclusivo.
static QrTypeEvent parseVEventToQrTypeEvent(String vevent) {
  // 1) Recorta al bloque VEVENT
  final start = vevent.indexOf('BEGIN:VEVENT');
  final end = vevent.indexOf('END:VEVENT');
  if (start == -1 || end == -1 || end < start) {
    throw FormatException('Bloque VEVENT no encontrado o mal formado.');
  }
  var body = vevent.substring(start, end + 'END:VEVENT'.length);

  // 2) Unfold + limpiar BEGIN/END
  body = _unfoldLines(body);
  final lines = body
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .where((l) => !l.startsWith('BEGIN:VEVENT') && !l.startsWith('END:VEVENT'))
      .toList();

  // 3) Tomamos propiedades clave: el nombre va antes de ':' (ignorando parámetros ;XYZ=)
  final Map<String, String> props = {};
  for (final line in lines) {
    final sep = line.indexOf(':');
    if (sep <= 0) continue;
    final nameAndParams = line.substring(0, sep);
    final value = line.substring(sep + 1);
    final name = nameAndParams.split(';').first.toUpperCase(); // e.g., DTSTART
    props[name] = _icsUnescape(value);
  }

  final title = props['SUMMARY'];
  final description = props['DESCRIPTION'];
  final location = props['LOCATION'];
  final dtStartRaw = props['DTSTART'];
  final dtEndRaw = props['DTEND'];

  final initialDate = _parseIcsDateTime(dtStartRaw);
  final finalDate = _parseIcsDateTime(dtEndRaw);

  QrTypeEvent event = QrTypeEvent.createNew();
  event = event.copyWith(
    title: title,
    description: description,
    addressEvent: location,
    initialDate: initialDate,
    finalDate: finalDate,
  );
  return event;
}


 String toVEvent() {
    final buffer = StringBuffer();

    buffer.writeln('BEGIN:VEVENT');
    // SUMMARY (title)
    if (title != null && title!.trim().isNotEmpty) {
      buffer.writeln(
        _foldIcsLine('SUMMARY:${_icsEscape(title!.trim())}'),
      );
    }

    // DESCRIPTION
    if (description != null && description!.trim().isNotEmpty) {
      buffer.writeln(
        _foldIcsLine('DESCRIPTION:${_icsEscape(description!.trim())}'),
      );
    }

    // LOCATION
    if (addressEvent != null && addressEvent!.trim().isNotEmpty) {
      buffer.writeln(
        _foldIcsLine('LOCATION:${_icsEscape(addressEvent!.trim())}'),
      );
    }

    // DTSTART
    if (initialDate != null) {
      final dtStart = _formatIcsDateTime(initialDate!);
      buffer.writeln('DTSTART:$dtStart');
    }

    // DTEND
    if (finalDate != null) {
      final dtEnd = _formatIcsDateTime(finalDate!);
      buffer.writeln('DTEND:$dtEnd');
    }

    buffer.writeln('END:VEVENT');

    return buffer.toString();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');


  String _formatIcsDateTime(DateTime dt) {
    final d = dt;
    return '${d.year.toString().padLeft(4, '0')}'
        '${_twoDigits(d.month)}'
        '${_twoDigits(d.day)}'
        'T'
        '${_twoDigits(d.hour)}'
        '${_twoDigits(d.minute)}'
        '${_twoDigits(d.second)}Z';
  }

  String _icsEscape(String v) {
    return v
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll('\n', '\\n');
  }

  /// Corta en 75 chars y hace folding (líneas continuadas empiezan con espacio)
  String _foldIcsLine(String line, {int limit = 75}) {
    if (line.length <= limit) return line;

    final buffer = StringBuffer();
    var i = 0;
    while (i < line.length) {
      final end = (i + limit < line.length) ? i + limit : line.length;
      final chunk = line.substring(i, end);
      if (i == 0) {
        buffer.writeln(chunk);
      } else {
        buffer.writeln(' $chunk');
      }
      i = end;
    }
    return buffer.toString().trimRight();
  }

}
