import 'package:flutter/material.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/success_dialog.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/qr_record_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/database/qr_master_database.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:qr_master/services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
// Share app
          showMenu(
            title:translate("share app"),
            leading: const Icon(Icons.share, color: CustomColors.primary)
          ),
// WEB PORTFOLIO
          showMenu(
            title:translate("web - portfolio"), 
            leading: const Icon(Icons.web, color: CustomColors.primary),
            onTap:()async{
             await FunctionsClass().redirectUrl(url: "https://sergiomarcano.globalvisionprojects.online/");
            }
          ),
// TERM AND CONDITIONS
          showMenu(
            title:translate("terms and Conditions"), 
            leading: const Icon(Icons.description_outlined, color: CustomColors.primary),
            onTap: ()async{
              await FunctionsClass().redirectUrl(url:"https://globalvisionprojects.online/politica-de-privacidad-juegos/qr-master.html");
              
            }
          ),
// FEEDBACK
          showMenu(
            title:translate("feedback"), 
            leading: const Icon(Icons.chat_bubble_outline, color: CustomColors.primary),
            onTap: () async{
              final Uri emailLaunchUri = Uri.parse('mailto:u6081997752@gmail.com');
              await launchUrl(emailLaunchUri); 
            },
          ),
// DELETE ALL INFORMATION
          showMenu(
            title:translate("delete all informations"), 
            leading: const Icon(Icons.delete, color: CustomColors.primary),
             onTap: () async{
              showCircularLoadingDialog(context);
              await serviceLocator<QrMasterDatabase>().qrRecordEntityDao.deleteAll();
              if (!context.mounted) return;
              Navigator.of(context).pop();
              showMessageForUser(context, routeName: RouteAppName.homeScreen);
            },
          ),
          
          
        ]
      ),
    );
  }


  showMenu({void Function()? onTap, required String title, Widget? leading}){
    return ListTile(
      leading: leading,
      title:Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
      ),
      trailing:Icon(
        Icons.arrow_forward_ios, 
        color: CustomColors.white, 
        size:Theme.of(context).textTheme.bodyMedium!.fontSize
      ),
      onTap: onTap,
    );

  }
}