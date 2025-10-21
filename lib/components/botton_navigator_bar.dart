import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/botton_navigator_bar_provider.dart';

/* Custom bottom navigation bar with animated selected items.
 * @author  SGV - 20250813
 * @version 2.1 - 20250813 - added gradient selection
 * 
 * Features:
 *  - Gradient background for active items
 *  - Disabled ripple effect
 *  - Responsive icon sizing
 *  - State management via Provider
 *  - Consistent theming
 * 
 * Navigation Items:
 *   1. Home (Panel)
 *   2. Clients (Gestión)
 *   3. Projects (Proyectos)
 *   4. Settings (Configuración)
 * 
 * Usage:
 *   Wrap with Provider<BottonNavigationBarProvider>
 *   Set initial index via Provider
 * 
 * Dependencies:
 *  - provider package
 *  - font_awesome_flutter
 *  - CustomColors constants
 *  - BottonNavigationBarProvider
 * 
 * Styling:
 *  - Selected: Gradient background with larger icon
 *  - Unselected: Simple icon with default color
 *  - Transparent background
 *  - Custom font sizes from theme
 */
class BottonNavigatorBarCustom extends StatelessWidget {
  final bool redirectToHome;
  final void Function(int)? onTap;
  const BottonNavigatorBarCustom({super.key, this.redirectToHome = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: CustomColors.white,
        highlightColor: CustomColors.white,
        hoverColor: CustomColors.white,
        splashFactory: NoSplash.splashFactory, // sin ondas
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomColors.primaryDark,
        elevation: 0,  
        iconSize: 20,
        selectedItemColor: CustomColors.primary,
        unselectedItemColor: CustomColors.white,
        currentIndex: Provider.of<BottonNavigationBarProvider>(context).currentIndexPage,
        selectedFontSize: Theme.of(context).textTheme.labelSmall!.fontSize!,
        unselectedFontSize: Theme.of(context).textTheme.labelSmall!.fontSize!,
        onTap:onTap ?? (index){
          Provider.of<BottonNavigationBarProvider>(context, listen: false).currentIndexPage = index; 
          if(redirectToHome){
            Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.homeScreen,(route) => false);
          }
        },
        items: <BottomNavigationBarItem>[
          _item(
            icon: Icon(LineAwesomeIcons.home_solid, color: CustomColors.primary, size: 25), 
            iconData: Icon(LineAwesomeIcons.home_solid, color: CustomColors.white, size: 20), 
            label:translate("home"),
          ),
          _item(
            icon: FaIcon(LineAwesomeIcons.users_cog_solid, color: CustomColors.primary, size: 25), 
            iconData: FaIcon(LineAwesomeIcons.users_cog_solid, color: CustomColors.white, size: 20), 
            label:translate("create"),
          ),
          _item(
            icon: FaIcon(LineAwesomeIcons.file_invoice_solid, color: CustomColors.primary, size: 25), 
            iconData: FaIcon(LineAwesomeIcons.file_invoice_solid, color: CustomColors.white, size: 20), 
            label:translate("history")
          ),
          _item(
            icon: FaIcon(LineAwesomeIcons.cog_solid, color: CustomColors.primary, size: 25), 
            iconData: FaIcon(LineAwesomeIcons.cog_solid, color: CustomColors.white, size: 20), 
            label:translate("suscriptions"),
          ),
        ]
      ),
    );
  }
}

/* Creates a customized navigation bar item
* @param icon - Large version for active state
* @param iconData - Regular version for inactive state
* @param label - Item title
*/
BottomNavigationBarItem _item({required Widget icon, required String label, required Widget iconData}) {
  return BottomNavigationBarItem(
    label: label,
    tooltip:label,
    backgroundColor: CustomColors.white, 
    icon: _NavItem(icon: icon, label: label, selected: false, iconData:iconData),
    activeIcon: _NavItem(icon: icon, label: label, selected: true, iconData:iconData),
  );
}


/* Custom navigation item with different states
 * @param icon - Icon widget to display
 * @param label - Accessibility label
 * @param selected - Whether item is active
 * @param iconData - Fallback icon for inactive state
 */
class _NavItem extends StatelessWidget {
  final Widget icon;
  final Widget iconData;
  final String label;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    if (selected){
      return Container(
       // width: 40,
       // height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(Constants.borderRadius),
          ),
          color: CustomColors.primaryDark
        ),
        child:Align(
          alignment: Alignment.center,
          child:icon,
        )
      );
    }
    return Center( 
      child: iconData,
    );
  }
}