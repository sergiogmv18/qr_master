import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';

/* Customizable confirmation dialog widget for critical actions.
 * @author  SGV - 20250804
 * @version 1.0 - 20250804 - initial release
 * 
 * @param   title - Main dialog message (required)
 * @param   subtitle - Optional secondary text
 * @param   icon - Custom icon widget (default: none)
 * @param   showButtonCancel - Toggles secondary button visibility (default: true)
 * @param   titleButton - Primary action button text (default: empty)
 * @param   subtitleButton - Secondary button text (default: "Cancelar")
 * @param   onPressedTitleButton - Primary action callback (required)
 * @param   onPressedSubtitleButton - Secondary action callback
 * 
 * UI Features:
 *  - Centered modal layout (90% screen width)
 *  - Circular icon container with semi-transparent background
 *  - Responsive button row with spacing
 *  - Customizable color scheme from CustomColors
 *  - Adaptive typography using theme
 * 
 * Behavior:
 *  - Primary button executes main action (typically destructive)
 *  - Secondary button allows cancellation when visible
 * 
 * Usage Example:
 *   ConformationDialog(
 *     title: "Confirmar eliminación",
 *     subtitle: "Los datos no podrán recuperarse",
 *     icon: Icon(Icons.warning),
 *     titleButton: "Eliminar",
 *     onPressedTitleButton: () => deleteItem(),
 *   );
 * 
 * Dependencies:
 *  - CustomButtons.quantTaxButton implementation
 *  - CustomColors palette
 *  - Constants.borderRadiusfixed value
 */
class ConformationDialog extends StatefulWidget {
  final String? subtitle;
  final String title;
  final Widget? body;
  final bool showButtonCancel;
  final Widget? icon;
  final String titleButton;
  final String subtitleButton;
  final Color containerColorIcon;
  final void Function() onPressedTitleButton;
  final void Function()? onPressedSubtitleButton;
  const ConformationDialog({super.key, this.icon, required this.title, this.body, this.containerColorIcon = CustomColors.primary, this.showButtonCancel = true, this.subtitle, this.titleButton = "", this.subtitleButton="Cancelar", required this.onPressedTitleButton, this.onPressedSubtitleButton});
  @override
  State<StatefulWidget> createState() => ConformationDialogState();
}

class ConformationDialogState extends State<ConformationDialog> with SingleTickerProviderStateMixin {
 


  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(Constants.borderRadius)
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.containerColorIcon.withAlpha((0.2 * 255).toInt())
              ),
              child: widget.icon, 
            ),
            SizedBox(height: 10),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: CustomColors.dark,
              )
            ),
            SizedBox(height: 5),
            if(widget.body != null)...[
              widget.body!
            ]else...[
              Text(
                widget.subtitle ?? "",
                textAlign: TextAlign.center,
                style:Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: CustomColors.dark,
                )
              ),
            ],
            SizedBox(
              height: 30,
            ),
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(widget.showButtonCancel)...[
                  TextButton(
                    onPressed:widget.onPressedSubtitleButton!,
                    child:Text( 
                      widget.subtitleButton, 
                      style:Theme.of(context).textTheme.bodyLarge!.copyWith(color: CustomColors.dark)
                    )
                  ),
                ],
                TextButton(
                  onPressed:widget.onPressedTitleButton, 
                  child: Text(
                    widget.titleButton, 
                    style:Theme.of(context).textTheme.bodyLarge!.copyWith(color: CustomColors.error)
                  )
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}



/* Displays a customizable confirmation dialog for delete actions.
 * @author  SGV - 20250804
 * @version 1.0 - 20250804 - initial release
 * 
 * @param   context - Required BuildContext for dialog display
 * @param   title - Main dialog title text (required)
 * @param   subtitle - Optional secondary description text
 * @param   titleButton - Text for primary action button (required)
 * @param   onPressedTitleButton - Callback for primary button (required)
 * @param   onPressedSubtitleButton - Optional callback for secondary action
 * 
 * UI Features:
 *  - Warning triangle icon with error color
 *  - Dismissible by tapping outside (barrierDismissible: true)
 *  - Customizable button texts and actions
 * 
 * Behavior:
 *  - Primary button executes destructive action (typically delete)
 *  - Secondary button (if provided) allows alternative flow
 * 
 * Usage Example:
 *   showConformationDeleteDialog(
 *     context: context,
 *     title: "Eliminar cliente",
 *     subtitle: "Esta acción no se puede deshacer",
 *     titleButton: "Confirmar",
 *     onPressedTitleButton: () => deleteClient(),
 *     onPressedSubtitleButton: () => Navigator.pop(context),
 *   );
 * 
 * Dependencies:
 *  - ConformationDialog widget implementation
 *  - CustomColors.errorColor definition
 *  - font_awesome_flutter package
 */
Future<void> showConformationDeleteDialog({required BuildContext context,  
  final String? subtitle,
  required String title,
  required String titleButton,
  required void Function() onPressedTitleButton,
  void Function()? onPressedSubtitleButton,
}) async {
  await showDialog(
    context: context,
    barrierDismissible:true,
    builder: (BuildContext context) {
      return ConformationDialog(
        title:title,
        subtitle: subtitle,
        onPressedSubtitleButton: onPressedSubtitleButton,
        titleButton:translate("yes, Remove"),
        onPressedTitleButton:onPressedTitleButton,
        containerColorIcon:CustomColors.error,
        icon: FaIcon(
          FontAwesomeIcons.triangleExclamation, 
          color:CustomColors.error,
          size: 30
        ),
      );
    }
  ); 
}


/*
* show exit confirmation dialog when unsaved changes exist
* @author  SGV
* @version 1.0 - 20250903 - initial release
* @param   context - required BuildContext for dialog display
* @param   onPressedTitleButton - required callback for exit confirmation
* @return  Future<void> - completes when dialog is dismissed
* @throws  
* @see     showDialog(), ConformationDialog()
* @note    displays warning dialog with exclamation icon
*          allows barrier dismissal for user convenience
*          provides option to exit or cancel operation
*          uses warning colors for visual emphasis
*          typically used in forms with unsaved changes
* @example 
*   await onWillPop(
*     context: context,
*     onPressedTitleButton: () {
*       Navigator.of(context).pop(); // Close dialog
*       Navigator.of(context).pop(); // Exit screen
*     }
*   );
*/
// Future<void> onWillPop(BuildContext context, {required void Function() onPressedTitleButton}) async {
//   return showDialog(
//     context: context,
//     barrierDismissible:true,
//     builder: (context) =>  ConformationDialog(
//       title:"¿Salir sin guardar?",
//       subtitle: "Tienes cambios sin guardar, ¿quieres salir de todas formas?",
//       onPressedSubtitleButton:() => Navigator.of(context).pop(),
//       titleButton: "Salir",
//       onPressedTitleButton:onPressedTitleButton,
//       containerColorIcon:CustomColors.bsWarning,
//       icon: FaIcon(
//         LineAwesomeIcons.exclamation_circle_solid, 
//         color:CustomColors.bsWarning,
//         size: 30
//       ),
//     ),
//   );
// }