import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FunctionsClass {


  /* Validates a password against configurable complexity rules.
  * @author  SGV - 20250729
  * @version 1.0 - 20250729 - initial release
  * 
  * @param   password - Password string to validate
  * @param   requireLowercase - Enforce lowercase letters (default: true)
  * @param   requireNumbers - Enforce numbers (default: true)
  * @param   requireSpecialChars - Enforce special chars (default: true)
  * 
  * @return  Map<String,dynamic> - Validation result containing:
  *           - isValid: bool (meets all requirements)
  *           - message: String (validation status)
  *           - errors: List<String> (missing requirements)
  * 
  * Validation Rules:
  *  - Minimum 8 characters length (always enforced)
  *  - At least 1 uppercase letter (A-Z) (always enforced)
  *  - Optional rules (configurable via parameters):
  *    - 1 lowercase letter (a-z)
  *    - 1 number (0-9)
  *    - 1 special character (!@#\$%^&*)
  * 
  * Usage Example:
  *   final result = validatePassword("SecurePass123!");
  *   if(!result['isValid']) {
  *     showErrors(result['errors']);
  *   }
  * 
  * Output Example:
  *   {
  *     isValid: false,
  *     message: "Password missing requirements",
  *     errors: ["Needs at least 1 number"]
  *   }
  */
  Map<String, dynamic> validatePassword(String password) {
    final errors = <String>[];
    if (password.isEmpty) {
      return {
        'isValid': false,
        'message': 'Password cannot be empty'
      };
    }
    // Check length
    if (password.length < 8) {
      errors.add('8 caracteres mínimo');
    }
    // Check uppercase
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add('1 letra mayúscula');
    }
    // Check lowercase (optional)
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add('1 letra minúscula');
    }
    // Check number (optional)
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add('1 número');
    }
    // Check special character (optional)
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      errors.add('1 carácter especial');
    }
    return {
      'isValid': errors.isEmpty,
      'message': errors.isEmpty 
          ? 'Password is valid' 
          : 'Missing: ${errors.join(', ')}',
      'errors': errors // Detailed error list (optional)
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

  /*
  * Returns a time-appropriate greeting based on the current hour
  * 
  * @author  SGV
  * @version 1.0 - 20250730
  * 
  * @return  <String> - Corresponding greeting:
  *          "Good morning" (5:00 - 11:59)
  *          "Good afternoon" (12:00 - 17:59)
  *          "Good evening" (18:00 - 21:59)
  *          "Good night" (22:00 - 4:59)
  * 
  * @example
  * print(getTimeGreeting()); // "Good afternoon" (if it's 15:00)
  * 
  * @note    Uses the device's local time
  *          Automatically considers timezone changes
  */
  String getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Buenos días!';
    if (hour >= 12 && hour < 18) return 'Buenas tardes!';
    if (hour >= 18 && hour < 22) return 'Buenas noches!';
    return 'Good night';
  }



  /* Converts a numeric string to EU currency format with thousand separators.
  * @author  SGV - 20250731
  * @version 1.0 - 20250731 - initial release
  * @param   <String> numberString - Input (e.g. "1234.5", "1000", "50.00")
  * @return  <String> - Formatted value with: 
  *           - Thousand separators (.)
  *           - Comma as decimal separator
  *           - Exactly 2 decimal places
  *           - Euro symbol appended
  *           - Returns "0,00€" on invalid input (or throws FormatException)
  */
  String formatToEuroCurrency(String? numberString) {
    if(numberString == null) return "";
    
    final number = double.tryParse(numberString);
    if (number == null) {
      return '0,00'; 
    }
    final formattedNumber = number.toStringAsFixed(2)
        .replaceAll('.', ',')
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+,)'), 
          (match) => '${match[1]}.',
        );
    return formattedNumber;
  }



  /*
  * Formats a date string to Spanish locale (dd/MM/yyyy).
  * @author  SGV - 20250805
  * @version 1.1 - 20250805 - added null safety
  * 
  * @param   rawDate - Input date string (ISO format or null)
  * @return  String - Formatted date or empty string if:
  *           - Input is null/empty
  *           - Parsing fails
  * 
  * Behavior:
  *  - Accepts ISO 8601 strings (e.g. "2023-12-31T00:00:00Z")
  *  - Returns localized day/month/year format
  *  - Fails gracefully with empty string
  * 
  * Usage Examples:
  *   formatDateToSpanish("2023-12-31") → "31/12/2023"
  *   formatDateToSpanish(null) → ""
  * 
  * Dependencies:
  *  - intl.DateFormat package
  *  - Requires initialized localization
  */
  static String formatDateToSpanish({String? rawDate, DateTime? currentDate, String format = "dd/MM/yyyy", bool formatEN = false}) {
    if(currentDate != null){
      if(formatEN){
        return DateFormat("yyyy-MM-dd").format(currentDate);
      }
      return DateFormat(format).format(currentDate);
    }
    if (rawDate == null || rawDate.trim().isEmpty){
      return '';
    }
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat(format).format(parsedDate);
    } catch (e) {
      return '';
    }
  }


  /*
  * Formats a date string to Spanish locale (dd/MM/yyyy).
  * @author  SGV - 20250825
  * @version 1.1 - 20250825 - added null safety
  * 
  * @param   rawDate - Input date string (ISO format or null)
  * @return  String - Formatted date or empty string if:
  *           - Input is null/empty
  *           - Parsing fails
  * 
  * Behavior:
  *  - Accepts ISO 8601 strings (e.g. "2023-12-31T00:00:00Z")
  *  - Returns localized day/month/year format
  *  - Fails gracefully with empty string
  * 
  * Usage Examples:
  *   formatDateToSpanish("2023-12-31") → "31/12/2023"
  *   formatDateToSpanish(null) → ""
  * 
  * Dependencies:
  *  - intl.DateFormat package
  *  - Requires initialized localization
  */
  static String convertSpanishToISO({required String spanishDate, String inputFormat = "dd/MM/yyyy", String outputFormat = "yyyy-MM-dd"}) {
    if (spanishDate.isEmpty) return '';
    try {
      final inputFormatter = DateFormat(inputFormat);
      final date = inputFormatter.parseStrict(spanishDate);
      final outputFormatter = DateFormat(outputFormat);
      return outputFormatter.format(date);
    } catch (e) {
      return '';
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




  /* Validates if a string is properly formatted Base64 encoded data.
  * @author  SGV - 20250811
  * @version 1.1 - 20250811 - added length and decode validation
  * 
  * @param   input - String to validate
  * @return  bool - True only if:
  *           - Matches Base64 character set
  *           - Has correct length (multiple of 4)
  *           - Passes actual decoding test
  *           - Minimum length of 20 chars
  * 
  * Validation Layers:
  *  1. Character Set: [A-Za-z0-9+/=]
  *  2. Length Rules:
  *     - Minimum 20 characters
  *     - Length % 4 == 0
  *  3. Decoding Test: Successful base64Decode()
  * 
  * Usage Examples:
  *   isValidBase64("SGVsbG8=") → true
  *   isValidBase64("Invalid!") → false
  * 
  * Edge Cases Handled:
  *  - Empty/whitespace strings → false
  *  - Short strings (<20 chars) → false
  *  - Missing padding → false
  *  - Invalid characters → false
  * 
  * Dependencies:
  *  - dart:convert base64Decode()
  * 
  * Security Notes:
  *  - Doesn't validate content type (could be any binary data)
  *  - Minimum length prevents false positives
  */
  bool isValidBase64(String input) {
    // Base64 válido solo contiene A–Z, a–z, 0–9, +, / y = (para padding)
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    // Limpiamos espacios
    final cleaned = input.trim();
    // Mínimo ~20 caracteres para evitar falsos positivos cortos
    if (cleaned.length < 20) return false;
    if (cleaned.length % 4 != 0) return false;
    if (!base64Pattern.hasMatch(cleaned)) return false;
    // Intentar decodificar para confirmar
    try {
      base64Decode(cleaned);
      return true;
    } catch (_) {
      return false;
    }
  }



  /*
  * format ISO date string to Spanish readable format with options
  * @author  SGV
  * @version 1.0 - 20250826 - initial release
  * @param   iso - ISO date string to format
  * @param   monthFirst - optional boolean to display month before day (default: false)
  * @return  String - formatted date in Spanish locale
  * @throws  FormatException - if ISO string is invalid or cannot be parsed
  * @see     DateFormat
  * @note    returns empty string if input ISO string is empty
  *          uses Spanish locale for month names and formatting
  *          supports two patterns: 'd MMMM y' or 'MMMM d, y'
  *          handles standard ISO 8601 date format
  * @example 
  *   formatDateEn('2025-08-26T10:30:00Z'); // returns '26 agosto 2025'
  *   formatDateEn('2025-08-26', monthFirst: true); // returns 'agosto 26, 2025'
  */
  String formatDateEn(String iso, {bool monthFirst = false}) {
    if(iso.isEmpty) return "";
    final d = DateTime.parse(iso);
    final pattern = monthFirst ? 'MMMM d, y' : 'd MMMM y';
    return DateFormat(pattern, 'es').format(d);
  }


  /*
  * verify if server response indicates token validation error (401 Unauthorized)
  * @author  SGV
  * @version 1.0 - 20250826 - initial release
  * @param   response - Map containing server response data
  * @return  bool - true if token is invalid (401 error), false otherwise
  * @throws  
  * @see     
  * @note    checks specifically for HTTP 401 Unauthorized error code
  *          looks for 'error' key in response map with value 401
  *          returns false for any other response format or error codes
  *          typically used to trigger token refresh or reauthentication
  * @example 
  *   if(getverifyTokenValidate(response: apiResponse)) {
  *     // Token is invalid, trigger refresh
  *   }
  */
  static bool getverifyTokenValidate({required Map<String, dynamic> response}){
    if(response.containsKey('error') &&  response["error"] == 401){
      return true;
    }
    return false;
    
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
  * parse string date to DateTime object with flexible format handling
  * @author  SGV
  * @version 1.0 - 20250826 - initial release
  * @param   date - string date to parse (can be null or empty)
  * @param   format - optional specific format string for parsing
  * @return  DateTime? - parsed DateTime object or null if input is empty
  * @throws  FormatException - if date string cannot be parsed with any format
  * @see     DateFormat, DateTime.parse()
  * @note    returns null if input date is null or empty string
  *          tries ISO format first if no specific format provided
  *          falls back to Spanish format (dd/MM/yyyy) if ISO fails
  *          throws detailed FormatException with parsing error information
  *          supports custom date formats through format parameter
  * @example 
  *   parseToDateTime('2025-08-26'); // returns DateTime(2025, 8, 26)
  *   parseToDateTime('26/08/2025'); // returns DateTime(2025, 8, 26)
  *   parseToDateTime('08-26-2025', format: 'MM-dd-yyyy'); // custom format
  */
  static DateTime? parseToDateTime(String? date, {String? format}) {
    if (date == null || date.isEmpty) return null;
    try {
      if (format != null) {
        // Usar el formato específico proporcionado
        return DateFormat(format).parse(date);
      } else {
        try {
          return DateTime.parse(date); // ISO format
        } catch (_) {
          return DateFormat('dd/MM/yyyy').parse(date); // Spanish format
        }
      }
    } catch (e) {
      throw FormatException("No se pudo parsear la fecha '$date'${format != null ? " con el formato '$format'" : ""}. Error: ${e.toString()}");
    }
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
  * check whether a string represents a negative number
  * @author  SGV
  * @version 1.0 - 20250915 - initial release
  * @param   numberString - optional String: textual number to evaluate
  * @return  bool - true if the parsed value is < 0, otherwise false
  * @throws  — (no exceptions)
  * @see     double.tryParse()
  * @note    replaces ',' with '.' before parsing; for strict locale parsing consider intl.NumberFormat
  * @example 
  *   final a = isNegativeNumber("-12");   // -> true
  *   final b = isNegativeNumber("3,5");   // -> false
  *   final c = isNegativeNumber(null);    // -> false
  */
  static bool isNegativeNumber(String? numberString) {
    final v = double.tryParse((numberString ?? '').trim().replaceAll(',', '.'));
    if (v == null) return false;
    return v < 0;
  }


  static bool dynamicToBool(dynamic value) {
    if (value == null) return false;
    
    if (value is bool) return value;
    
    if (value is num) {
      return value != 0;
    }
    
    if (value is String) {
      final lowerCaseValue = value.toLowerCase().trim();
      // Valores que se consideran true
      if (lowerCaseValue == 'true' || lowerCaseValue == '1' || lowerCaseValue == 'yes' || lowerCaseValue == 'si' || lowerCaseValue == 'on') {
        return true;
      }
      // Valores que se consideran false
      if (lowerCaseValue == 'false' || lowerCaseValue == '0' || lowerCaseValue == 'no' ||  lowerCaseValue == 'off') {
        return false;
      }
      // Para strings no reconocidos, verificar si no está vacío
      return value.isNotEmpty;
    }
    // Para otros tipos (listas, maps, objetos), verificar si no son vacíos/null
    return value != null;
  }



  /*
  * validates a date range (initialDate and finalDate)
  * @author   Quantax
  * @version  1.0 - 20251006 - initial release
  * @param    initialDate - required DateTime?: starting date to validate
  * @param    finalDate   - required DateTime?: ending date to validate
  * @param    min         - optional DateTime?: minimum allowed date (inclusive)
  * @param    max         - optional DateTime?: maximum allowed date (inclusive)
  * @param    allowSameDay - optional bool: allows start and end to be on the same day (default: true)
  * @param    compareTime  - optional bool: if false, only compares dates ignoring time (default: false)
  * @return   String? - null if valid; otherwise, an error message
  * @throws   — (no exceptions)
  * @see      DateTime.isBefore(), DateTime.isAfter()
  * @note     When compareTime == false, all dates are normalized to midnight before comparison.
  * @example  
  *   final err = validateDateRange(
  *     DateTime(2025, 1, 1),
  *     DateTime(2025, 1, 10),
  *     min: DateTime(2024, 1, 1),
  *     max: DateTime(2025, 12, 31),
  *     allowSameDay: true,
  *   );
  *   if (err != null) print(err);
  */
  String? validateDateRange({ DateTime? initialDate, DateTime? finalDate, DateTime? min, DateTime? max, bool allowSameDay = true, bool compareTime = false}) {
    if (initialDate == null) return 'La fecha inicial es requerida.';
    if (finalDate == null) return 'La fecha final es requerida.';

    DateTime start = initialDate;
    DateTime end = finalDate;

    if (!compareTime) {
      start = DateTime(start.year, start.month, start.day);
      end   = DateTime(end.year, end.month, end.day);
      if (min != null) min = DateTime(min.year, min.month, min.day);
      if (max != null) max = DateTime(max.year, max.month, max.day);
    }

    if (allowSameDay) {
      if (end.isBefore(start)) return 'La fecha final no puede ser anterior a la inicial.';
    } else {
      if (!end.isAfter(start)) return 'La fecha final debe ser posterior a la inicial.';
    }

    if (min != null && (start.isBefore(min) || end.isBefore(min))) {
      return 'Las fechas no pueden ser anteriores a ${_fmt(min)}.';
    }
    if (max != null && (start.isAfter(max) || end.isAfter(max))) {
      return 'Las fechas no pueden ser posteriores a ${_fmt(max)}.';
    }

    return null;
  }

  /*
  * returns an ordered date range ensuring start <= end
  * @author   Quantax
  * @version  1.0 - 20251006 - initial release
  * @param    a - required DateTime: first date to compare
  * @param    b - required DateTime: second date to compare
  * @return   ({DateTime start, DateTime end}) - a record containing the ordered range
  * @throws   — (no exceptions)
  * @see      DateTime.isBefore()
  * @note     Useful when user input might have dates in reverse order.
  * @example  
  *   final range = normalizeRange(DateTime(2025, 5, 10), DateTime(2025, 3, 2));
  *   print(range.start); // -> 2025-03-02
  *   print(range.end);   // -> 2025-05-10
  */
  ({DateTime start, DateTime end}) normalizeRange(DateTime a, DateTime b) {
    return a.isBefore(b) ? (start: a, end: b) : (start: b, end: a);
  }


  /*
  * formats a DateTime object into dd/MM/yyyy string format
  * @author   Quantax
  * @version  1.0 - 20251006 - initial release
  * @param    d - required DateTime: date to format
  * @return   String - formatted date as "dd/MM/yyyy"
  * @throws   — (no exceptions)
  * @see      DateTime.day, DateTime.month, DateTime.year
  * @note     Always pads day and month with leading zeros (e.g., 01/09/2025).
  * @example  
  *   final s = _fmt(DateTime(2025, 9, 1)); // -> "01/09/2025"
  */
  String _fmt(DateTime d) =>'${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';



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


  String formatHoursMinutes(int durationMs){
    if (durationMs < 0) durationMs = 0;
    final d = Duration(milliseconds: durationMs);
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(hours)}:${two(minutes)}';
  }

  String dayKeyUtc(DateTime dtUtc){
    String day ='${dtUtc.year.toString().padLeft(4,'0')}-''${dtUtc.month.toString().padLeft(2,'0')}-''${dtUtc.day.toString().padLeft(2,'0')}';
    return day;
  }
}
    