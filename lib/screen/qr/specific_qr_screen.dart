import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_master/components/app_bar.dart';
import 'package:qr_master/components/botton_navigator_bar.dart';
import 'package:qr_master/components/name_app_bar.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/services/function_class.dart';

class SpecificQrScreen extends StatefulWidget {
  final QrRecord qrRecord;
  const SpecificQrScreen({super.key, required this.qrRecord});

  @override
  State<SpecificQrScreen> createState() => _SpecificQrScreenState();
}

class _SpecificQrScreenState extends State<SpecificQrScreen> {
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
          title: NameScreens(name: "${translate("specific QR")} - ${widget.qrRecord.id ?? 0}"),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: const BottonNavigatorBarCustom(redirectToHome: true),
        body:SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              if(widget.qrRecord.imagePath != null)...[
                Image.file(File(widget.qrRecord.imagePath!))
              ],
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child:Text(
                  translate("data"),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: CustomColors.white),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child:Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: SelectableText(
                        widget.qrRecord.content ?? "", 
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FunctionsClass().copy(context: context, raw:widget.qrRecord.content ?? "");
                        snackBarCustom(context, subtitle: translate("QR code value copied successfully"));
                      },
                      child:Icon(
                        Icons.copy,
                        color: CustomColors.warning,
                        size: Theme.of(context).textTheme.titleLarge!.fontSize,
                      ),
                    ),
                  ],
                )
              ),
              

            ]
          )
        ),
      )
    );
  }
}