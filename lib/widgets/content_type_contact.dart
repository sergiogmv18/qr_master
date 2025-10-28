import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:url_launcher/url_launcher.dart';

class VCard {
  final String? fullName, org, title, email, url;
  final Address? address;
  final List<Phone> phones;
  VCard({this.fullName, this.org, this.title, this.email, this.url, this.address, this.phones = const []});
}

class Address {
  final String? street, city, region, postalCode, country;
  Address({this.street, this.city, this.region, this.postalCode, this.country});
  List<String> asLines() => [
        if ((street ?? '').trim().isNotEmpty) street!.trim(),
        if ((city ?? '').trim().isNotEmpty) city!.trim(),
        if ((region ?? '').trim().isNotEmpty) region!.trim(),
        if ((postalCode ?? '').trim().isNotEmpty) postalCode!.trim(),
        if ((country ?? '').trim().isNotEmpty) country!.trim(),
      ];
}

class Phone {
  final String number;
  final Set<String> kinds; // e.g. {WORK, VOICE} / {CELL}
  Phone(this.number, this.kinds);
}


/*
 * Parses vCard formatted string into structured VCard object
 * @author   SGV
 * @version  1.0 - 20251006 - initial release
 * @param    raw - required String: vCard raw text content
 * @return   VCard - structured contact information
 * @throws   — (gracefully handles malformed data with null checks)
 * @example  
 *   final vcard = parseVCard('FN:John Doe\nTEL:123456789');
 */
VCard parseVCard(String raw) {
  final lines = raw.split(RegExp(r'\r?\n')).map((l) => l.trimRight()).where((l) => l.isNotEmpty).toList();

  String? fullName, org, title, email, url;
  Address? address;
  final phones = <Phone>[];

  for (final line in lines) {
    if (line.startsWith('FN:')) {
      fullName = line.substring(3).trim();
    } else if (line.startsWith('ORG:')) {
      org = line.substring(4).trim();
    } else if (line.startsWith('TITLE:')) {
      title = line.substring(6).trim();
    } else if (line.startsWith('EMAIL')) {
      email = line.split(':').last.trim();
    } else if (line.startsWith('URL')) {
      url = line.split(':').last.trim();
    } else if (line.startsWith('ADR')) {
      final v = line.split(':').last;
      final p = v.split(';');
      address = Address(
        street: p.length > 2 ? p[2].trim() : null,
        city: p.length > 3 ? p[3].trim() : null,
        region: p.length > 4 ? p[4].trim() : null,
        postalCode: p.length > 5 ? p[5].trim() : null,
        country: p.length > 6 ? p[6].trim() : null,
      );
    } else if (line.startsWith('TEL')) {
      final value = line.split(':').last.trim();
      final kindMatch = RegExp(r'^TEL;([^:]+):').firstMatch(line);
      final kinds = <String>{};
      if (kindMatch != null) {
        kinds.addAll(kindMatch.group(1)!.split(';').map((s) => s.trim().toUpperCase()));
      }
      if (value.isNotEmpty) phones.add(Phone(value, kinds));
    }
  }

  return VCard(fullName: fullName, org: org, title: title, email: email, url: url, address: address, phones: phones);
}

/// ---- HELPERS ----
String _phoneLabel(Set<String> kinds) {
  final k = kinds.map((e) => e.toUpperCase()).toSet();
  if (k.contains('FAX')) return translate("fax");
  if (k.contains('CELL') || k.contains('MOBILE')) return translate("phone");
  if (k.contains('WORK')) return translate("landline");
  return translate("phone");
}

