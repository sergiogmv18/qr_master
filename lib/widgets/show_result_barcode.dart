import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/qr_record_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/content_type.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:intl/intl.dart';
import 'package:qr_master/widgets/content_type_contact.dart';
import 'package:qr_master/widgets/content_type_email.dart';
import 'package:qr_master/widgets/content_type_event.dart';
import 'package:qr_master/widgets/content_type_location.dart';
import 'package:qr_master/widgets/content_type_sms.dart';
import 'package:qr_master/widgets/content_type_unknown.dart';
import 'package:qr_master/widgets/content_type_wifi.dart';


Widget showResultBarcodeScreen({required BuildContext context, required Barcode barcode,required String raw}){
   final nowLocal = DateTime.now(); // ya viene en hora local del dispositivo
  final locale = Localizations.localeOf(context).toString(); // ej: "es_ES", "en_US"
  QrRecord qrRecord = QrRecord.empyt();
  // Elige un patrón según tu necesidad
  final formatted = DateFormat.yMMMMd(locale).format(nowLocal);
  final normalized = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
  final url = 'https://www.google.com/search?q=${Uri.encodeQueryComponent(normalized)}';
                            




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
    case BarcodeFormat.aztec:
    case BarcodeFormat.pdf417:
    case BarcodeFormat.ean13:
    case BarcodeFormat.codabar:
    case BarcodeFormat.upcA:
    case BarcodeFormat.upcE:
    case BarcodeFormat.ean8:
    case BarcodeFormat.code128:
    case BarcodeFormat.code93:
    case BarcodeFormat.code39:
    case BarcodeFormat.itf:
      response = Column(
        children: [
          Card(
            color: CustomColors.primaryDark,
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CustomColors.primaryDark,
                border: Border.all( color: CustomColors.white),
                borderRadius: BorderRadius.circular(Constants.borderRadius),
              ),
              child: Column(
                children: [
                  SelectableText(
                    raw, 
                    style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SelectableText(
                    url,
                    style:Theme.of(context).textTheme.titleMedium?.copyWith(decoration: TextDecoration.underline, color: CustomColors.primary),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: translate('type'), 
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:": ${barcode.format.name}",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
                          ),
                          TextSpan(
                            text:"\n $formatted",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
                          ),
                        ],
                      ),
                    ),
                  ), 
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceAround,
                      children: [
// COPY BUTTON
                        TextButton.icon(
                          onPressed: (){
                            Clipboard.setData(ClipboardData(text: raw));
                            snackBarCustom(context, subtitle: translate("QR code value copied successfully"));
                          }, 
                          label: Text(
                            translate('copy'), 
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                          ),
                          iconAlignment:IconAlignment.start,
                          icon:Icon(
                           Icons.copy,
                            color: CustomColors.warning,
                            size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          )
                        ),
// SEARCH IN WEB
                        TextButton.icon(
                          onPressed: (){
                            FunctionsClass().redirectUrl(url: url);
                          }, 
                          label: Text(
                            translate('search'), 
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                          ),
                          iconAlignment:IconAlignment.start,
                          icon:Icon(
                            Icons.open_in_browser,
                            color: CustomColors.warning,
                            size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          )
                        ),
// SAVE
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
                            snackBarCustom(context, subtitle: translate("saved successfully"));
                          }, 
                          label: Text(
                            translate('save'), 
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                          ),
                          iconAlignment:IconAlignment.start,
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
              ),
            )
          ),
        ],
      );
      break;
// DEFAULT
    default:
      ContentType contentType = qrRecord.detectContentType(raw);
      FunctionsClass.debugDumpAndDie(contentType);
      switch(contentType){
        case ContentType.website: 
          response = Column(
            children: [
              Card(
                color: CustomColors.primaryDark,
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: CustomColors.primaryDark,
                    border: Border.all( color: CustomColors.white),
                    borderRadius: BorderRadius.circular(Constants.borderRadius),
                  ),
                  child: Column(
                    children: [
                      SelectableText(
                        raw, 
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: (){
                          FunctionsClass().redirectUrl(url: raw);
                        },
                        child:Text(
                          raw,
                          style:Theme.of(context).textTheme.titleMedium?.copyWith(decoration: TextDecoration.underline, color: CustomColors.primary),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: translate('type'), 
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:": ${barcode.format.name} - ${translate("web-site")}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
                              ),
                              TextSpan(
                                text:"\n $formatted",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
                              ),
                            ],
                          ),
                        ),
                      ), 
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          runAlignment: WrapAlignment.spaceBetween,
                          alignment: WrapAlignment.spaceAround,
                          children: [
    // COPY BUTTON
                            TextButton.icon(
                              onPressed: (){
                                Clipboard.setData(ClipboardData(text: raw));
                                snackBarCustom(context, subtitle: translate("QR code value copied successfully"));
                              }, 
                              label: Text(
                                translate('copy'), 
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                              ),
                              iconAlignment:IconAlignment.start,
                              icon:Icon(
                              Icons.copy,
                                color: CustomColors.warning,
                                size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              )
                            ),
    // SEARCH IN WEB
                            TextButton.icon(
                              onPressed: (){
                                FunctionsClass().redirectUrl(url: url);
                              }, 
                              label: Text(
                                translate('search'), 
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                              ),
                              iconAlignment:IconAlignment.start,
                              icon:Icon(
                                Icons.open_in_browser,
                                color: CustomColors.warning,
                                size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              )
                            ),
    // SAVE
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
                                snackBarCustom(context, subtitle: translate("saved successfully"));
                              }, 
                              label: Text(
                                translate('save'), 
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                              ),
                              iconAlignment:IconAlignment.start,
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
                  ),
                )
              ),
            ],
          );
        break;
        case ContentType.contact: 
          response = Align(
            alignment: Alignment.centerLeft,
            child: buildVCardRichTextLabeled(
              context: context,
              barcode: barcode,
              rawVCard: raw,
              baseStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
              labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white, fontWeight: FontWeight.bold),
              valueStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
            ),
          );
        break;
        case ContentType.email: 
          response = ContentTypeEmail(qrRecord: qrRecord, barcode:barcode, raw: raw, formatted: formatted);  
        break;
        case ContentType.wifi: 
          response = ContentTypeWifi(qrRecord: qrRecord, barcode:barcode, raw: raw, formatted: formatted);
        break;
        case ContentType.location: 
          response = ContentTypeLocation(qrRecord: qrRecord, barcode:barcode, raw: raw, formatted: formatted);
        break;
        case ContentType.event: 
          response = ContentTypeEvent(qrRecord: qrRecord, barcode:barcode, raw: raw, formatted: formatted);
        break;
        case ContentType.sms: 
          response = ContentTypeSmS(qrRecord: qrRecord, barcode:barcode, raw: raw, formatted: formatted);
        break;
        case ContentType.unknown: 
         case ContentType.text: 
          response = ContentTypeUnknown(qrRecord: qrRecord, barcode:barcode, raw: raw, formatted: formatted);
        break;
    }
  }

  return response;
}