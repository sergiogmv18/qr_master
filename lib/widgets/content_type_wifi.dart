import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/qr_record_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/models/wifi_credentials.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:qr_master/services/wifi_connect.dart';

class ContentTypeWifi extends StatelessWidget {
  final QrRecord qrRecord;
  final Barcode? barcode;
  final String raw;
  final String formatted;
  final bool showData;
  const ContentTypeWifi({super.key, required this.qrRecord, required this.raw, this.showData = false, this.barcode, required this.formatted});

  @override
  Widget build(BuildContext context) {
    final creds = parseWifiQr(raw);  
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
// BODY 
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:Text(
                    translate("wifi"),
                    style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primary),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width* 0.7,
                      child: SelectableText(
                        creds?.ssid ?? "", 
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FunctionsClass().copy(context: context, raw: creds?.ssid ?? "");
                      },
                      child:Icon(
                        Icons.copy,
                        color: CustomColors.warning,
                        size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ]
                ),
// SUBJECT
                SizedBox(height: 20),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:Text(
                    translate("password"),
                    style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primary),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width* 0.7,
                      child: SelectableText(
                        creds?.password ?? "", 
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FunctionsClass().copy(context: context, raw:creds?.password ?? "");
                      },
                      child:Icon(
                        Icons.copy,
                        color: CustomColors.warning,
                        size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 20),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:Text(
                    translate("auth type"),
                    style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primary),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width* 0.7,
                      child: SelectableText(
                        creds?.authType ?? "", 
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FunctionsClass().copy(context: context, raw:creds?.authType ?? "");
                      },
                      child:Icon(
                        Icons.copy,
                        color: CustomColors.warning,
                        size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ]
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
                          text:": ${barcode?.format.name} - ${translate("wifi")}",
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
        SizedBox(height: 10),
        PlanBadgeCard(
          borderGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CustomColors.primary, CustomColors.primary], // aqua → violeta
          ),
          onTap: () async{
            final wifi = WifiConnector()..attach(); 
            try {
                final ok = await wifi.connectFromWifiQr(context, raw);
                FunctionsClass.debugDumpAndDie(ok);
                if(ok){
                  wifi.detach();
                }
            } catch (e) {
              if(!context.mounted) return;
              FunctionsClass.debugDumpAndDie('Error: $e');
              snackBarCustom(context, subtitle: 'Error: $e');
            }
          },
          child:Text(
            translate("connect"), 
            style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
            textAlign: TextAlign.center,
          )
        ),
      ],
    );
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
    serverId: 1,
    ssid: ssid,
    password: password,
    authType: authType,
    hidden: hidden,
  );
}

