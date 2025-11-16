import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_master/components/app_bar.dart';
import 'package:qr_master/components/app_dropdown.dart';
import 'package:qr_master/components/botton_navigator_bar.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/name_app_bar.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/qr_record_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/qr_create_provider.dart';
import 'package:qr_master/screen/ads_mod/banner_ad.dart';
import 'package:qr_master/services/function_class.dart';

class CreatedQrScreen extends StatefulWidget {
  final String data;
  const CreatedQrScreen({super.key, required this.data});

  @override
  State<CreatedQrScreen> createState() => _CreatedQrScreenState();
}

class _CreatedQrScreenState extends State<CreatedQrScreen> {
  final qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return popScopeCustom(
      canPop: false,
      child: Scaffold(
        backgroundColor: CustomColors.primaryDark,
        appBar: appBarCustom(
          context,
          showButtonReturn: true,
          onTap: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.homeScreen,(route) => false);
          },
          title: NameScreens(name: translate("created")),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: const BottonNavigatorBarCustom(redirectToHome: true),
        body:Consumer<QrCreateProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child:SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.center,
                          iconColor:CustomColors.primary,
                          collapsedIconColor:CustomColors.primaryDark,
                          title:Text(
                            translate("advanced settings"),
                            style:Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: CustomColors.primary,
                            ),
                            textAlign: TextAlign.left,
                          ), 
                          children: [
                            SizedBox(height: 20),
                            AppDropdown<QrEyeShape>(
                              label: translate("QR dot shape") ,
                              items:provider.allSupportedQrEyeShape(),
                              value: provider.styleQrEyeShape,
                              onChanged: (val) {
                                if (val == null) return;
                                provider.updateSelectstyleQrEyeShape(val);
                              },
                              width: MediaQuery.of(context).size.width - 32, // full-width con margen
                              enableFilter: false,
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: [
    // CHANGE COLOR OF QR EYES SHAPE
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *0.4,
                                  child:PlanBadgeCard(
                                    borderGradient:LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [provider.colorQrEyeShape,  provider.colorQrEyeShape], // aqua → violeta
                                    ),
                                    onTap: ()async{
                                      Color? pickColor = await FunctionsClass().pickColor(context, provider.colorQrEyeShape);
                                      if(pickColor != null){
                                        provider.updateColorQrEyeShape(pickColor);
                                      }
                                      
                                    },
                                    child:Text(
                                      translate("change color QR dot shape"), 
                                      style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ),
                                ),
// CHANGE LOGO
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child:PlanBadgeCard(
                                    borderGradient:LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [CustomColors.primary, CustomColors.primary], // aqua → violeta
                                    ),
                                    onTap: ()async{
                                      Map<String, dynamic>? logo = await FunctionsClass().pickImageAsBase64(context: context);
                                      if(logo != null){
                                        provider.updateLogo(logo["file"]);
                                      }
                                    },
                                    child:Text(
                                      translate("change logo"), 
                                      style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ),
                                ),
                                
                              ]
                            ),
    
                            SizedBox(height: 20),
    // CHANGE BACKGROUND COLOR
                             
// MODULE DATA SHAPE
                            SizedBox(height: 20),
                            AppDropdown<QrDataModuleShape >(
                              label: translate("QR dot shape") ,
                              items:provider.allSupportedQrDataModuleShape(),
                              value: provider.styleQrDataModuleShape,
                              onChanged: (val) {
                                if (val == null) return;
                                provider.updateSupportedQrDataModuleShape(val);
                              },
                              width: MediaQuery.of(context).size.width - 32, // full-width con margen
                              enableFilter: false,
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child:PlanBadgeCard(
                                    borderGradient:LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [provider.colorQrDataModuleShape,  provider.colorQrDataModuleShape], // aqua → violeta
                                    ),
                                    onTap: ()async{
                                      Color? pickColor = await FunctionsClass().pickColor(context, provider.colorQrDataModuleShape);
                                      if(pickColor != null){
                                        provider.updateColorQrDataModuleShape(pickColor);
                                      }
                                    },
                                    child:Text(
                                      translate("change color data module shape"), 
                                      style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ),
                                ),
// CHANGE BACKGROUND COLOR
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child:PlanBadgeCard(
                                    borderGradient:LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [provider.backgroundColor,  provider.backgroundColor], // aqua → violeta
                                    ),
                                    onTap: ()async{
                                      Color? pickColor = await FunctionsClass().pickColor(context, provider.backgroundColor);
                                      if(pickColor != null){
                                        provider.updateBackgroundColor(pickColor);
                                      }
                                    },
                                    child:Text(
                                      translate("change background color"), 
                                      style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ),
                                ),
                                
                              ],
                            ),
                    
                            
                          ]
                        ),
                        SizedBox(height: 20),
                        RepaintBoundary(
                          key: qrKey,
                          child: QrImageView(
                            data: widget.data,
                            version: QrVersions.auto,
                            backgroundColor: provider.backgroundColor,
                            eyeStyle: QrEyeStyle(eyeShape: provider.styleQrEyeShape, color: provider.colorQrEyeShape),
                            dataModuleStyle:QrDataModuleStyle(dataModuleShape:provider.styleQrDataModuleShape, color:provider.colorQrDataModuleShape),
                            size: MediaQuery.of(context).size.width - 32,
                            gapless: false,
                            errorCorrectionLevel: QrErrorCorrectLevel.H, // mejor si agregas logo
                            embeddedImage:provider.logo != null ? FileImage(provider.logo!)    : null, // opcional
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(
                                (MediaQuery.of(context).size.width - 32) * 0.24,  
                                (MediaQuery.of(context).size.width - 32) * 0.24
                              )
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child:PlanBadgeCard(
                                borderGradient:LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                    colors: [CustomColors.success,  CustomColors.success], // aqua → violeta
                                ),
                                onTap: ()async{
                                  showCircularLoadingDialog(context);
                                  await QrRecordController().shareQrPdfFromWidget(qrKey);
                                  await QrRecordController().saveLocaleQRCreated(repaintKey:qrKey, content:widget.data);
                                  if(!context.mounted) return;
                                  Navigator.of(context).pop();
                                },
                                child:Text(
                                  translate("PDF"), 
                                  style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                                  textAlign: TextAlign.center,
                                )
                              ),
                            ),
// CHANGE BACKGROUND COLOR
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child:PlanBadgeCard(
                                borderGradient:LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [CustomColors.success,  CustomColors.success], // aqua → violeta
                                ),
                                onTap: ()async{
                                  showCircularLoadingDialog(context);
                                  await QrRecordController().shareQrPngFromWidget(qrKey);
                                  await QrRecordController().saveLocaleQRCreated(repaintKey:qrKey, content:widget.data);
                                  if(!context.mounted) return;
                                  Navigator.of(context).pop();
                                },
                                child:Text(
                                  translate("PNG"), 
                                  style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                                  textAlign: TextAlign.center,
                                )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                const AdaptiveBanner(),
              ],
            );
          },
        ),
           
      ),
    );
  }
}