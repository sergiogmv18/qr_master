import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_master/config/style.dart';

class FuncionComponents {


  /*
  * show customizable select field with title and dropdown indicator
  * @author  SGV
  * @version 1.0 - 20250902 - initial release
  * @param   context - required BuildContext for theme access
  * @param   width - optional width for the container
  * @param   controller - optional TextEditingController for text display
  * @param   onTap - required callback function when field is tapped
  * @param   label - required label text for the field
  * @param   showIcon - optional boolean to show dropdown icon (default: true)
  * @param   textTitle - optional text to display if controller is null
  * @param   errorLabel - optional error message to display below field
  * @return  Widget - GestureDetector with select field UI
  * @throws  
  * @see     Theme.of(), TextEditingController, jsonDecode()
  * @note    displays label and selected value with dropdown indicator
  *          shows error message with red color if errorLabel provided
  *          uses jsonDecode to extract "name" from controller text
  *          changes border color to error color if error exists
  *          supports both controller-based and textTitle-based display
  * @example 
  *   Components.showTitleOfSelect(
  *     context: context,
  *     onTap: () => showSelectionDialog(),
  *     label: "Select Option",
  *     controller: myController,
  *     errorLabel: "This field is required"
  *   );
  */
  static showTitleOfSelect({required BuildContext context, bool enabled = true, double? width, double? textWidth, TextEditingController? controller, required void Function()? onTap, required String label,bool showIcon = true, String textTitle = "", String? errorLabel}){
    return  GestureDetector(
      onTap:enabled ? onTap : null,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(6, 2, 0, 0),
            width: width,
            decoration: BoxDecoration(
              color: CustomColors.primaryDark, // fillColor + filled: true
              border: Border(
                bottom: BorderSide(
                  color: errorLabel != null ? CustomColors.error : CustomColors.white, // borderSide color
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: textWidth ?? MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: CustomColors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    ),
                    SizedBox(
                      width: textWidth ?? MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                      controller != null ? controller.text.isNotEmpty ? jsonDecode(controller.text)["name"]: controller.text: textTitle,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: CustomColors.white, // labelStyle
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    )
                    
                  ],
                ),
                if(showIcon)...[    
                  Icon(
                    Icons.arrow_drop_down,
                    color: CustomColors.white, // iconEnabledColor
                  ),
                ], 
              ],
            ),
          ),
          if(errorLabel != null)...[
            Text(
              errorLabel,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: CustomColors.error),
            ),
          ]
          
        ],
      ) 
    );
  }



}