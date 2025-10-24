

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/qr_record_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:intl/intl.dart';


Widget showResultBarcodeScreen({required BuildContext context, required Barcode barcode,required String raw}){
   final nowLocal = DateTime.now(); // ya viene en hora local del dispositivo
  final locale = Localizations.localeOf(context).toString(); // ej: "es_ES", "en_US"
  QrRecord qrRecord = QrRecord.empyt();
  // Elige un patrón según tu necesidad
  final formatted = DateFormat.yMMMMd(locale).format(nowLocal);
  Widget response = Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        alignment: Alignment.centerLeft,
        child: SelectableText(raw, textAlign: TextAlign.center),
      ),
      GestureDetector(
        onTap:(){
          Clipboard.setData(ClipboardData(text: raw));
          snackBarCustom(context, subtitle: translate("QR code value copied successfully"));
        }, 
        child:Icon(
          Icons.copy,
          color: CustomColors.primary,
        )
      ), 
    ],
  );
  switch (barcode.format) {
    case BarcodeFormat.dataMatrix:
      response = Text(translate("data matrix"));
      break;
    case BarcodeFormat.pdf417:
      response = Text(translate("PDF 417"));
      break;
    case BarcodeFormat.aztec:
      response = Text(translate("AZtec"));
      break;
    case BarcodeFormat.ean13:
    case BarcodeFormat.codabar:
    case BarcodeFormat.upcA:
    case BarcodeFormat.upcE:
      response = Column(
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                alignment: Alignment.centerLeft,
                child: SelectableText(
                  raw, 
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap:(){
                  Clipboard.setData(ClipboardData(text: raw));
                  snackBarCustom(context, subtitle: translate("QR code value copied successfully"));
                }, 
                child:Icon(
                  Icons.copy,
                  color: CustomColors.primary,
                )
              ), 
            ],
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child:RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: translate('type'), 
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.primaryDark, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:": ${barcode.format.name}",
                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.primaryDark),
                  ),
                  TextSpan(
                    text:"\n $formatted",
                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.primaryDark),
                  ),
                ],
              ),
            ),
          ), 
          Align(
            alignment: Alignment.centerLeft,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: (){
                    FunctionsClass().redirectUrl(url:"https://www.google.com/search?q=$raw");
                  }, 
                  label: Text(
                    translate('search the internet'), 
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.primaryDark),
                  ),
                  iconAlignment:IconAlignment.end,
                  icon:Icon(
                    Icons.open_in_browser,
                    color: CustomColors.warning,
                    size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  )
                ),
                TextButton.icon(
                  onPressed: ()async{
                    showCircularLoadingDialog(context);
                    qrRecord = qrRecord.copyWith(
                      content: raw,
                      type: QrRecord.typeScan,
                      createdAt: DateTime.now(),
                      symbology: barcode.format,
                    );
                    await QrRecordController().saveQrRecord(qrRecord:qrRecord);
                    if(!context.mounted) return;
                    Navigator.of(context).pop();
                  }, 
                  label: Text(
                    translate('save'), 
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.primaryDark),
                  ),
                  iconAlignment:IconAlignment.end,
                  icon:Icon(
                    Icons.save,
                    color: CustomColors.warning,
                    size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  )
                ),
              ]
            ),
            
            
          ),
        ],
      );
      break;
    case BarcodeFormat.ean8:
      response = Text(translate("EAN 8"));
      break;
    case BarcodeFormat.code128:
      response = Text(translate("code 128"));
      break;
    case BarcodeFormat.code93:
      response = Text(translate("code 93"));
      break;
    case BarcodeFormat.code39:
      response = Text(translate("code 39"));
      break;
    
    case BarcodeFormat.itf:
      response = Text(translate("ITF"));
      break;
    default:

  }

  return response;
}