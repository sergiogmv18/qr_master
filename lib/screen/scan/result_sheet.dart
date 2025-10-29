import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/app_bar.dart';
import 'package:qr_master/components/botton_navigator_bar.dart';
import 'package:qr_master/components/name_app_bar.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/provider_scanqr.dart';
import 'package:qr_master/screen/ads_mod/native_ad.dart';
import 'package:qr_master/widgets/show_result_barcode.dart';


class ResultScanScreen extends StatefulWidget {
   final String value;
  final VoidCallback onDismiss;
  final Barcode barcode;
  const ResultScanScreen({super.key, required this.value, required this.barcode, required this.onDismiss});

  @override
  State<ResultScanScreen> createState() => _ResultScanScreenState();
}

class _ResultScanScreenState extends State<ResultScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScanQrProvider>(
      builder: (context, provider, child){
        return popScopeCustom(
          canPop: false,
          child: Scaffold(
            backgroundColor: CustomColors.primaryDark,
            appBar: appBarCustom(
              context,
              showButtonReturn: true,
              onTap: () async {
                Navigator.pop(context);
                widget.onDismiss();
              },
              title: NameScreens(name: translate("scanner result")),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            bottomNavigationBar: const BottonNavigatorBarCustom(redirectToHome: true),
            body:SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(translate("code detected"), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white)),
                        const SizedBox(height: 20),
                        showResultBarcodeScreen(context:context, barcode: widget.barcode, raw: widget.value),
                        
                        const SizedBox(height: 20),
                        PlanBadgeCard(
                          borderGradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [CustomColors.secundary, CustomColors.primary], // aqua → violeta
                          ),
                          onTap: () async{
                            Navigator.pop(context);
                            widget.onDismiss();
                          },
                          child:Text(
                            translate("continue scanning"), 
                            style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                            textAlign: TextAlign.center,
                          )
                        ),
                        const SizedBox(height: 20),
                        NativeAdCard(height: 300),
                        SizedBox(height: 24),
                      ],
                    ),
                  )
                ],
              )
            ),
              
          ),
        );
        }
     );
  }
}
