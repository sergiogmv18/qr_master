import 'package:flutter/material.dart';
import 'package:qr_master/models/content_type.dart';
import 'package:qr_master/screen/qr/component/form_contem_type_email.dart';
import 'package:qr_master/screen/qr/component/form_contem_type_sms.dart';
import 'package:qr_master/screen/qr/component/form_content_type_contact.dart';
import 'package:qr_master/screen/qr/component/form_content_type_text.dart';
import 'package:qr_master/screen/qr/component/form_content_type_web_site.dart';
import 'package:qr_master/screen/qr/component/form_content_type_wifi.dart';
class FormQrCreate extends StatefulWidget {
  final ContentTypeModel contentTypeModel;
  const FormQrCreate({super.key, required this.contentTypeModel});

  @override
  State<FormQrCreate> createState() => _FormQrCreateState();
}

class _FormQrCreateState extends State<FormQrCreate> {
  final formKey = GlobalKey<FormState>();
  TextEditingController contactNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: MediaQuery.of(context).size.height * 0.03,
      children: [
// TYPE WEBSITE
        if(widget.contentTypeModel.value == ContentType.website)...[
          FormContentTypeWebSite(),
        ],
// TYPE WIFI
        if(widget.contentTypeModel.value == ContentType.wifi)...[
          FormContentTypeWifi(),
        ],
// TYPE CONTACTS
        if(widget.contentTypeModel.value == ContentType.contact)...[
          FormContentTypeContact(),
        ],
// TYPE TEXT 
        if(widget.contentTypeModel.value == ContentType.text)...[
          FormContentTypeText(),
        ],
// TYPE EMAIL ADDRESS
        if(widget.contentTypeModel.value == ContentType.email)...[
          FormContemTypeEmail(),
        ],
// TYPE SMS
        if(widget.contentTypeModel.value == ContentType.sms)...[
          FormContemTypeSms(),
        ] 
      ]
    );
  }
}
