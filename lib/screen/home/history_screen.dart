import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/provider/botton_navigator_bar_provider.dart';
import 'package:qr_master/provider/provider_history.dart';
import 'package:qr_master/screen/ads_mod/banner_ad.dart';
import 'package:qr_master/screen/qr/component/show_data_qr_record.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with TickerProviderStateMixin  {

   late Future<List<QrRecord?>> getAllQRRecord;

  @override
  void initState() {
    super.initState();
     getAllQRRecord = QrRecord.getAll();
     
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderHistory>(
      builder: (context, provider, child){
        return Column(
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constants.borderRadius),
                border: Border.all(color: CustomColors.white, width: 1)
              ),
              child:TabBar(
                unselectedLabelColor: CustomColors.white,
                dividerColor:CustomColors.white,
                automaticIndicatorColorAdjustment: false,
                labelColor: CustomColors.primary,
                labelStyle:Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle:Theme.of(context).textTheme.bodyMedium!.copyWith(
                ),
                indicatorColor:CustomColors.dark,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Constants.borderRadius),
                    topRight:Radius.circular(Constants.borderRadius), 
                    bottomLeft: Radius.circular(Constants.borderRadius), 
                    bottomRight: Radius.circular(Constants.borderRadius), 
                  ),
                  border:Border(
                    left:provider.indexToTab == 1 ? BorderSide(color:CustomColors.white) : BorderSide.none,
                    right: provider.indexToTab != 1 ? BorderSide(color:CustomColors.white) : BorderSide.none,
                  ),
                ),
                controller: TabController(initialIndex:provider.indexToTab, length: 2, vsync: this),
                onTap:(i){
                  provider.updateIndextToTab(i);
                }, // or onTap: null,
                tabs:[
                  Tab(
                    text: translate('created'),
                  ),
                  Tab(
                    text:translate('scanned'), 
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: QrRecord.getAll(type: provider.indexToTab == 0 ? QrRecord.typeCreate : QrRecord.typeScan),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(
                    child: circularProgressIndicator(context),
                  );
                }
                var response = snapshot.data;
                if ((response == null) || snapshot.hasError) {
                  return Container();
                }
                if(response.isEmpty){
                  return showMessageListEmpty(qrRecord:provider.indexToTab == 0 ? QrRecord.typeCreate : QrRecord.typeScan);
                }else{
                  return  Expanded(
                    child:SingleChildScrollView(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
                      child: Column(
                        spacing: 10,
                        children: [
                          for(int current = 0; current < response.length; current++)...[
                            if(response[current] != null)...[
                              ShowDataQrRecord(qrRecord: response[current]!),
                              if(current > 0 && current % 2 == 0)...[
                                AdaptiveBanner(),
                              ]
                            ],
                          ],
                        ],
                      )
                    )
                  );
                }
                
              }
            )
          ]
          
        
        );
      }
    );
  }

  Widget showMessageListEmpty({required int qrRecord}){
    String title = translate("you don’t have any QR codes yet. Tap below to create your first one!");
    String titleButton = translate("create QR");
    VoidCallback onTap = () {
       Provider.of<BottonNavigationBarProvider>(context, listen: false).currentIndexPage = 1;
       Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.homeScreen,(route) => false);
     };
    switch(qrRecord){
      case QrRecord.typeScan:
      title = translate("no scans yet. Point your camera at a QR code to get started!");
      titleButton = translate("scan QR");
      onTap = () {
       Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.scanScreen,(route) => false);
     };
    }
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 40),
          Text(
            title, 
            style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          PlanBadgeCard(
            borderGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomColors.primary, CustomColors.primary], // aqua → violeta
            ),
            onTap: onTap,
            child:Text(
              titleButton, 
              style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
              textAlign: TextAlign.center,
            )
          ),
        ],
      )
    );
  }
}