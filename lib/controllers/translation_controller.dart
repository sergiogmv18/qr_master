import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:qr_master/services/translate_json.dart';

/// A singleton that handles the translations and Locale operations
class TranslationController extends ChangeNotifier {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('pt'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
    Locale('it'),
  ];
  
  static final TranslationController _instance = TranslationController._();
  static String get localeTag => localeStatic.toString();
  static Locale? localeStatic;
  static String get formattedLocaleTag => formatLocaleToDbString(localeTag);
  Locale? get locale => localeStatic;
  String? defaultLocale;
  bool? withTranslations;

  Translations _translations = Translations.byText("en");

  TranslationController._() {
    withTranslations = false;
  }

  factory TranslationController.getInstance() => _instance;

  // static TranslationController of(BuildContext context) {
  //   return Localizations.of<TranslationController>(context, TranslationController);
  // }

  Future<void> loadTranslations({String? startTag}) async {
    notifyListeners();

    // tag de inicio válido (device o pasado por parámetro)
    final device = TranslationController.localeStatic;
    final tag = startTag ?? bcp47From(device, fallback: 'en');

    // ✅ NUNCA "placeholder"
    _translations = Translations.byText(tag);

    final List<Map<String, String>> translationJson =
        localTranslations().cast<Map<String, String>>();

    for (final m in translationJson) {
      _translations += m;
    }
    notifyListeners();
  }

  static String bcp47From(Locale? l, {String fallback = 'en'}) {
  if (l == null) return fallback;
  final lang = l.languageCode;
  final country = (l.countryCode ?? '').trim();
  return country.isEmpty ? lang : '$lang-$country';
}


  /// Translates [text] by looking up to corresponding
 String translate(String text, {bool capitilize = true, Locale? locale}) {
  final tag = bcp47From(locale ?? TranslationController.localeStatic, fallback: 'en');
  String result = localize(text, _translations, languageTag: tag);
  if (capitilize && result.isNotEmpty) {
    result = '${result[0].toUpperCase()}${result.substring(1)}';
  }
  return (result.isNotEmpty && result != '%')
      ? result
      : (capitilize ? '! ${text[0].toUpperCase()}${text.substring(1)}' : '! $text');
}
  /*
   * Loads a translation from a markdown file in assets.
   * @author  SGV      - 20220218
   * @version 1.0      - 20220218  - Initial release 
   * @param   <String> - textKey   - key to find the document
   * @param   <Locale> - locale    - Recognizes the language that the cell phone is
   * @param   <String> - folderKey - must be provided if the translation subfolder name is different from [textKey]
   * @return  <String> - Folder text to be displayed on the screen to the patient
   */
  Future<String> getMarkDownTranslation({required String? textKey, String? folderKey, Locale? locale}) async {
    assert(textKey != null);
    locale = TranslationController.localeStatic;
    folderKey = textKey;
    String? text;
    try {
      text = await rootBundle.loadString('assets/$textKey/${textKey}_${locale.toString()}.md');
    } catch (e) {
      try {
        text = await rootBundle.loadString('assets/$textKey/${textKey}_${Locale('en').toString()}.md');
      } catch (e) {
      }
    }
    if (text!.isEmpty) {
      text = await rootBundle.loadString('assets/$textKey/${textKey}_${Locale('en').toString()}.md');
    }

    return text.toString();
  }


  /// Converts the locale string to the format used in TranslationEntry database table
  static String formatLocaleToDbString(String localeTag) {
    return localeTag.replaceAll(RegExp('[^A-Za-z]'), '').toLowerCase();
  }

  /// Converts the locale string used in the TranslationEntry database table to the conventional format
  static String formatDbStringToLocale(String dbString) {
    if (dbString.length != 2 && dbString.length != 4) {
      return null.toString();
    }
    return dbString.replaceAllMapped(RegExp(r'([A-Z]\w)'), (Match m) => '_${m[0]!.toUpperCase()}');
  }
}

class TranslationDelegate extends LocalizationsDelegate<TranslationController> {
  const TranslationDelegate();

  @override
  bool isSupported(Locale locale) => ['es' "en", "pt", "es", "de","fr", "it"].contains(locale.languageCode);

  @override
  Future<TranslationController> load(Locale locale) async {
    TranslationController translation = TranslationController.getInstance();
    if(TranslationController.localeStatic != null){
      return translation;
    }
    // await AppDatabase.getInstance().initializeDatabase();
    await translation.loadTranslations();
    TranslationController.localeStatic = locale;
    return translation;
  }

  /*
   * load last application language
   * Obs: this method is used to load translations in background and when app receive firebase message
   * @author SGV
   * @version 1.0 - 20210928 - initial release
   * @return  void
   */
  Future<void> loadLastApplicationLanguage() async {
    if(TranslationController.localeStatic == null || TranslationController.localeStatic.toString() == "null"){
      String lastApplicationLanguage = 'en';
      await this.load(Locale.fromSubtags(languageCode: lastApplicationLanguage));
    }
  }

  @override
  bool shouldReload(TranslationDelegate old) => false;
}

/*
 * Check the first letter in case estella lowercase will be changed to uppercase
 * @author  SGV - 20210419
 * @version 1.0 - 20210419 - initial release
 * @return  first capital letter
 */
extension CapExtension on String {
  String get inCaps => this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}

/// Wrapper function for [TranslationController.translate], with the option to capitalize first letter
String translate(String text, {bool capitilize = true, Locale? locale}) {
 
  String resultText = '';
  if (capitilize) {
    resultText = TranslationController.getInstance().translate(text, locale:locale).inCaps;
  } else {
    resultText = TranslationController.getInstance().translate(text, locale:locale);
  }
  return (resultText != '' && resultText != '%' ? resultText : (capitilize ? "! " + text.inCaps : "! " + text));
}

