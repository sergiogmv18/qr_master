import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/barcode_spec.dart';
import 'package:qr_master/models/content_type.dart';
import 'package:qr_master/screen/qr/component/form_qr.dart';
import 'package:qr_master/services/function_class.dart';

class QrCreateProvider with ChangeNotifier {
  QrEyeShape styleQrEyeShape = QrEyeShape.square;
  File? logo;
  Color colorQrEyeShape = CustomColors.primary;
  Color backgroundColor = CustomColors.white;
  QrDataModuleShape styleQrDataModuleShape = QrDataModuleShape.square;
  List<Map<String, dynamic>> alltypeSupportedWifi = [
    {
      "name": "WPA/WPA2/WPA3",
      "value": "WPA/WPA2/WPA3",
    },
    {
      "name": "WEP",
      "value": "WEP",
    },
    {
      "name": "-",
      "value": "-",
    } 
  ];
  Color colorQrDataModuleShape = CustomColors.dark;
  List<Map<String, dynamic>> allSupportedQrEyeShapeFormat = [
    {
      "name": translate("cirlce"),
      "value":  QrEyeShape.circle,
    },
    {
      "name": translate("square"),
      "value": QrEyeShape.square,
    } 
  ];
   List<Map<String, dynamic>> allSupportedQrDataModuleShapeFormat = [
    {
      "name": translate("cirlce"),
      "value":  QrDataModuleShape.circle,
    },
    {
      "name": translate("square"),
      "value": QrDataModuleShape.square,
    } 
  ];
  String typeSupportedWifi = "WPA/WPA2/WPA3";

