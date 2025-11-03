import 'package:flutter/material.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/models/barcode_spec.dart';
import 'package:qr_master/models/content_type.dart';

class QrCreateProvider with ChangeNotifier {

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

  

}