import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/models/qr_record.dart';
import 'package:qr_master/screen/qr/component/show_confirm_delete_qr.dart';
import 'package:qr_master/services/function_class.dart';

class ShowDataQrRecord extends StatelessWidget {
  final QrRecord qrRecord;
  const ShowDataQrRecord({super.key, required this.qrRecord});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:Key(qrRecord.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
           showConfirmDeleteQrRecord(context: context, qrRecord:qrRecord);
        }
        return false;
      },  
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(LineAwesomeIcons.trash_solid, color: Colors.white),
      ),
      child:Card(
        elevation: 3,
        color: const Color.fromARGB(143, 7, 89, 140),
        child: Container(
          padding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            onTap:(){
                FunctionsClass.debugDumpAndDie(qrRecord.toString());
            },
            leading: Icon(
              qrRecord.getIconToType(),
                color: CustomColors.white,
                size:Theme.of(context).textTheme.headlineMedium!.fontSize,
              ), 
            contentPadding: EdgeInsets.zero,
            title:Text(
              qrRecord.content??"",
              overflow: TextOverflow.ellipsis,
              style:Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
              maxLines: 3,
            ),
            subtitle:Text(
              qrRecord.createdAt != null ? FunctionsClass().formatDateAuto(context,qrRecord.createdAt!) : "",
              style:Theme.of(context).textTheme.bodySmall!.copyWith(color: CustomColors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: CustomColors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}