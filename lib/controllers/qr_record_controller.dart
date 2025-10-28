import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/database/qr_master_database.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:qr_master/services/service_locator.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class QrRecordController {

  Future<QrRecord> saveQrRecord({required QrRecord qrRecord})async{
    int id = await serviceLocator<QrMasterDatabase>().qrRecordEntityDao.saveLocally(qrRecord);
    qrRecord = qrRecord.copyWith(
      id: id
    );
    return qrRecord;
  }


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
}
