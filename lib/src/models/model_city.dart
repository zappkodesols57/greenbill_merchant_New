// To parse this JSON data, do

import 'dart:convert';

CityM cityMFromJson(String str) => CityM.fromJson(json.decode(str));

String cityMToJson(CityM data) => json.encode(data.toJson());

class CityM {
  CityM({
    this.status,
    this.data,
  });

  String status;
  List<Datuc> data;

  factory CityM.fromJson(Map<String, dynamic> json) => CityM(
    status: json["status"],
    data: List<Datuc>.from(json["data"].map((x) => Datuc.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datuc {
  Datuc({
    this.cCity,

  });

  String cCity;

  factory Datuc.fromJson(Map<String, dynamic> json) => Datuc(

    cCity:json["c_city"],

  );

  Map<String, dynamic> toJson() => {
    "c_city":cCity,
  };
}
