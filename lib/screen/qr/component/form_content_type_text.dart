import 'package:flutter/material.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';

class FormContentTypeText extends StatefulWidget {
  const FormContentTypeText({super.key});

  @override
  State<FormContentTypeText> createState() => _FormContentTypeTextState();
}

class _FormContentTypeTextState extends State<FormContentTypeText> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: MediaQuery.of(context).size.height * 0.03,
        children: [
          TextFormFieldCustom(
            controller: descriptionController,
            textInputAction: TextInputAction.newline,
            minLines: 3, 
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            labelText:translate("text"),
            onChanged: (value) {
              if (value.trim().isEmpty) {
                descriptionController.clear();
              } else {
                descriptionController.value.copyWith(text: value);
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
                data = descriptionController.text;
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