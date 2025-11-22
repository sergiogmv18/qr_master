import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/botton_navigator_bar_provider.dart';
import 'package:qr_master/screen/ads_mod/banner_ad.dart';
import 'package:qr_master/screen/ads_mod/native_ad.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
    // final _manager = AndroidInterstitialManager();
    @override
  void initState() {
    super.initState();
      ///_manager.preload();
     
  }


  @override
  void dispose() {
    //_manager.dispose();
    super.dispose();
  }

  // Future<void> _onAction() async {
  //   final showed = _manager.showIfReady();
  //   if (!showed && mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Interstitial aún no está listo.')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
  // DETAILS OF PLAN         
          // PlanBadgeCard(
          //   title: 'Plan Free',
          //   subtitle: translate('unlimited scans • 5 free creations.'),
          // ),
  // SCAN QR
          PlanBadgeCard(
            onTap: () async{
             // await _onAction();
              //if(!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.scanScreen,(route) => false);
            },
            borderGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomColors.secundary, CustomColors.primary], // aqua → violeta
            ),
            child: Column(
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.white, size: 50,),
                Text(
                  translate('scan QR'),
                  style:Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: CustomColors.white
                  ),
                )
              ],
            ),
          ),     
  // ADS
          AdaptiveBanner(),
  // CREATE QR
            PlanBadgeCard(
              onTap: () {
                Provider.of<BottonNavigationBarProvider>(context, listen: false).currentIndexPage = 1; 
                Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.homeScreen,(route) => false);
              },
            borderGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomColors.secundary, CustomColors.secundary], // aqua → violeta
            ),
            child: Column(
              children: [
                Icon(Icons.qr_code, color: Colors.white, size: 50),
                Text(
                  translate('create QR'),
                  style:Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: CustomColors.white
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          NativeAdCard(height: 300),
        ],
      )  
    );
  }
}