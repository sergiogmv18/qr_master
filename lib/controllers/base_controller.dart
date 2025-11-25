import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/controllers/push_notification_controller.dart';
import 'package:qr_master/services/shared_peferences.dart';
import 'package:path/path.dart' as p;

class BaseController {

  /*
  * Initial setup 
  * @author  SGV
  * @version 1.0 - 20250728 - initial release
  * @return  String
  */
  Future <String> initialSetup()async{
    String url = RouteAppName.homeScreen;
    bool? isLogged = await SharedPreferenceC().verifyInitialConfirmation();
    if(isLogged == null){
      await SharedPreferenceC().createUserLogged();
    }
    await PushNotificationController().initialize(); 
    return url;
  }



  Future<XFile?>getPhotoUser()async{
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1000, maxHeight: 1000);
    return image;
    // if(image != null){
    //   await savePickedImageToAppDir(image);
    // }
  }



  Future<File> savePickedImageToAppDir(XFile xfile) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final ext = p.extension(xfile.path); // .jpg, .png, etc.
    final filename = 'img_${DateTime.now().millisecondsSinceEpoch}$ext';
    final destPath = p.join(docsDir.path, filename);
    await xfile.saveTo(destPath);
    return File(destPath);
  }


  Future<List<File>> loadAllSavedImages() async {
    final dir = await getApplicationDocumentsDirectory();
    final exts = {'.jpg', '.jpeg', '.png', '.webp', '.bmp', '.heic'}; // ajusta si necesitas
    final all = await dir
      .list(recursive: false, followLinks: false)
      .where((e) => e is File)
      .cast<File>()
      .where((f) {
        final name = p.basename(f.path);
        final ext = p.extension(f.path).toLowerCase();
        return name.startsWith('img_') && exts.contains(ext);
      })
      .toList();

  // Ordenar por fecha (desc)
  all.sort((a, b) {
    final aTime = a.lastModifiedSync();
    final bTime = b.lastModifiedSync();
    return bTime.compareTo(aTime);
  });

  return all;
}








}