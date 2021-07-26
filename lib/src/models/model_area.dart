// To parse this JSON data, do

import 'dart:convert';

AreaM areaMFromJson(String str) => AreaM.fromJson(json.decode(str));

String areaMToJson(AreaM data) => json.encode(data.toJson());

class AreaM {
  AreaM({
    this.status,
    this.data,
  });

  String status;
  List<Datua> data;

  factory AreaM.fromJson(Map<String, dynamic> json) => AreaM(
    status: json["status"],
    data: List<Datua>.from(json["data"].map((x) => Datua.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datua {
  Datua({
    this.cArea,

  });

  String cArea;

  factory Datua.fromJson(Map<String, dynamic> json) => Datua(

    cArea:json["c_area"],

  );

  Map<String, dynamic> toJson() => {
    "c_area":cArea,
  };
}
