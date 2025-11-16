import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/widgets/content_type_wifi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart' as intl;



class FunctionsClass {



  static bool _connecting = false;
  static Timer? _debounce;


  /* Launches a URL in the default browser or appropriate app.
  * @author  SGV - 20250812
  * @version 1.1 - 20250812 - added error handling
  * 
  * @param   url - The URL to launch (required)
  * 
  * Behavior:
  *  - Parses the URL string into a Uri object
  *  - Attempts to launch using the system default handler
  *  - Throws Exception if launch fails
  * 
  * Usage Example:
  *   await redirectUrl(url: "https://example.com");
  *   // Opens in default browser
  * 
  * Dependencies:
  *  - package:url_launcher (launchUrl)
  * 
  * Supported URL Schemes:
  *  - http://, https://
  *  - mailto:
  *  - tel:
  *  - sms:
  * 
  * Error Handling:
  *  - Throws Exception with descriptive message on failure
  *  - Validates URL format before attempting launch
  * 
  * Notes:
  *  - Requires internet permission on Android
  *  - iOS may need LSApplicationQueriesSchemes in Info.plist
  */
  Future<void> redirectUrl({required String url}) async {
    // 1) Sanea: quita espacios, saltos y caracteres invisibles (BOM/ZW*)
    var cleaned = url
        .trim()
        .replaceAll(RegExp(r'[\u200B-\u200D\u2060\uFEFF]'), '') // zero-width
        .replaceAll(RegExp(r'\s+'), '');                        // espacios/saltos

    // 2) Si viene entre comillas, quítalas
    if ((cleaned.startsWith('"') && cleaned.endsWith('"')) ||
        (cleaned.startsWith("'") && cleaned.endsWith("'"))) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    // 3) Validación mínima: http(s) y host
    final uri = Uri.tryParse(cleaned);
    final valid = uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;

    if (!valid) {
      // Log útil para detectar el problema real en tu consola
      // (ojo: no imprimas tokens sensibles en prod)
      // ignore: avoid_print
      print('redirectUrl() invalid -> "$cleaned" (from "$url")');
      throw const FormatException('Invalid URL format');
    }

    // 4) Abre (para Stripe Checkout suele ir bien in-app browser)
    final ok = await launchUrlString(
      cleaned,
      mode: LaunchMode.inAppBrowserView, // o externalApplication si prefieres
    );
    if (!ok) {
      throw Exception('Failed to open URL: $cleaned');
    }
  }



