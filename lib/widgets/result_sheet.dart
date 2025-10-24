import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/components/button_custom.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:qr_master/widgets/show_result_barcode.dart';

class ResultSheet extends StatelessWidget {
  final String value;
  final VoidCallback onDismiss;
  final Barcode barcode;
  const ResultSheet({super.key, required this.value, required this.barcode, required this.onDismiss});

  bool get _isUrl => Uri.tryParse(value)?.hasScheme ?? false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4, 
            width: 44, 
            decoration: BoxDecoration(
              color: CustomColors.primary, 
              borderRadius: BorderRadius.circular(99)
            )
          ),
          const SizedBox(height: 16),
          Text(translate("code detected"), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primaryDark)),
          const SizedBox(height: 8),
          showResultBarcodeScreen( context: context, barcode: barcode, raw: value),
          
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: GestureDetector(
                  child:PlanBadgeCard(
                    backgroundColor:CustomColors.white,
                    borderGradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [CustomColors.secundary, CustomColors.primary], // aqua → violeta
                    ),
                    child: Text(
                      translate("return to the beginning"), 
                      style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.primaryDark),
                      textAlign: TextAlign.center,
                    )
                  ),
                  onTap: () async{
                    Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.homeScreen,(route) => false);
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: GestureDetector(
                  child:PlanBadgeCard(
                    borderGradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [CustomColors.secundary, CustomColors.primary], // aqua → violeta
                    ),
                    child: Text(
                      translate("continue scanning"), 
                      style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                      textAlign: TextAlign.center,
                    )
                  ),
                  onTap: () async{
                    Navigator.pop(context);
                    onDismiss();
                  },
                ),
              ),
               
            
              // Expanded(
              //   child: FilledButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //       onDismiss();
              //     },
              //     child:Text(translate("continue scanning")),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}