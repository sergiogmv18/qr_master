import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:qr_master/components/app_bar.dart';
import 'package:qr_master/components/botton_navigator_bar.dart';
import 'package:qr_master/components/name_app_bar.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return popScopeCustom(
      canPop: false,
      child: Scaffold(
        backgroundColor: CustomColors.primaryDark,
        appBar: appBarCustom(
          context,
          title: NameScreens(name: translate("home"))
        ),
        floatingActionButtonAnimator:FloatingActionButtonAnimator.scaling ,
        bottomNavigationBar: BottonNavigatorBarCustom(),
        body: SingleChildScrollView(
          padding: EdgeInsets.only( left: 10, right: 10, bottom: 30, top: 30),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              PlanBadgeCard(
                title: 'Plan Free',
                subtitle: translate('unlimited scans • 5 free creations.'),
              ),

              PlanBadgeCard(
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

               PlanBadgeCard(
                borderGradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [CustomColors.secundary, CustomColors.secundary], // aqua → violeta
                ),
                child: Column(
                  children: [
                    Icon(Icons.qr_code, color: Colors.white, size: 50,),
                    Text(
                      translate('create QR'),
                      style:Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: CustomColors.white
                      ),
                    )
                  ],
                ),
              ),

              PlanBadgeCard(
                title: translate('update to Pro'),
                subtitle: translate('faster: Generate and save your QR codes without limits with Pro.'),
              ),

  
            ],
          )  
        ),
      ),
    );
  }
}