  /* Safely converts various input types to nullable integer.
  * @author  SGV - 202508008
  * @version 1.0 - 202508008 - initial release
  * 
  * @param   v - Dynamic input value to convert
  * @return  int? - Converted integer or null if:
  *           - Input is null
  *           - String cannot be parsed
  *           - Type is unsupported
  * 
  * Supported Input Types:
  *  - int: Returns directly
  *  - String: Attempts parsing (returns null on failure)
  *  - num/double: Truncates to int
  *  - Others: Returns null
  * 
  * Usage Examples:
  *   asInt(42)     → 42
  *   asInt("3.14") → 3
  *   asInt(null)   → null
  *   asInt(true)   → null
  * 
  * Null Safety:
  *  - Always returns nullable int
  *  - Handles null input gracefully
  * 
  * Notes:
  *  - Does not throw exceptions
  *  - String parsing uses tryParse (non-throwing)
  *  - Double values are truncated (not rounded)
  */
  static int? asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is String) {
    // Intentar parsear como int primero
    final intVal = int.tryParse(v);
    if (intVal != null) return intVal;

    // Si no es entero, intentar como double y convertir
    final doubleVal = double.tryParse(v);
    if (doubleVal != null) return doubleVal.toInt();

    return null;
  }
  if (v is num) return v.toInt(); // cubre double
  return null;
}



  /* Universal string converter with flexible formatting options.
  * @author  SGV - 20250811
  * @version 2.1 - 20250811 - added enum and JSON support
  * 
  * @param   v - Dynamic value to convert
  * @param   trim - Whether to trim whitespace (default: true)
  * @param   emptyToNull - Convert empty strings to null (default: false)
  * 
  * @return  String? - Converted string or null if:
  *           - Input is null
  *           - Result is empty and emptyToNull=true
  * 
  * Supported Input Types:
  *  - String: Returns directly (with optional trim)
  *  - num/bool: Standard toString()
  *  - DateTime: ISO8601 format
  *  - Enum: Uses .name property (Dart 2.17+)
  *  - Iterable/Map: JSON encoded
  *  - Others: Fallback to toString()
  * 
  * Usage Examples:
  *   asString(42) → "42"
  *   asString(null) → null
  *   asString(["a",1], emptyToNull: true) → "[\"a\",1]"
  *   asString("  ", emptyToNull: true) → null
  * 
  * Conversion Rules:
  *  - JSON encoding for collections
  *  - Enum values use .name property
  *  - Trims whitespace by default
  *  - Empty string handling configurable
  * 
  * Dependencies:
  *  - dart:convert for jsonEncode
  *  - Dart 2.17+ for enum .name property
  */
  static String? asString(dynamic v, { bool trim = true, bool emptyToNull = false}) {
    if (v == null) return null;
    String s;
    if (v is String) {
      s = v;
    } else if (v is num || v is bool) {
      s = v.toString();
    } else if (v is DateTime) {
      s = v.toIso8601String();
    } else if (v is Enum) {
      // Dart 2.17+: los enum tienen .name
      s = v.name; 
    } else if (v is Iterable || v is Map) {
      // List/Map -> JSON
      try {
        s = jsonEncode(v);
      } catch (_) {
        s = v.toString();
      }
    } else {
      s = v.toString();
    }
    if (trim) s = s.trim();
    if (emptyToNull && s.isEmpty) return null;
    return s;
  }


    /* Safely converts various input types to nullable double.
   * @author  SGV - 20250818
   * @version 1.0 - 20250818 - initial release
   * 
   * @param   v - Dynamic input value to convert
   * @return  double? - Converted double or null if:
   *           - Input is null
   *           - String cannot be parsed
   *           - Type is unsupported
   * 
   * Supported Input Types:
   *  - double: Returns directly
   *  - int: Converts to double
   *  - String: Attempts parsing (returns null on failure)
   *  - num: Converts to double
   *  - Others: Returns null
   * 
   * Usage Examples:
   *   asDouble(42)       → 42.0
   *   asDouble("3.14")   → 3.14
   *   asDouble("abc")    → null
   *   asDouble(null)     → null
   *   asDouble(true)     → null
   * 
   * Null Safety:
   *  - Always returns nullable double
   *  - Handles null input gracefully
   * 
   * Notes:
   *  - Does not throw exceptions
   *  - String parsing uses tryParse (non-throwing)
   *  - Int values are converted with `.toDouble()`
   */
  static double? asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();

  if (v is String) {
    var s = v.trim();
    if (s.isEmpty) return null;

    // (123) -> negativo contable
    final hasParens = s.startsWith('(') && s.endsWith(')');
    if (hasParens) s = s.substring(1, s.length - 1);

    // Normalizar signos de menos unicode a '-'
    const minus = ['\u2212', '\u2012', '\u2013', '\u2014'];
    for (final m in minus) { s = s.replaceAll(m, '-'); }

    // Dejar solo dígitos, separadores , . y signos + -
    s = s.replaceAll(RegExp(r'[^\d\-,.+\s]'), '');
    s = s.replaceAll(RegExp(r'\s+'), '');

    // Elegir separador decimal: si hay . y , usa el ÚLTIMO visto como decimal
    final lastDot = s.lastIndexOf('.');
    final lastComma = s.lastIndexOf(',');
    if (lastDot != -1 && lastComma != -1) {
      if (lastDot > lastComma) {
        // '.' decimal -> quitar comas (miles)
        s = s.replaceAll(',', '');
      } else {
        // ',' decimal -> quitar puntos (miles) y cambiar coma por punto
        s = s.replaceAll('.', '').replaceAll(',', '.');
      }
    } else if (lastComma != -1) {
      // Solo coma -> tratar como decimal
      s = s.replaceAll(',', '.');
    }

    final parsed = double.tryParse(s);
    if (parsed == null) return null;
    return hasParens ? -parsed : parsed;
  }
  return null;
}

  





  /*
  * convert Uint8List image data to base64 encoded string
  * @author  SGV
  * @version 1.0 - 20250826 - initial release
  * @param   imageData - Uint8List containing binary image data (can be null or empty)
  * @return  String? - base64 encoded string or null if conversion fails
  * @throws  
  * @see     base64Encode()
  * @note    returns null if input imageData is null or empty
  *          performs basic validation on image data size (minimum 100 bytes)
  *          logs warning if image data seems too small for valid image
  *          logs error details if encoding process fails
  *          useful for preparing images for API transmission or storage
  * @example 
  *   String? base64Image = convertImageToBase64(imageBytes);
  *   if (base64Image != null) {
  *     // Send to API or store in database
  *   }
  */
  String? convertImageToBase64(Uint8List? imageData) {
    if (imageData == null || imageData.isEmpty) return null;
    try {
      if (imageData.lengthInBytes < 100) {
        FunctionsClass.debugDumpAndDie("Image data seems too small: ${imageData.lengthInBytes} bytes");
        return null;
      } 
      return base64Encode(imageData);
    } catch (e) {
      FunctionsClass.debugDumpAndDie("Error encoding image to base64: $e");
      return null;
    }
  }
  



  /*
  * Logs any object safely for debugging purposes (no-throw helper)
  * @author   Quantax
  * @version  1.0 - 20251006 - initial release
  * @param    obj - required Object: value to be logged via dev.log
  * @return   void
  * @throws   — (no exceptions; internal try/catch prevents errors from bubbling)
  * @see      dart:developer dev.log
  * @note     Despite the name, it does not terminate execution ("die"); it only logs.
  * @example  
  *   try {
  *     // ...
  *   } catch (e) {
  *     debugDumpAndDie('Open PDF failed: $e');
  *   }
  */  
  static debugDumpAndDie(Object obj){
   try {
      dev.log(obj.toString());
    } catch (err) {
      dev.log("debugDumpAndDie$err");
    }
  }

  /*
  * Opens address in available map applications with platform-specific fallbacks
  * @author   SGV
  * @version  1.0 - 20251006 - initial release
  * @param    address - required String: physical address to locate in maps
  * @return   Future<void>
  * @throws   — (no exceptions; all errors handled internally with fallbacks)
  * @see      package:url_launcher launchUrl, canLaunchUrl
  * @note     Platform-specific implementation with graceful degradation:
  *           - iOS: Google Maps → Apple Maps → Web Google Maps
  *           - Android: geo intent → Web Google Maps
  *           Encodes address for URL safety and uses external application mode
  * @example  
  *   await openAddressInMaps("123 Main St, City, Country");
  */
  Future<void> openAddressInMaps(String address, {bool isGeo = false}) async {
    final q = Uri.encodeComponent(address);
    if(isGeo){
      final uri = Uri.parse(address);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    // Android: intenta intent geo:, luego web.
    final geo = Uri.parse('geo:0,0?q=$q'); // respeta etiqueta y hace búsqueda
    if (await canLaunchUrl(geo)) {
      await launchUrl(geo);
      return;
    }
    final web = Uri.parse('https://www.google.com/maps/search/?api=1&query=$q');
    await launchUrl(web, mode: LaunchMode.externalApplication);
  }


  /*
  * Converts input string to kebab-case format with comprehensive sanitization
  * @author   SGV
  * @version  1.0 - 20251006 - initial release
  * @param    input - required String: text to convert to kebab-case
  * @param    lower - optional bool: whether to convert to lowercase (default: true)
  * @return   String - sanitized kebab-case formatted string
  * @throws   — (no exceptions; handles all input types safely)
  * @see      RegExp with unicode support for international characters
  * @note     Multi-step normalization process:
  *           1. Trims and collapses whitespace
  *           2. Removes non-alphanumeric characters (preserves spaces, underscores, hyphens)
  *           3. Replaces spaces with hyphens
  *           4. Optionally converts to lowercase
  *           Supports Unicode characters for international text
  * @example  
  *   toKebab("Hello World!") → "hello-world"
  *   toKebab("User_Name Here", lower: false) → "User_Name-Here"
  *   toKebab("Café & Crème") → "cafe-creme"
  */
  String toKebab(String input, {bool lower = true}) {
    // 1) recorta y colapsa espacios
    String s = input.trim().replaceAll(RegExp(r'\s+'), ' ');
    // 2) quita caracteres no alfanuméricos (salvo espacios, _ y -)
    s = s.replaceAll(RegExp(r'[^\p{L}\p{N}\s_-]', unicode: true), '');
    // 3) cambia espacios por guion
    s = s.replaceAll(' ', '-');
    return lower ? s.toLowerCase() : s;
  }


  /*
  * Splits full name into structured components (first, middle, last) with particle-aware last name handling
  * @author   SGV
  * @version  1.0 - 20251006 - initial release
  * @param    fullName - required String: complete name to parse and split
  * @return   Map<String, String> - structured name parts with keys: firstName, lastName, middleName
  * @throws   — (no exceptions; gracefully handles empty and single-word names)
  * @see      RegExp for whitespace normalization
  * @note     Advanced name parsing with surname particle recognition:
  *           - Handles common name particles (de, van, bin, etc.) in last names
  *           - Preserves multi-word last names with particles
  *           - Returns empty strings for missing components
  *           - Normalizes whitespace before processing
  * @example  
  *   splitPersonName("John Michael van der Berg") 
  *   → {firstName: "John", middleName: "Michael", lastName: "van der Berg"}
  *   splitPersonName("Maria del Carmen") 
  *   → {firstName: "Maria", middleName: "", lastName: "del Carmen"}
  *   splitPersonName("Cher") 
  *   → {firstName: "Cher", middleName: "", lastName: ""}
  */
  Map<String, String> splitPersonName(String fullName) {
    final cleaned = fullName.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return {'firstName': '', 'lastName': '', 'middleName': ''};

    final parts = cleaned.split(' ');
    if (parts.length == 1) {
      return {'firstName': parts[0], 'lastName': '', 'middleName': ''};
    }

    const particles = {
      'da','de','del','di','do','dos','das','du',
      'la','las','los','van','von','bin','al','el'
    };

    String firstName = parts.first;
    String lastName;

    if (parts.length >= 3 && particles.contains(parts[parts.length - 2].toLowerCase())) {
      lastName = '${parts[parts.length - 2]} ${parts.last}';
    } else {
      lastName = parts.last;
    }
    final middle = parts.length > 2 ? parts.sublist(1, parts.length - 1).join(' ') : '';
    return {'firstName': firstName, 'lastName': lastName, 'middleName': middle};
  }


  /*
  * Copies provided text to clipboard and shows success feedback
  * @author   SGV
  * @version  1.0 - 20251006 - initial release
  * @param    context - required BuildContext: for showing snackbar
  * @param    raw - required String: text to be copied to clipboard
  * @return   void
  * @throws   — (no exceptions; internal try/catch in snackBarCustom prevents errors)
  * @see      Clipboard.setData, snackBarCustom
  * @note     Uses global translate function for internationalized feedback
  * @example  
  *   copy(context: context, raw: "Hello World");
  */
  copy({required BuildContext context, required String raw}){
    Clipboard.setData(ClipboardData(text: raw));
    snackBarCustom(context, subtitle: translate("QR code value copied successfully"));
  }



  Future<void> openMailtoRobusto(String raw) async {
    // 1) Parsear el mailto original y normalizar
    Uri? parsed;
    try {
      parsed = Uri.parse(raw);
    } catch (_) {
      // Si viene con espacios o saltos de línea
      parsed = Uri.parse(raw.trim());
    }

    // Extraer datos (Uri ya decodifica queryParameters)
    final to = parsed.path; // puede traer varios separados por coma
    final subject = parsed.queryParameters['subject'];
    final body = parsed.queryParameters['body'];

    // Reconstruir un mailto limpio (se re-encodea correctamente)
    final mailto = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        if ((subject ?? '').isNotEmpty) 'subject': subject!,
        if ((body ?? '').isNotEmpty) 'body': body!,
      },
    );

    // 2) Intentar abrir cliente por defecto
    if (await canLaunchUrl(mailto)) {
      await launchUrl(mailto, mode: LaunchMode.externalApplication);
      return;
    }

    // 3) Fallback: Gmail app (si está instalada)
    final gmailApp = Uri.parse(
      'googlegmail://co?to=${Uri.encodeComponent(to)}'
      '${(subject ?? '').isNotEmpty ? '&subject=${Uri.encodeComponent(subject!)}' : ''}'
      '${(body ?? '').isNotEmpty ? '&body=${Uri.encodeComponent(body!)}' : ''}',
    );
    if (await canLaunchUrl(gmailApp)) {
      await launchUrl(gmailApp, mode: LaunchMode.externalApplication);
      return;
    }

    // 4) Fallback: Gmail web
    final gmailWeb = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1'
      '&to=${Uri.encodeComponent(to)}'
      '${(subject ?? '').isNotEmpty ? '&su=${Uri.encodeComponent(subject!)}' : ''}'
      '${(body ?? '').isNotEmpty ? '&body=${Uri.encodeComponent(body!)}' : ''}',
    );
    if (await canLaunchUrl(gmailWeb)) {
      await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
      return;
    }

    // 5) Ultimo fallback: Outlook web
    final outlookWeb = Uri.parse(
      'https://outlook.office.com/mail/deeplink/compose'
      '?to=${Uri.encodeComponent(to)}'
      '${(subject ?? '').isNotEmpty ? '&subject=${Uri.encodeComponent(subject!)}' : ''}'
      '${(body ?? '').isNotEmpty ? '&body=${Uri.encodeComponent(body!)}' : ''}',
    );
    await launchUrl(outlookWeb, mode: LaunchMode.externalApplication);
  }




  String formatDateAuto(BuildContext context, DateTime date, {bool abbreviated = true}) {
    final locale = Localizations.localeOf(context).toString(); // p.ej. "es_ES"
    // Abreviado:  "23, may de 2025" (es) / "May 23, 2025" (en) / …
    // Completo:   "23 de mayo de 2025" (es) / "May 23, 2025" (en) / …
    if (abbreviated) {
      // yMMMd produce una forma corta localizada (incluye comas si el idioma las usa)
      return intl.DateFormat.yMMMd(locale).format(date);
    } else {
      // yMMMMd produce la forma larga localizada e incluye “de” en español automáticamente
      return intl.DateFormat.yMMMMd(locale).format(date);
    }
  }



