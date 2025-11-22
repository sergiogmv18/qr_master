import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/qr_create_provider.dart';

class FormContentTypeLocation extends StatefulWidget {
  const FormContentTypeLocation({super.key});

  @override
  State<FormContentTypeLocation> createState() => _FormContentTypeLocationState();
}

class _FormContentTypeLocationState extends State<FormContentTypeLocation> {
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<QrCreateProvider>();
      provider.initUserLocation().then((_) {
        // Actualiza los inputs con la ubicación inicial
        latController.text = provider.latController.toStringAsFixed(7);
        lngController.text = provider.lngController.toStringAsFixed(7);
      });
    });
    });
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
              Row(
                spacing: 10,
                children:[
                  Expanded(
                    child:TextFormFieldCustom(
                      controller: latController,
                      textInputAction: TextInputAction.next,
                      keyboardType:const TextInputType.numberWithOptions(decimal: true),
                      labelText:translate("latitude"),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return translate("please enter a valid value");
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          latController.clear();
                          provider.updateMapLocationLongitude(0);
                        } else {
                          latController.value.copyWith(text: value);
                          provider.updateMapLocationLatitude(double.parse(latController.text));
                        }
                        provider.mapLocationController!.animateCamera(
                          CameraUpdate.newLatLng(provider.posicionLocation),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldCustom(
                      controller: lngController,
                      textInputAction: TextInputAction.next,
                      keyboardType:const TextInputType.numberWithOptions(decimal: true),
                      labelText:translate("longitude"),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return translate("please enter a valid value");
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          lngController.clear();
                          provider.updateMapLocationLongitude(0);
                        } else {
                          lngController.value.copyWith(text: value);
                           provider.updateMapLocationLongitude(double.parse(lngController.text));
                        }
                        provider.mapLocationController!.animateCamera(
                          CameraUpdate.newLatLng(provider.posicionLocation),
                        );
                      },
                    ),
                  ),
                ]
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: provider.posicionLocation,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    provider.updateMapLocationController(controller:controller);
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('posicion'),
                      position: provider.posicionLocation,
                      draggable: true,
                      onDragEnd: (nuevaPosicion) {
                        provider.updateMapLocationLatitude(nuevaPosicion.latitude);
                        provider.updateMapLocationLongitude(nuevaPosicion.longitude);
                        latController.text = provider.latController.toStringAsFixed(7);
                        lngController.text =  provider.lngController.toStringAsFixed(7);
                        provider.mapLocationController!.animateCamera(
                          CameraUpdate.newLatLng(nuevaPosicion),
                        );
                      },
                    ),
                  },
                  onTap: (pos) {
                    provider.updateMapLocationLatitude(pos.latitude);
                    provider.updateMapLocationLongitude(pos.longitude);
                    latController.text = provider.latController.toStringAsFixed(7);
                    lngController.text =  provider.lngController.toStringAsFixed(7);
                    provider.mapLocationController!.animateCamera(
                      CameraUpdate.newLatLng(pos),
                    );
                  },
                ),
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
                    data = "geo:${provider.latController},${provider.lngController}";
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