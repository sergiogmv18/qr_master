import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/database/qr_master_database.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:qr_master/services/service_locator.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;

class QrRecordController {

  /*
  * Saves QR record to local database and returns updated record with generated ID
  * @author  SGV
  * @version 1.0 - 20251116 - initial release
  * @param   qrRecord - QR record object to be saved
  * @return  Future<QrRecord> - Updated QR record with assigned database ID
  */
  Future<QrRecord> saveQrRecord({required QrRecord qrRecord})async{
    int id = await serviceLocator<QrMasterDatabase>().qrRecordEntityDao.saveLocally(qrRecord);
    qrRecord = qrRecord.copyWith(
      id: id
    );
    return qrRecord;
  }

  /*
  * Adds a new contact to the device's contact list with the provided details
  * @author  SGV
  * @version 1.0 - 20251116 - initial release
  * @param   firstName - Contact first name (optional, defaults to empty string)
  * @param   lastName - Contact last name (optional, defaults to empty string)
  * @param   phone - Contact phone number (optional)
  * @param   email - Contact email address (optional)
  * @param   company - Contact company (optional)
  * @param   jobTitle - Contact job title (optional, defaults to empty string)
  * @param   address - Contact address (optional)
  * @return  Future<Map<String, dynamic>> - Operation result with success status and message
  */
  Future<Map<String, dynamic>>addContact({String firstName = "", String lastName ="", String? phone, String? email, String?company, String jobTitle = "", String? address}) async {
    Map<String,dynamic> response = {"success":false, "message": translate('problems saving contact')};
    // Verifica permisos
    String contactId ="${FunctionsClass().toKebab(Constants.nameApp)}-${FunctionsClass().toKebab('$firstName-$lastName')}";
    bool auth = await FlutterContacts.requestPermission();
    FunctionsClass.debugDumpAndDie(contactId);
    if (auth) {
      // Crea el contacto
      final contact = Contact(
        name:Name(first:firstName, last:lastName),
        organizations: [
          if (company != null)
            Organization(company: company, title: jobTitle)
        ],
        phones: [
          if (phone != null) Phone(phone)
        ],
        emails:[
          if (email != null) Email(email)
        ],
        addresses: [
          if (address != null) Address(address)
        ]
      );
      // Guarda en la agenda del teléfono
      await contact.insert();
      response = {"success":true, "message":""};
    } else {
      response = {"success":false, "message":"🚫 ${translate("permission denied")}"};
    }
    return response;
  }

  /*
  * Converts a QR widget to PNG byte data by capturing the rendered output
  * @author  SGV
  * @version 1.0 - 20251116 - initial release
  * @param   key - GlobalKey referencing the QR widget to capture
  * @param   pixelRatio - Image resolution multiplier (default: 4)
  * @return  Future<Uint8List> - PNG image data as byte array
  */
  Future<Uint8List> qrToPngBytes(GlobalKey key, {int pixelRatio = 4}) async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio.toDouble());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /*
  * Converts a QR widget to a PNG file in the temporary directory
  * @author  SGV
  * @version 1.0 - 20251116 - initial release
  * @param   key - GlobalKey referencing the QR widget to capture
  * @param   pixelRatio - Image resolution multiplier (default: 4)
  * @return  Future<File> - PNG file object in temporary directory
  */
  Future<File> qrToPngFile(GlobalKey key, {int pixelRatio = 4}) async {
    final bytes = await qrToPngBytes(key, pixelRatio: pixelRatio);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  /*
  * Saves QR image file from temporary storage to application documents directory
  * @author  SGV
  * @version 1.0 - 20251116 - initial release
  * @param   file - Temporary QR image file to be permanently saved
  * @return  Future<File> - Saved file in application documents directory
  */
  Future<File> saveQrFile(File file) async {
    final dir = await getApplicationDocumentsDirectory(); // /data/user/0/tu_app/...
    final fileName = 'qr_${DateTime.now().millisecondsSinceEpoch}.png';
    final newPath = p.join(dir.path, fileName);

    final savedFile = await file.copy(newPath); // 👈 aquí “guardas” el archivo
    return savedFile;
  }

  /*
  * Renders QR widget to PNG image, embeds it in a PDF document and shares via device sharing capabilities
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @param   repaintKey - GlobalKey referencing the QR widget to capture and share
  * @param   pixelRatio - Image resolution multiplier (default: 4)
  * @param   title - Title to be displayed in the PDF document (default: 'Mi QR')
  * @return  Future<void>
  */
  Future<void> shareQrPngFromWidget(GlobalKey repaintKey, {int pixelRatio = 4}) async {
    // Render a PNG in-memory
    final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio.toDouble());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();
    // Guarda en cache (temporal) y comparte
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        text: 'Mi QR',
        subject: 'Mi QR',
        files: [XFile(path, mimeType: 'image/png', name: 'mi_qr.png')],
      ),
    );
  }

  /*
  * Renders QR widget to PDF, embeds it in a PDF document and shares via device sharing capabilities
  * @author  SGV
  * @version 1.0 - 20251116 - initial release
  * @param   repaintKey - GlobalKey referencing the QR widget to capture and share
  * @param   pixelRatio - Image resolution multiplier (default: 4)
  * @param   title - Title to be displayed in the PDF document (default: 'Mi QR')
  * @return  Future<void>
  */
  Future<void> shareQrPdfFromWidget(GlobalKey repaintKey, { int pixelRatio = 4, String title = 'Mi QR', }) async {
    // 1) Renderiza el widget a PNG en memoria
    final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio.toDouble());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    // 2) Crea PDF e inserta la imagen (centrado en la página)
    final pdf = pw.Document();
    final qrImage = pw.MemoryImage(pngBytes);
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Center(child: pw.Image(qrImage, width: 360, height: 360, fit: pw.BoxFit.contain)),
          ],
        ),
      ),
    );
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save(), flush: true);
    await SharePlus.instance.share(
      ShareParams(
        text: 'Mi QR (PDF)',
        subject: 'Mi QR (PDF)',
        files: [XFile(path, mimeType: 'application/pdf', name: 'mi_qr.pdf')],
      ),
    );
  }

  /*
  * Saves QR code to local storage and creates database record with metadata
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @param   repaintKey - GlobalKey referencing the QR widget to capture
  * @param   content - Original content encoded in the QR code
  * @return  Future<void>
  */
  Future<void>saveLocaleQRCreated({required GlobalKey<State<StatefulWidget>> repaintKey, required String content})async{
    File file = await qrToPngFile(repaintKey);
    File fileSaved = await saveQrFile(file);
    QrRecord qrRecordWk = QrRecord(
      serverId:0,
      content:content,
      type: QrRecord.typeCreate,
      createdAt: DateTime.now(),
      imagePath: fileSaved.path,
    );
    await saveQrRecord(qrRecord:qrRecordWk);
  }

  Future<void>deleteQRCreated({required QrRecord qrRecordWk})async{
    if(qrRecordWk.imagePath != null){
      File file = File(qrRecordWk.imagePath!);
      bool existFile = await file.exists();
      if(existFile){
       await file.delete();
      }
    }
    await serviceLocator<QrMasterDatabase>().qrRecordEntityDao.deleteLocally(qrRecordWk);
  }


}
