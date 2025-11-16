import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/components/text_form_phone_number.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';

class FormContemTypeSms extends StatefulWidget {
  const FormContemTypeSms({super.key});

  @override
  State<FormContemTypeSms> createState() => _FormContemTypeSmsState();
}

class _FormContemTypeSmsState extends State<FormContemTypeSms> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: MediaQuery.of(context).size.height * 0.03,
        children: [
// PHONE NUMBER
          textFormPhoneNumber(
            context, 
            textFieldController:phoneNumber,
            requiredField: false,
            onInputChanged:(PhoneNumber number) {},
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
               data = "SMSTO:${phoneNumber.text}:${messageController.text}";
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