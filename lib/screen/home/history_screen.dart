import 'package:flutter/material.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/screen/home/component/show_data_qr_record.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
   late Future<List<QrRecord?>> getAllQRRecord;

  @override
  void initState() {
    super.initState();
     getAllQRRecord = QrRecord.getAll();
     
  }
  @override
  Widget build(BuildContext context) {
     return  SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          FutureBuilder(
            future: getAllQRRecord,
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
return Container();
              }else{
                return  Column(
                children: [
                  for(QrRecord? current in response)...[
                    if(current != null)...[
                      ShowDataQrRecord(qrRecord: current)
                    ]
                   
                  ]
                ],
              );
              }
              
            }
          )
        ]
      )
    );
  }
}