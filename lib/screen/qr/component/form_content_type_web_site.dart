import 'package:flutter/material.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';

class FormContentTypeWebSite extends StatefulWidget {
  const FormContentTypeWebSite({super.key});

  @override
  State<FormContentTypeWebSite> createState() => _FormContentTypeWebSiteState();
}

class _FormContentTypeWebSiteState extends State<FormContentTypeWebSite> {
  final formKey = GlobalKey<FormState>();
  TextEditingController websiteController = TextEditingController(text: "https://");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: MediaQuery.of(context).size.height * 0.03,
        children: [
          TextFormFieldCustom(
            controller: websiteController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            labelText:translate("web"),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return translate("please enter a valid value");
              }
              return null;
            },
            onChanged: (value) {
              if (value.trim().isEmpty) {
                websiteController.clear();
              } else {
                websiteController.value.copyWith(text: value);
              }
            },
          ),
          PlanBadgeCard(
            borderGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomColors.primary, CustomColors.primary], // aqua → violeta
            ),
            onTap: ()async{
              String data = ""; 
             if (formKey.currentState!.validate()) {
                showCircularLoadingDialog(context);
                FocusScope.of(context).unfocus();
                data = websiteController.text;
               Navigator.of(context).pop();
               Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.createdQrScreen,(route) => false, arguments: data);
              }
              
            },
            child:Text(
              translate("create"), 
              style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
              textAlign: TextAlign.center,
            )
          )
        ]
      )
    );
  }
}