import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/barcode_spec.dart';
import 'package:qr_master/models/content_type.dart';
import 'package:qr_master/provider/qr_create_provider.dart';
import '../../components/app_dropdown.dart';

class CreateQrScreen extends StatefulWidget {
  const CreateQrScreen({super.key});

  @override
  State<CreateQrScreen> createState() => _CreateQrScreenState();
}

class _CreateQrScreenState extends State<CreateQrScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QrCreateProvider>(context, listen: false).verifySelectedBarcodeSpec();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrCreateProvider>(
      builder: (context, provider, child){
        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: AppDropdown<BarcodeSpec>(
                label: translate("code type"),
                leadingIcon:  const Icon(Icons.qr_code_2, color: CustomColors.primary),
                items:provider.entriesDropdownMenu,
                value: provider.selectedDropdownItem,
                onChanged: (val) {
                  if (val == null) return;
                  provider.updateSelectDropdownItem(val);
                },
                //width: MediaQuery.of(context).size.width - 32, // full-width con margen
                enableFilter: false,
              ),
                  
                  ),
                  if(provider.showSecundaryDropdownMenu)...[
                  Expanded(
                    child: AppDropdown<ContentTypeModel>(
                  label: translate("select format") ,
                  leadingIcon:  const Icon(Icons.qr_code_scanner, color: CustomColors.primary),
                  items:provider.entriesSecundaryDropdownMenu,
                  value: provider.selectedDropdownItemSecundary,
                  onChanged: (val) {
                    if (val == null) return;
                    provider.updateSelectDropdownItemSecundary(val);
                  },
                //  width: MediaQuery.of(context).size.width - 32, // full-width con margen
                  enableFilter: false,
                ),
                  ),
                  ]
                ],
              ),
              provider.showFormSelected(),
                      
            ]
          )
        );
      }
    );
  
  }
}

