import 'package:flutter/material.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/services/function_class.dart';

class FormContemTypeEmail extends StatefulWidget {
  const FormContemTypeEmail({super.key});

  @override
  State<FormContemTypeEmail> createState() => _FormContemTypeEmailState();
}

class _FormContemTypeEmailState extends State<FormContemTypeEmail> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: MediaQuery.of(context).size.height * 0.03,
        children: [
// EMAIL ADDRESS
           TextFormFieldCustom(
            controller: emailAddressController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            labelText: translate("email address"),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return translate("please enter a valid value");
              }
              final validate = FunctionsClass().validateEmailAddress(value);
              if (validate['isValid']) {
                return null;
              } else {
                return validate["message"];
              }
            },
            onChanged: (value) {
              if (value.trim().isEmpty) {
                emailAddressController.clear();
              } else {
                emailAddressController.value.copyWith(text: value);
              }
            },
          ), 
// SUBJECT
          TextFormFieldCustom(
            controller: subjectController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            labelText:translate("subject"),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return translate("please enter a valid value");
              }
              return null;
            },
            onChanged: (value) {
              if (value.trim().isEmpty) {
                subjectController.clear();
              } else {
                subjectController.value.copyWith(text: value);
              }
            },
          ),
//MESSAGE,
          TextFormFieldCustom(
            controller: messageController,
            textInputAction: TextInputAction.newline,
            minLines: 3, 
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            labelText:translate("message"),
            onChanged: (value) {
              if (value.trim().isEmpty) {
                messageController.clear();
              } else {
                messageController.value.copyWith(text: value);
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
               data = "mailto:${emailAddressController.text}?subject=${subjectController.text}&body=${messageController.text}";
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