Future<void> _launch(Uri uri) async {
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/*
 * Builds rich text display widget for vCard contact information
 * @author   SGV
 * @version  1.0 - 20251006 - initial release
 * @param    context - required BuildContext: widget context
 * @param    rawVCard - required String: raw vCard data
 * @param    barcode - required Barcode: original scanned barcode
 * @param    baseStyle - optional TextStyle: base text style
 * @param    labelStyle - optional TextStyle: label text style
 * @param    valueStyle - optional TextStyle: value text style
 * @return   Widget - formatted contact card with actions
 * @throws   — (safe handling of null values and missing data)
 */
Widget buildVCardRichTextLabeled({
  required BuildContext context,
  required String rawVCard,
  required Barcode barcode,
  TextStyle? baseStyle,
  TextStyle? labelStyle,
  TextStyle? valueStyle,
}) {
  final theme = Theme.of(context);
  final base = baseStyle ?? theme.textTheme.bodyMedium!.copyWith(color: CustomColors.white);
  final label = labelStyle ?? base.copyWith(fontWeight: FontWeight.w700);
  final value = valueStyle ?? base;

  final v = parseVCard(rawVCard);
  List<TextSpan> line(String labelText, String? content, {GestureRecognizer? onTap}) {
    if (content == null || content.trim().isEmpty) return [];
    return [
      TextSpan(text: '$labelText ', style: label),
      TextSpan(
        text: content.trim(),
        style: value.copyWith(decoration: onTap != null ? TextDecoration.underline : TextDecoration.none, color: onTap != null ? CustomColors.primary: null),
        recognizer: onTap,
      ),
      const TextSpan(text: '\n'),
    ];
  }

  // Dirección: una línea por item (como la app del screenshot)
  final addressLines = v.address?.asLines() ?? [];
  final addressSpans = addressLines.isEmpty
      ? <TextSpan>[]
      : <TextSpan>[
          TextSpan(text: translate("address"), style: label),
          const TextSpan(text: '\n'),
          ...addressLines.expand<TextSpan>((l) => [TextSpan(text: l, style: value), const TextSpan(text: '\n')]),
        ];

  String? urlNorm;
  if ((v.url ?? '').isNotEmpty) {
    urlNorm = v.url!.startsWith(RegExp(r'https?://')) ? v.url : 'https://${v.url}';
  }

  final phoneSpans = <TextSpan>[];
  for (final p in v.phones) {
    phoneSpans.addAll(
      line(
        '${_phoneLabel(p.kinds)}:',
        p.number,
        onTap: TapGestureRecognizer()..onTap = () => _launch(Uri.parse('tel:${p.number.replaceAll(' ', '')}')),
      ),
    );
  }

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
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: base,
                    children: [
                      ...line('${translate("name")}:', "${v.fullName}"),

                      ...line('${translate("job")}:', v.title),
                      ...line('${translate("company")}:', v.org),
                      ...addressSpans,
                      ...phoneSpans,
                      ...line('${translate("email address")}:', v.email, onTap: v.email == null ? null : (TapGestureRecognizer()..onTap = () => _launch(Uri.parse('mailto:${v.email}')))),
                      ...line('${translate("web")}:', urlNorm, onTap: urlNorm == null ? null : (TapGestureRecognizer()..onTap = () => _launch(Uri.parse(urlNorm!)))),
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
                        final address = addressLines.where((e) => e.trim().isNotEmpty).map((e) => e.trim()).join(', ');
                        log(address.toString());
                        Map<String, dynamic> data = {
                          translate("name"): v.fullName,
                          translate("job"): v.title,
                          translate("company"): v.org,
                          translate("email address"):v.email,
                          translate("web"):urlNorm,
                          translate("address"): address,
                        };
                        Clipboard.setData(ClipboardData(text: jsonEncode(data)));
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
                        if(urlNorm != null){
                          FunctionsClass().redirectUrl(url: urlNorm);
                        }else{
                          snackBarCustom(context, subtitle: translate("URL not found"));
                        }
                      }, 
                      label: Text(
                        translate('web'), 
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
                        QrRecord qrRecord = QrRecord.empyt();
                        qrRecord = qrRecord.copyWith(
                          content: rawVCard,
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
      SizedBox(height: 10),
      PlanBadgeCard(
        borderGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.primary, CustomColors.primary], // aqua → violeta
        ),
        onTap: () async{
          String phone = "";
           for (final p in v.phones) {
            final k = p.kinds.map((e) => e.toUpperCase()).toSet();
            if (k.contains('CELL') || k.contains('MOBILE')){
              phone = p.number;
            }
          }
          Map<String, String> formatFullName = FunctionsClass().splitPersonName(v.fullName ?? ""); 
          final address = addressLines.where((e) => e.trim().isNotEmpty).map((e) => e.trim()).join(', ');
          Map<String,dynamic> response = await QrRecordController().addContact(
            firstName: formatFullName["firstName"] ?? "", 
            lastName: formatFullName["lastName"] ?? "",
            phone:phone,
            email:v.email,
            company: v.org,
            jobTitle:v.title ?? "",
            address:address,
          );
          if(!context.mounted) return;
          if(response["success"]){
            snackBarCustom(context, subtitle: translate("saved successfully"));
          }else{
            snackBarCustom(context, subtitle:response["message"]);
          }

        },
        child:Text(
          translate("add contact"), 
          style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
          textAlign: TextAlign.center,
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
          final address = addressLines.where((e) => e.trim().isNotEmpty).map((e) => e.trim()).join(', ');
          await FunctionsClass().openAddressInMaps(address);
        },
        child:Text(
          translate("show map"), 
          style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
          textAlign: TextAlign.center,
        )
      ),

    ]
  );
}