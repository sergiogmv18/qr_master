import 'package:flutter/material.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/confirmation_dialog.dart';
import 'package:qr_master/components/success_dialog.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/controllers/qr_record_controller.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/qr_record.dart';

showConfirmDeleteQrRecord({required BuildContext context, required QrRecord qrRecord})async {
  return showConformationDeleteDialog(
    context:context,
    title: translate("remove qr"),
    subtitle:translate("if you're sure you want to delete it, you won't be able to get it back."),
    titleButton:translate("yes, Remove"),
    onPressedTitleButton:()async {
      showCircularLoadingDialog(context);
      await QrRecordController().deleteQRCreated(qrRecordWk:qrRecord);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      showMessageForUser(context, routeName: RouteAppName.homeScreen);
    },
    onPressedSubtitleButton: () {
      Navigator.of(context).pop();
    },
  );
}