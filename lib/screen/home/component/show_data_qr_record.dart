import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/models/qr_record.dart';

class ShowDataQrRecord extends StatelessWidget {
  final QrRecord qrRecord;
  const ShowDataQrRecord({super.key, required this.qrRecord});

  @override
  Widget build(BuildContext context) {
    return  Dismissible(
        key:Key(qrRecord.id.toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
         // showConfirmDeleteClient(context: context, client:client);
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
        child:ListTile(
           // leading:leading,
            contentPadding: EdgeInsets.zero,
            // title:currentChildren != null ? Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisSize: MainAxisSize.min,
            //   children: currentChildren!
            // ): title, 
            subtitle:Text("sa"),
            trailing: Icon(
                Icons.keyboard_arrow_right,
                color: CustomColors.secundaryColor,
                size: 24,
              ),
          ),
      );
    }
}