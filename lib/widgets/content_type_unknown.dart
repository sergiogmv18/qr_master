import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/qr_record_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/function_class.dart';

class ContentTypeUnknown extends StatelessWidget {
  final QrRecord qrRecord;
  final Barcode? barcode;
  final String raw;
  final String formatted;
  final bool showData;
  const ContentTypeUnknown({super.key, required this.qrRecord, required this.raw, this.showData = false, this.barcode, required this.formatted});

  @override
  Widget build(BuildContext context) {
      final normalized = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
  final url = 'https://www.google.com/search?q=${Uri.encodeQueryComponent(normalized)}';
    return Column(
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
                          text:": ${barcode?.format.name}",
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.start,
                    children: [
// COPY BUTTON
                      TextButton.icon(
                        onPressed: (){
                          FunctionsClass().copy(context: context, raw: raw);
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
                       TextButton.icon(
                          onPressed: (){
                            FunctionsClass().redirectUrl(url:url);
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
                      if(!showData)...{
                        TextButton.icon(
                          onPressed: ()async{
                            showCircularLoadingDialog(context);
                            QrRecord newQrRecord = qrRecord.copyWith(
                              content: raw,
                              type: QrRecord.typeScan,
                              createdAt: DateTime.now(),
                              symbology: barcode?.format,
                            );
                            await QrRecordController().saveQrRecord(qrRecord:newQrRecord);
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
                      }
                    ]
                  ),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}