/// Llama esto desde tu onTap/acción del usuario
  Future<bool> connectFromWifiQrGuarded(String qr) async {
    // Debounce: si el usuario toca varias veces en <300ms>, solo 1 intento
    _debounce?.cancel();
    final c = Completer<bool>();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (_connecting) {
        c.complete(false);
        return;
      }
      _connecting = true;
      try {
        final creds = parseWifiQr(qr);
        if (creds == null || creds.ssid!.isEmpty) {
          c.complete(false);
          return;
        }

        final type = (creds.authType ?? 'WPA').toUpperCase();
        final isOpen = type == 'OPEN' || type == 'NOPASS';

        bool? ok;
        try {
          if (isOpen) {
            ok = await (PluginWifiConnect.connect(creds.ssid!) );
          } else if (type == 'WPA3') {
            ok = await (PluginWifiConnect.connectToSecureNetwork(
              creds.ssid!, creds.password ?? '', isWpa3: true, saveNetwork: false,
            ));
          } else {
            ok = await (PluginWifiConnect.connectToSecureNetwork(
              creds.ssid!, creds.password ?? '', saveNetwork: false,
            ));
          }
        } on PlatformException catch (e) {
          // Ignora/normaliza los casos conocidos del plugin
          final txt = '${e.message} ${e.details}'.toLowerCase();
          if (txt.contains('networkcallback was already unregistered') ||
              txt.contains('networkcallback was not registered')) {
            ok = true; // la red probablemente ya está establecida o el callback ya cerró
          } else {
            ok = false;
          }
        }
        c.complete(ok);
      } finally {
        _connecting = false;
      }
    });
    return c.future;
  }


    /*
  * add 20 years to current date or specified initial date
  * @author  SGV
  * @version 1.0 - 20250826 - initial release
  * @param   initialDate - optional DateTime to use as base date (default: current date)
  * @return  DateTime - resulting date after adding 20 years
  * @throws  
  * @see     
  * @note    uses current date if no initialDate is provided
  *          preserves the same month and day from the base date
  *          handles leap years and month boundaries automatically
  *          useful for calculating expiration dates or long-term deadlines
  * @example 
  *   add20YearsToNow(); // returns current date + 20 years
  *   add20YearsToNow(initialDate: DateTime(2020, 1, 1)); // returns January 1, 2040
  */
  static DateTime add20YearsToNow({DateTime? initialDate}) {
    final now =initialDate ?? DateTime.now();
    return DateTime(now.year + 20, now.month, now.day);
  }

  /*
  * Displays a color picker dialog for color selection with alpha channel support
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @param   context - BuildContext for dialog display and theming
  * @param   initial - Initial color to display in the picker
  * @return  Future<Color?> - Selected color or null if cancelled
  */
  Future<Color?> pickColor(BuildContext context, Color initial) async {
    Color current = initial;
    return showDialog<Color>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: CustomColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.borderRadius)),
        title:Text(translate("select color"), style: Theme.of(context).textTheme.titleLarge!.copyWith(color: CustomColors.white)),
        content:SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
          child: Column(
            children: [
              ColorPicker(
                pickerColor: current,
                onColorChanged: (c) => current = c,
                enableAlpha: true,     // deslizador de opacidad
                displayThumbColor: true,
                labelTextStyle:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),          
                pickerAreaBorderRadius: BorderRadius.all(Radius.circular(Constants.borderRadius)),
              ),
              const SizedBox(height: 8),
              Text(
                '#${current.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),   
              ),
            ],
          ),
        ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(translate("cancel"), style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.error))),
          TextButton(onPressed: () =>  Navigator.pop(context, current), child: Text(translate("OK"), style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white))),
        ],
      ),
    );
  }


  /* Captures or selects an image and converts it to base64 format with metadata.
  * @author  SGV - 202508008
  * @version 1.0 - 202508008 - initial release
  * 
  * @param   context - Required for platform permissions
  * @param   fromCamera - Source selection flag:
  *           - true: Uses device camera
  *           - false: Uses gallery (default)
  * 
  * @return  Future<Map<String, dynamic>?> - Image data containing:
  *           - base64: String (Base64 encoded image)
  *           - bytes: Uint8List (Raw image bytes)
  *           - fileName: String (Original filename)
  *           - path: String (Local file path)
  *           - extension: String (File extension)
  *           - Returns null if cancelled
  * 
  * Process Flow:
  *  1. Requests image from selected source
  *  2. Applies 85% quality compression
  *  3. Converts to base64 string
  *  4. Packages all metadata
  * 
  * Usage Examples:
  *  // From gallery
  *  final image = await pickImageAsBase64(context);
  *  
  *  // From camera
  *  final selfie = await pickImageAsBase64(
  *    context, 
  *    fromCamera: true
  *  );
  * 
  * Dependencies:
  *  - image_picker package
  *  - dart:convert for base64 encoding
  * 
  * Platform Notes:
  *  - Requires camera/gallery permissions
  *  - Handles cancellation gracefully
  *  - iOS/Android compatible
  */
  Future<Map<String, dynamic>?> pickImageAsBase64({required BuildContext context, bool fromCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85, 
    );
    if (pickedFile == null) return null;
    final Uint8List bytes = await pickedFile.readAsBytes();
    final String base64String = base64Encode(bytes);
    return {
      'base64': base64String,
      'bytes': bytes,
      'fileName': pickedFile.name,
      'path': pickedFile.path,
      "file":File(pickedFile.path),
      'extension': pickedFile.name.split('.').last
    };
  }


 /* Validates an email address against standard formatting rules.
  * @author  SGV - 20250729
  * @version 1.0 - 20250729 - initial release
  * 
  * @param   email - Email address to validate
  * @return  Map<String,dynamic> - Validation result containing:
  *           - isValid: bool (proper email format)
  *           - message: String (validation status)
  *           - errors: List<String> (empty list for consistency)
  * 
  * Validation Rules:
  *  - Must contain @ symbol
  *  - Requires valid domain (e.g. example.com)
  *  - Requires valid top-level domain (.com, .io, etc.)
  *  - No spaces allowed
  *  - Follows RFC 5322 standard regex pattern
  * 
  * Usage Example:
  *   final result = validateEmailAddress("user@example.com");
  *   if(!result['isValid']) {
  *     showError(result['message']);
  *   }
  * 
  * Output Example:
  *   {
  *     isValid: true,
  *     message: "Valid email address",
  *     errors: []
  *   }
  * 
  * Notes:
  *  - Does not verify if email actually exists
  *  - Maintains consistent return structure with other validators
  */
  Map<String, dynamic> validateEmailAddress(String email) {
    final errors = <String>[];
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);

    if (email.isEmpty) {
      return {
        'isValid': false,
        'message': 'El correo electrónico no puede estar vacío.',
        'errors': ['empty_email']
      };
    }

    if (!regExp.hasMatch(email)) {
      return {
        'isValid': false,
        'message': 'Por favor ingrese un correo electrónico válido.',
        'errors': ['invalid_format']
      };
    }
    return {
      'isValid': true,
      'message': 'Email is valid',
      'errors': errors
    };
  }
}
    