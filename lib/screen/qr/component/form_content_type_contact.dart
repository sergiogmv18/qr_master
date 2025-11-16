import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/components/text_form_phone_number.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/services/function_class.dart';

class FormContentTypeContact extends StatefulWidget {
  const FormContentTypeContact({super.key});

  @override
  State<FormContentTypeContact> createState() => _FormContentTypeContactState();
}

class _FormContentTypeContactState extends State<FormContentTypeContact> {
  TextEditingController contactLastNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactEmailAddressController = TextEditingController();
  TextEditingController contactCompanyNameController = TextEditingController();
  TextEditingController contactAddressController = TextEditingController();
  TextEditingController contactCountryController = TextEditingController();
  TextEditingController contactRegionController = TextEditingController();
  TextEditingController contactPostalCodeController = TextEditingController();
  TextEditingController contactCityController = TextEditingController();
  TextEditingController contactURLController = TextEditingController();
  TextEditingController contactPostController = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  
  
  final formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: MediaQuery.of(context).size.height * 0.03,
        children: [
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
// NAME
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child:  TextFormFieldCustom(
                  controller: contactNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("first name"),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return translate("please enter a valid value");
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactNameController.clear();
                    } else {
                      contactNameController.value.copyWith(text: value);
                    }
                  },
                ),
              ),
// LAST NAME
              SizedBox(
                width:MediaQuery.of(context).size.width * 0.45,
                child:TextFormFieldCustom(
                  controller: contactLastNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("last name"),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactNameController.clear();
                    } else {
                      contactNameController.value.copyWith(text: value);
                    }
                  },
                ),
              )
            ],
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
// COMPANY NAME
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormFieldCustom(
                  controller: contactCompanyNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("company name"),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactCompanyNameController.clear();
                    } else {
                      contactCompanyNameController.value.copyWith(text: value);
                    }
                  },
                ),
              ),
// POST
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormFieldCustom(
                  controller: contactPostController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("post"),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactPostController.clear();
                    } else {
                      contactPostController.value.copyWith(text: value);
                    }
                  },
                ),
              )
            ]
          ),
// EMAIL ADDRESS
           TextFormFieldCustom(
            controller: contactEmailAddressController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            labelText: translate("email address"),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return null;
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
                contactEmailAddressController.clear();
              } else {
                contactEmailAddressController.value.copyWith(text: value);
              }
            },
          ), 
// PHONE NUMBER 
          textFormPhoneNumber(
            context, 
            textFieldController:phoneNumber,
            requiredField: false,
            onInputChanged:(PhoneNumber number) {},
          ),
                   
// ADDRESS
          TextFormFieldCustom(
            controller: contactAddressController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            labelText:translate("address"),
            onChanged: (value) {
              if (value.trim().isEmpty) {
                contactAddressController.clear();
              } else {
                contactAddressController.value.copyWith(text: value);
              }
            },
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
// POSTAL CODE
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormFieldCustom(
                  controller: contactPostalCodeController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("postal code"),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactPostalCodeController.clear();
                    } else {
                      contactPostalCodeController.value.copyWith(text: value);
                    }
                  },
                ),
              ),
// CITY
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormFieldCustom(
                  controller: contactCityController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("city"),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactCityController.clear();
                    } else {
                      contactCityController.value.copyWith(text: value);
                    }
                  },
                ),
              )
            ]
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
// REGION 
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormFieldCustom(
                  controller: contactRegionController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("region"),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactRegionController.clear();
                    } else {
                      contactRegionController.value.copyWith(text: value);
                    }
                  },
                ),
              ),
// COUNTRY
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormFieldCustom(
                  controller: contactCountryController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("country"),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      contactCountryController.clear();
                    } else {
                      contactCountryController.value.copyWith(text: value);
                    }
                  },
                ),
              )
            ]
          ),
// URL
          TextFormFieldCustom(
            controller: contactURLController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            labelText:translate("web"),
            onChanged: (value) {
              if (value.trim().isEmpty) {
                contactURLController.clear();
              } else {
                contactURLController.value.copyWith(text: value);
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
                final firstName  = contactNameController.text.trim();
                final lastName   = contactLastNameController.text.trim();
                final company    = contactCompanyNameController.text.trim();
                final address    = contactAddressController.text.trim();
                final city       = contactCityController.text.trim();
                final country    = contactCountryController.text.trim();
                final region     = contactRegionController.text.trim();
                final postalCode = contactPostalCodeController.text.trim();
                final url        = contactURLController.text.trim();
                final phone      = phoneNumber.text.replaceAll(' ', '').trim(); // sin espacios
                final email      = contactEmailAddressController.text.trim();
                final title      = contactPostController.text.trim();
                final buffer = StringBuffer();
                buffer.writeln('BEGIN:VCARD');
                buffer.writeln('VERSION:3.0');
                // Nombre (mejor siempre poner algo aunque sea vacío)
                buffer.writeln('N:$lastName;$firstName');
                buffer.writeln('FN:$firstName $lastName');
                buffer.write(_lineIfNotEmpty('ORG:', company));
                buffer.write(_lineIfNotEmpty('TITLE:', title));
                final fields = [
                  address,
                  city,
                  country,
                  region,
                  postalCode
                ];
                String addressFormat = fields.where((e) => e.toString().trim().isNotEmpty).join(';');
                buffer.write(_lineIfNotEmpty('ADR;CHARSET=UTF-8:;;', addressFormat)); 
                buffer.write(_lineIfNotEmpty('URL:', url));
                buffer.write(_lineIfNotEmpty('TEL:', phone));
                buffer.write(_lineIfNotEmpty('EMAIL:', email));
                buffer.writeln('END:VCARD');
                data = buffer.toString();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.createdQrScreen,(route) => false, arguments: data);
              }
            },
            child:Text(
              translate("create"), 
              style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
              textAlign: TextAlign.center,
            )
          ),
        ]
      )
    );
  }

  String _lineIfNotEmpty(String prefix, String value) {
    value = value.trim();
    return value.isEmpty ? '' : '$prefix$value\n';
  }

}