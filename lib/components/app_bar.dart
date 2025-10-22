import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:qr_master/config/style.dart';

/*
 * Component of appBar defauld, to be used throughout the app
 * @author  SGV - 20250728
 * @version 1.0 - 20250728 - initial release
 * @param   <action> widget to show component appBar 
 * @param   <routes> It is not mandatory but if you want the back icon to appear,
 *                   you have to pass the routes parameter to know where it will be directed
 * @return  <component> widget
 */
appBarCustom(BuildContext context, {Color? backgroundColor, Color? iconColor, Function()? onTap, bool showButtonReturn = false, Widget? title, Widget? widgetAction, bool showbuttonNotification = false,  bool showbuttonAction = false}) {
  return AppBar(
    backgroundColor:CustomColors.primaryDark,
    //automaticallyImplyLeading: false,
    // flexibleSpace:  WaveHeader(
    //   height: Constants.spaceDivide,
    //   body:Container()
    // ),
    
    centerTitle: false,
    titleSpacing: 10, 
    actionsPadding:EdgeInsets.fromLTRB(0, showbuttonNotification ? 40 : 0 , 0, 0), 
    leading:showButtonReturn ? Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), 
      child: GestureDetector(
        onTap:onTap,
        child: Container( 
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), 
          child: FaIcon(
            LineAwesomeIcons.chevron_left_solid, 
            color:iconColor ?? CustomColors.white,
            size: 25
          ),
        ), 
      )
    ): null,
    toolbarHeight: 56,    
    elevation: 4,
    title:Row(
      children: [
        if(title != null)...[
          title,
        ],
      ]
    ), 
  );
}


