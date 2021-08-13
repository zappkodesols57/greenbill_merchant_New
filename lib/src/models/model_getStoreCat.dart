// To parse this JSON data, do

import 'dart:convert';

GetStoreCat getStoreCatFromJson(String str) => GetStoreCat.fromJson(json.decode(str));

String getStoreCatToJson(GetStoreCat data) => json.encode(data.toJson());

class GetStoreCat {
  GetStoreCat({
    this.status,
    this.data,
  });

  String status;
  List<Datus> data;

  factory GetStoreCat.fromJson(Map<String, dynamic> json) => GetStoreCat(
    status: json["status"],
    data: List<Datus>.from(json["data"].map((x) => Datus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datus {
  Datus({
    this.business,
    this.id,

  });

  int id;
  String business;

  factory Datus.fromJson(Map<String, dynamic> json) => Datus(

    business:json["business_name"],
    id:json["id"],

  );

  Map<String, dynamic> toJson() => {
    "business_name":business,
    "id":id,
  };
}
