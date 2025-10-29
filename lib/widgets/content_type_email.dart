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
import 'package:qr_master/services/function_class.dart';

class ContentTypeEmail extends StatelessWidget {
  final QrRecord qrRecord;
  final Barcode? barcode;
  final String raw;
  final String formatted;
  final bool showData;
  const ContentTypeEmail({super.key, required this.qrRecord, required this.raw, this.showData = false, this.barcode, required this.formatted});

  @override
  Widget build(BuildContext context) {
    final formatRaw = parseEmailQr(raw);    
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
// EMAILS           
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:Text(
                    translate("email address"),
                    style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primary),
                  ),
                ),
                for(String email in formatRaw.to)...[
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width* 0.7,
                        child: Text(
                          email,
                          style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          FunctionsClass().copy(context: context, raw: email);
                        },
                        child:Icon(
                          Icons.copy,
                          color: CustomColors.warning,
                          size: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(height: 10),
                ],
// BODY 
                SizedBox(height: 10),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:Text(
                    translate("body"),
                    style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primary),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width* 0.7,
                      child: SelectableText(
                        formatRaw.body ?? "", 
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FunctionsClass().copy(context: context, raw: formatRaw.body ?? "");
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
                    translate("subject"),
                    style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primary),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width* 0.7,
                      child: SelectableText(
                        formatRaw.subject ?? "", 
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FunctionsClass().copy(context: context, raw: formatRaw.subject ?? "");
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
                          text:": ${barcode?.format.name} - ${translate("email address")}",
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
            try {
              await FunctionsClass().openMailtoRobusto(
                raw,
              );
            } catch (e) {
              if(!context.mounted) return;
              snackBarCustom(context, subtitle: 'Error: $e');
            }
          },
          child:Text(
            translate("send mail to"), 
            style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
            textAlign: TextAlign.center,
          )
        ),
      ],
    );
  }
}


/// Modelo del email parseado
class ParsedEmail {
  final List<String> to;
  final String? subject;
  final String? body;

  ParsedEmail({required this.to, this.subject, this.body});
}

/// Decodificación tolerante: si hay % mal formados, los corrige.
String _safeDecode(String s) {
  s = s.trim();
  try {
    return Uri.decodeComponent(s);
  } catch (_) {
    // Reemplaza cualquier '%' que NO tenga 2 dígitos hex posteriores por '%25'
    final fixed = s.replaceAllMapped(
      RegExp(r'%(?![0-9A-Fa-f]{2})'),
      (m) => '%25',
    );
    try {
      return Uri.decodeComponent(fixed);
    } catch (_) {
      return s; // última defensa
    }
  }
}

/// Parsea un string de QR que representa un email.
/// Soporta:
///  - mailto:addr1,addr2?subject=...&body=...
///  - MATMSG:TO:addr;SUB:subject;BODY:body;;
///  - email "puro" (solo la dirección)
ParsedEmail parseEmailQr(String raw) {
  final s = raw.trim();

  // ---- mailto: ----
  if (s.toLowerCase().startsWith('mailto:')) {
    final uri = Uri.parse(s);
    final to = uri.path
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // queryParameters ya viene decodeado; igual pasamos por _safeDecode por seguridad
    final subject = uri.queryParameters['subject'] != null
        ? _safeDecode(uri.queryParameters['subject']!)
        : null;
    final body = uri.queryParameters['body'] != null
        ? _safeDecode(uri.queryParameters['body']!)
        : null;

    return ParsedEmail(to: to, subject: subject, body: body);
  }

  // ---- MATMSG: ----
  if (s.toUpperCase().startsWith('MATMSG:')) {
    // Formato típico: MATMSG:TO:addr;SUB:subject;BODY:body;;
    final content = s.substring(7); // después de 'MATMSG:'
    final parts = content.split(';'); // conserva orden

    String? to;
    String? sub;
    String? body;

    for (final part in parts) {
      if (part.isEmpty) continue;
      final idx = part.indexOf(':');
      if (idx <= 0) continue;

      final key = part.substring(0, idx).trim().toUpperCase();
      final rawVal = part.substring(idx + 1).trim();
      final val = _safeDecode(rawVal);

      if (key == 'TO' && val.isNotEmpty) to = val;
      if (key == 'SUB' || key == 'SUBJECT') sub = val;
      if (key == 'BODY') {
        // Algunos QR ponen "\n" literales para saltos de línea
        body = val.replaceAll(r'\n', '\n');
      }
    }

    return ParsedEmail(
      to: to == null
          ? const []
          : to.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      subject: sub,
      body: body,
    );
  }

  // ---- Email "puro" ----
  final emailOnly = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (emailOnly.hasMatch(s)) {
    return ParsedEmail(to: [s], subject: null, body: null);
  }

  // Si no matchea nada, devuelve vacío (puedes tratarlo como texto luego)
  return ParsedEmail(to: const [], subject: null, body: null);
}

/// Helper opcional: construye un mailto listo para abrir con url_launcher
String buildMailtoUri(ParsedEmail e) {
  final to = e.to.join(',');
  final qp = <String, String>{};
  if ((e.subject ?? '').isNotEmpty) qp['subject'] = e.subject!;
  if ((e.body ?? '').isNotEmpty) qp['body'] = e.body!;
  final uri = Uri(
    scheme: 'mailto',
    path: to,
    queryParameters: qp.isEmpty ? null : qp,
  );
  return uri.toString();

}