  alltypeSupportedContentWifi(){
    List<DropdownMenuEntry<String>> entriesDropdownMenu = [];
    for(final type in alltypeSupportedWifi){
      entriesDropdownMenu.add(
        DropdownMenuEntry<String>(
        value: type["value"],
        label: type["name"],
        // color de cada ítem (opcional)
        style: const ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(CustomColors.white),
          textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
        ),
        leadingIcon:Icon(Icons.wifi, color: Color(0xFF9BB3C4)),
      ));
    }
    return entriesDropdownMenu;
  }


  /*
  * Generates dropdown menu entries for all supported QR eye shapes
  * Creates a localized list of available eye shape options with consistent styling
  * @return List<DropdownMenuEntry<QrEyeShape>> - Formatted dropdown entries
 */
  allSupportedQrEyeShape(){
    List<DropdownMenuEntry<QrEyeShape>> entriesDropdownMenu = [];
    
    for(final type in allSupportedQrEyeShapeFormat){
      entriesDropdownMenu.add(
        DropdownMenuEntry<QrEyeShape>(
        value: type["value"],
        label: type["name"],
        // color de cada ítem (opcional)
        style: const ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(CustomColors.white),
          textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
        ),
        leadingIcon:Icon(type["value"] == QrEyeShape.square ? Icons.square :Icons.circle, color: Color(0xFF9BB3C4)),
      ));
    }
    return entriesDropdownMenu;
  }

  allSupportedQrDataModuleShape(){
     List<DropdownMenuEntry<QrDataModuleShape>> entriesDropdownMenu = [];
    for(final type in allSupportedQrDataModuleShapeFormat){
      entriesDropdownMenu.add(
        DropdownMenuEntry<QrDataModuleShape>(
        value: type["value"],
        label: type["name"],
        // color de cada ítem (opcional)
        style: const ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(CustomColors.white),
          textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
        ),
        leadingIcon:Icon(type["value"] == QrDataModuleShape.square ? Icons.square :Icons.circle, color: Color(0xFF9BB3C4)),
      ));
    }
    return entriesDropdownMenu;
  }

  updateSupportedQrDataModuleShape(QrDataModuleShape value){
    styleQrDataModuleShape = value;
    notifyListeners();
  }

  /*
  * Updates the selected QR eye shape and triggers UI refresh
  * @param   value - New eye shape style to apply
  * @return  void
  */
  updateSelectstyleQrEyeShape(QrEyeShape value){
    styleQrEyeShape = value;
    notifyListeners();
  }

  updateColorQrEyeShape(Color value){
    colorQrEyeShape = value;
    notifyListeners();
  }

  updateBackgroundColor(Color value){
    backgroundColor = value;
    notifyListeners();
  }

  updateColorQrDataModuleShape(Color value){
    colorQrDataModuleShape = value;
    notifyListeners();
  }

  updateLogo(File value){
    logo = value;
    notifyListeners();
  }

  updateTypeSupportWifi(String value){
    typeSupportedWifi = value;
    notifyListeners();
  }





  /*
  * Provider for managing barcode specification dropdown menus state and logic
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @param   entriesDropdownMenu - List of dropdown entries for barcode types
  * @param   showSecundaryDropdownMenu - Controls visibility of secondary dropdown
  * @param   selectedDropdownItem - Currently selected barcode specification
  */
    /*
    * List of dropdown menu entries generated from available barcode types
    * Each entry includes label, styling and icon configuration
    * @return List<DropdownMenuEntry<BarcodeSpec>>
  */
  List<DropdownMenuEntry<BarcodeSpec>> entriesDropdownMenu = BarcodeSpec.kBarcodeTypes.map((e) {
    return DropdownMenuEntry<BarcodeSpec>(
      value: e,
      label: e.label,
      // color de cada ítem (opcional)
      style: const ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(CustomColors.white),
        textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
      ),
      leadingIcon: const Icon(Icons.qr_code, color: Color(0xFF9BB3C4)),
    );
  }).toList();


  List<DropdownMenuEntry<ContentTypeModel>> entriesSecundaryDropdownMenu = [];

  

  /*
  * Flag to determine if secondary dropdown menu should be displayed
  * Activated based on selected barcode type
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @return bool
  */
  bool showSecundaryDropdownMenu = false;

 /*
  * Currently selected item in the barcode specification dropdown
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * Defaults to first available barcode type
  * @return BarcodeSpec
  */
  BarcodeSpec selectedDropdownItem = BarcodeSpec.kBarcodeTypes.first;

  ContentTypeModel selectedDropdownItemSecundary = ContentTypeModel.getAllContentType()[0];

  /*
  * Updates the selected dropdown item and triggers UI update
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * Also verifies if secondary dropdown should be shown
  * @param   value - New barcode specification to select
  * @return  void
  */
  updateSelectDropdownItem(BarcodeSpec value){
    selectedDropdownItem = value;
    notifyListeners();
    verifySelectedBarcodeSpec();
  }

   updateSelectDropdownItemSecundary(ContentTypeModel value){
    selectedDropdownItemSecundary = value;
    notifyListeners();
  }



 /*
  * Verifies if the selected barcode spec requires showing secondary dropdown
  * Compares against predefined list of barcode types that need secondary selection
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @return  void
  */
  verifySelectedBarcodeSpec(){
    if(selectedDropdownItem.contentTypes.isNotEmpty){
      entriesSecundaryDropdownMenu = selectedDropdownItem.contentTypes.map((e) {
        return DropdownMenuEntry<ContentTypeModel>(
          value: e,
          label: e.label!,
          // color de cada ítem (opcional)
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(CustomColors.white),
            textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
          ),
          leadingIcon: const Icon(Icons.qr_code, color: Color(0xFF9BB3C4)),
        );
      }).toList();
      showSecundaryDropdownMenu = true;
    }else{
      entriesSecundaryDropdownMenu.clear();
      showSecundaryDropdownMenu = false;
    }
    notifyListeners();
  }

  

  showFormSelected(){
    FunctionsClass.debugDumpAndDie(selectedDropdownItem);
    switch(selectedDropdownItem){
      case BarcodeSpec(label:"QR Code"): 
      return FormQrCreate(contentTypeModel:selectedDropdownItemSecundary);
    }

    // if(showSecundaryDropdownMenu){
    //   FunctionsClass.debugDumpAndDie(selectedDropdownItem);
    //   switch(selectedDropdownItemSecundary){

    //   }
    // }
   // return FormAztec();
  }

}