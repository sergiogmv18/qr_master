import 'package:floor/floor.dart';
@entity
abstract class ModelBase{
  
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int serverId;
  final String? uuid;
  final bool needToSynchronize;
  ModelBase({required this.serverId, this.uuid, this.id, this.needToSynchronize = true});

  // GETs
  int? getId(){
    return id;
  }
  int? getServerId(){
    return serverId;
  }
  String? getUUID(){
    return uuid;
  }

  bool getNeedToSynchronize(){
    return needToSynchronize;
  }


  // SETs
  void setid(int? id){
    id = id;
  }
  void setServerId(int? serverId){
    serverId = serverId;
  }

  void setUUID(String? uuid){
    uuid = uuid;
  }

  void setNeedToSynchronize(bool? needToSynchronize){
    needToSynchronize = needToSynchronize;
  }
}