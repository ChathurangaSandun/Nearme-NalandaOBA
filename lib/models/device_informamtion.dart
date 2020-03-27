import 'package:flutter/foundation.dart';

class DeviceInfromation {
  String osModel;
  String model;
  String uuid;
  String osVersion;

  DeviceInfromation({this.osModel, this.model, this.uuid, this.osVersion});

  factory DeviceInfromation.fromJson(Map<String, dynamic> json) {
    return DeviceInfromation(
      osModel: json['osModel'],
      model: json['model'],
      uuid: json['uuid'],
      osVersion: json['osVersion']
    );
  
  Map<String, dynamic> toJson(DeviceInfromation model) =>{
    'osModel' : model.osModel,
    'model' : model.model,
    'uuid' : model.uuid,
    'osVersion' : model.osVersion
  };

  }

}