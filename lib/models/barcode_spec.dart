import 'package:barcode/barcode.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/content_type.dart';

typedef BarcodeBuilder = Barcode Function();

class BarcodeSpec {
  final String id;                 // clave interna estable
  final String label;              // texto a mostrar
  final BarcodeBuilder build;      // constructor del código
  final bool supportsContent;      // ¿muestra selector de ContentType?
  final Set<ContentTypeModel> contentTypes; // cuáles content types habilitar
  final String? hint;              // texto de ayuda opcional

  const BarcodeSpec({
    required this.id,
    required this.label,
    required this.build,
    this.supportsContent = false,
    this.contentTypes = const {},
    this.hint,
  });

  // Útil si luego necesitas saber si es 2D
  bool get is2D => supportsContent;

  // Para usar en Sets/Map o comparar fácilmente
  @override
  bool operator ==(Object other) => other is BarcodeSpec && other.id == id;
  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => label;
  
  // Lista para el DropdownMenu
static List<BarcodeSpec> kBarcodeTypes = [
  // 2D — admiten ContentType
  BarcodeSpec(
    id: 'qr',
    label: 'QR Code',
    build: _qrMedium,
    supportsContent: true,
    contentTypes: {
      ContentTypeModel(serverId:1, label:translate("web"), value: ContentType.website),
      ContentTypeModel(serverId:2, label:translate("contact"), value: ContentType.contact),
      ContentTypeModel(serverId:3, label:translate("text"), value: ContentType.text),
      ContentTypeModel(serverId:4, label:translate("email address"), value: ContentType.email),
      ContentTypeModel(serverId:5, label:translate("wifi"), value: ContentType.wifi),
      ContentTypeModel(serverId:6, label:translate("location"), value: ContentType.location),
      ContentTypeModel(serverId:7, label:translate("event"), value: ContentType.event),
      ContentTypeModel(serverId:8, label:translate("SMS"), value: ContentType.sms),
    },
    hint: 'Ideal para URL, Wi-Fi, vCard, etc.',
  ),
  // BarcodeSpec(
  //   id: 'aztec',
  //   label: 'Aztec',
  //   build: Barcode.aztec,
  //   supportsContent: true,
  //   contentTypes: {
  //     ContentTypeModel(serverId:1, label:translate("web"), value: ContentType.website),
  //     ContentTypeModel(serverId:2, label:translate("contact"), value: ContentType.contact),
  //     ContentTypeModel(serverId:3, label:translate("text"), value: ContentType.text),
  //     ContentTypeModel(serverId:4, label:translate("email address"), value: ContentType.email),
  //     ContentTypeModel(serverId:6, label:translate("location"), value: ContentType.location),
  //     ContentTypeModel(serverId:8, label:translate("SMS"), value: ContentType.sms),
  //   },
  // ),
  // BarcodeSpec(
  //   id: 'datamatrix',
  //   label: 'Data Matrix',
  //   build: Barcode.dataMatrix,
  //   supportsContent: true,
  //   contentTypes: { 
  //     ContentTypeModel(serverId:1, label:translate("web"), value: ContentType.website),
  //     ContentTypeModel(serverId:2, label:translate("contact"), value: ContentType.contact),
  //     ContentTypeModel(serverId:3, label:translate("text"), value: ContentType.text)
  //   },
  // ),

  // // Lineales — NO muestran ContentType, piden “datos crudos”
  // BarcodeSpec(id: 'code128', label: 'Code 128', build: Barcode.code128, hint: 'Alfanumérico'),
  // BarcodeSpec(id: 'ean13', label: 'EAN-13', build: Barcode.ean13, hint: '12–13 dígitos'),
  // BarcodeSpec(id: 'ean8',  label: 'EAN-8',  build: Barcode.ean8,  hint: '7–8 dígitos'),
  // BarcodeSpec(id: 'upca',  label: 'UPC-A',  build: Barcode.upcA,  hint: '11–12 dígitos'),
  // BarcodeSpec(id: 'itf',   label: 'ITF',    build: Barcode.itf,   hint: 'Sólo dígitos, longitud par'),
  // BarcodeSpec(id: 'codabar', label: 'Codabar', build: Barcode.codabar),
  // BarcodeSpec(id: 'pdf417',  label: 'PDF417',  build: Barcode.pdf417),
  // BarcodeSpec(id: 'rm4scc',  label: 'RM4SCC',  build: Barcode.rm4scc),
  // BarcodeSpec(id: 'telepen', label: 'Telepen', build: Barcode.telepen),
];
}



// Constructor helper para QR con ECL medio (puedes cambiarlo a H)
Barcode _qrMedium() => Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium);
