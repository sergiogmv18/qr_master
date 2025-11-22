import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/app_bar.dart';
import 'package:qr_master/components/botton_navigator_bar.dart';
import 'package:qr_master/components/name_app_bar.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/botton_navigator_bar_provider.dart';
import 'package:qr_master/screen/home/config_screen.dart';
import 'package:qr_master/screen/home/dashboard_screen.dart';
import 'package:qr_master/screen/home/history_screen.dart';
import 'package:qr_master/screen/qr/create_qr_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Consumer<BottonNavigationBarProvider>(
      builder: (context, provider, child){
        return  popScopeCustom(
          canPop: false,
          child: Scaffold(
            backgroundColor: CustomColors.primaryDark,
            appBar: appBarCustom(
              context,
              title: NameScreens(name:showName(index:provider.currentIndexPage)),
            ),
            floatingActionButtonAnimator:FloatingActionButtonAnimator.scaling ,
            bottomNavigationBar: BottonNavigatorBarCustom(),
            body:showBody(index:provider.currentIndexPage), 
          ),
        );
      }
    );
  }


  showName({required int index}){
    switch(index){
      case 0: 
      return translate("home");
      case 1: 
      return translate("create");
      case 2: 
      return translate("history");
      case 3: 
      return translate("config");

    }
    
  }

  showBody({required int index}){
    switch(index){
      case 0: 
      return DashboardScreen();
      case 1: 
      return CreateQrScreen();
      case 2: 
      return HistoryScreen();
      case 3: 
        return ConfigScreen();
    }
    
  }
}
