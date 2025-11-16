import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/app_dropdown.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/qr_create_provider.dart';

class FormContentTypeWifi extends StatefulWidget {
  const FormContentTypeWifi({super.key});

  @override
  State<FormContentTypeWifi> createState() => _FormContentTypeWifiState();
}

class _FormContentTypeWifiState extends State<FormContentTypeWifi> {
  final formKey = GlobalKey<FormState>();
  TextEditingController networkName = TextEditingController();
  TextEditingController password = TextEditingController();
  
  

  @override
  void initState() {
    
    super.initState();
     
  }
    
  @override
  Widget build(BuildContext context) {
    return Consumer<QrCreateProvider>(
      builder: (context, provider, child){
        return Form(
          key: formKey,
          child: Column(
            spacing: MediaQuery.of(context).size.height * 0.03,
            children: [
    // NETWORK NAME
              TextFormFieldCustom(
                controller: networkName,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                labelText:translate("network name"),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return translate("please enter a valid value");
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    networkName.clear();
                  } else {
                    networkName.value.copyWith(text: value);
                  }
                },
              ),
    //PASSOWRD
              if(provider.typeSupportedWifi != "-")...[
                TextFormFieldCustom(
                  controller: password,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  labelText:translate("password"),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return translate("please enter a valid value");
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      password.clear();
                    } else {
                      password.value.copyWith(text: value);
                    }
                  },
                ),
              ],
           
              AppDropdown<String>(
                label: translate("type"),
                leadingIcon:  const Icon(Icons.wifi, color: CustomColors.primary),
                items:provider.alltypeSupportedContentWifi(),
                value: provider.typeSupportedWifi,
                onChanged: (val) {
                  if (val == null) return;
                  provider.updateTypeSupportWifi(val);
                },
                width: MediaQuery.of(context).size.width - 32, // full-width con margen
                enableFilter: false,
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
                  switch(provider.typeSupportedWifi){
                    case "WPA/WPA2/WPA3":
                      if(password.text.length < 8){
                        return snackBarCustom(context, subtitle: translate('the WPA/WPA2/WPA3 encryption method requires a password with at least 8 characters.'), type:"error");
                      }
                      data ="WIFI:S:${networkName.text};T:WAP;P:${password.text};;";
                    break;
                    case "WEP":
                      data = "WIFI:S:${networkName.text};T:WEP;P:${password.text};;";
                    break;
                    case "-":
                      data = "WIFI:S:${networkName.text};T:nopass;P:;;";
                    break;
                  }
                  showCircularLoadingDialog(context);
                  FocusScope.of(context).unfocus();
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
    );
  }
}