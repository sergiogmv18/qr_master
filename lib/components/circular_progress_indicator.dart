import 'package:flutter/material.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/config/style.dart';

/*
 * circular progress indicator widget
 * @author  SGV - 20250728
 * @version 1.0 - 20250728 - initial release
 * @param   BuildContext context - widget context
 * @param   Color? color - optional color for the indicator
 * @return  Widget - centered circular progress indicator
 * @note    uses primary color by default if no color specified
 * @example
 *   circularProgressIndicator(context) // default color
 *   circularProgressIndicator(context, color: Colors.red) // custom color
 */
Widget circularProgressIndicator(BuildContext context, {Color? color}) {
  return Center(
    child: CircularProgressIndicator(color:color ?? CustomColors.primary),
  );
}

/*
 * Show icon circular for expect loading next step 
 * @author  SGV - 20250728
 * @version 1.0 - 20250728 - initial release
 * @return  <component> showDialog and redirect to previous page
 */
Future<void> showCircularLoadingDialog(BuildContext context ,{Color? color}) async {  
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return popScopeCustom(
      canPop: false,
      child:  circularProgressIndicator(context, color:color),
      );
    }
  );
}