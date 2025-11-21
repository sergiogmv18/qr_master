

import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/model_base.dart';

enum ContentType {
  website,
  contact,
  text,
  email,
  wifi,
  location,
  event,
  sms,
  unknown,
}

class ContentTypeModel extends ModelBase{
  final String? label; 
  final ContentType? value;
  
  ContentTypeModel({
    required super.serverId,
    super.id,
    super.needToSynchronize,
    super.uuid,
    this.value,
    this.label,
  });
  

  static getAllContentType(){
    List<ContentTypeModel> allTypeOfQR = [
      ContentTypeModel(serverId:3, label:translate("text"), value: ContentType.text),
      ContentTypeModel(serverId:1, label:translate("web"), value: ContentType.website),
      ContentTypeModel(serverId:2, label:translate("contact"), value: ContentType.contact),
      ContentTypeModel(serverId:4, label:translate("email address"), value: ContentType.email),
      ContentTypeModel(serverId:5, label:translate("wifi"), value: ContentType.wifi),
      ContentTypeModel(serverId:6, label:translate("location"), value: ContentType.location),
      ContentTypeModel(serverId:7, label:translate("event"), value: ContentType.event),
      ContentTypeModel(serverId:8, label:translate("SMS"), value: ContentType.sms),
    ];
    return allTypeOfQR;
  }
}