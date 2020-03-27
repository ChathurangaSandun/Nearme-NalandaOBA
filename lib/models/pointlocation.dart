import 'package:flutter/foundation.dart';
import 'package:nearmenalandaoba/models/person.dart';

class PointLocation {
  double latitude;
  double longtitude;
  String type;
  String address;

  PointLocation({this.latitude, this.longtitude, this.type});

  PointLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longtitude = json['longtitude'];
    type = json['type'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['type'] = this.type;
    data['address'] = this.address;
    return data;
  }
}

class Result {
  Data data;

  Result({this.data});

  Result.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Person> nearestLocations;

  Data({this.nearestLocations});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['nearestLocations'] != null) {
      nearestLocations = new List<Person>();
      json['nearestLocations'].forEach((v) {
        nearestLocations.add(new Person.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nearestLocations != null) {
      data['nearestLocations'] =
          this.nearestLocations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
