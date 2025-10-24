import 'package:floor/floor.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeFormatConverter extends TypeConverter<BarcodeFormat?, String?> {
  BarcodeFormatConverter();

  @override
  String? encode(BarcodeFormat? value) => value?.name; // ej: "qrCode"

  @override
  BarcodeFormat? decode(String? databaseValue) {
    if (databaseValue == null) return null;
    try {
      return BarcodeFormat.values.firstWhere((e) => e.name == databaseValue);
    } catch (_) {
      // Fallback razonable si cambia el nombre o hay datos antiguos
      return BarcodeFormat.qrCode;
    }
  }
}
