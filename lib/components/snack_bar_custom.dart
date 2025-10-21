import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:qr_master/config/style.dart';

/*
 * Custom snackbar component to display temporary notification messages
 * 
 * @author  SGV
 * @version 1.0 - 20250728 - initial release
 * 
 * @param   <BuildContext> context - Required context to show the snackbar
 * @param   <String> type - Type of snackbar: "success" (default), "error", or "info"
 * @param   <String?> text - Optional text message to display (mutually exclusive with content)
 * @param   <Widget?> content - Optional custom widget content (mutually exclusive with text)
 * 
 * @return  void - Displays snackbar but doesn't return any value
 * 
 * @example 
 * // Basic usage with text
 * snackBarCustom(context, type: "error", text: "Operation failed");
 * 
 * // Custom content widget
 * snackBarCustom(context, content: Row(children: [Icon(Icons.check), Text("Success")]));
 * 
 * @note    Either text or content must be provided, but not both
 *          Default duration is controlled by ScaffoldMessenger
 */
snackBarCustom(BuildContext context, {String type ="success", String? title,Duration? duration= const Duration(seconds: 4), required String subtitle, FlushbarPosition flushbarPosition = FlushbarPosition.TOP}){
  Color? backgroundColor = CustomColors.primary;
  Color? textColor = Colors.white;
  switch(type){
    case "error": 
      backgroundColor = CustomColors.error;
      textColor = Colors.white;
    break;
    case "info":
      backgroundColor = CustomColors.secundaryColor;
      textColor = Colors.black;
  }  
  return Flushbar(
    title: title,
    titleSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
    titleColor: textColor,
    message: subtitle,
    messageColor: textColor,
    messageSize:Theme.of(context).textTheme.titleLarge!.fontSize,
    duration: duration,
    backgroundColor: backgroundColor,

    flushbarPosition: flushbarPosition,
  ).show(context);

}