// To parse this JSON data, do
//
//     final cInfo = cInfoFromJson(jsonString);

import 'dart:convert';

CInfo cInfoFromJson(String str) => CInfo.fromJson(json.decode(str));

String cInfoToJson(CInfo data) => json.encode(data.toJson());

class CInfo {
  CInfo({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory CInfo.fromJson(Map<String, dynamic> json) => CInfo(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.mobileNo,
    this.name,
    this.email,
    this.state,
    this.city,
  });

  String mobileNo;
  String name;
  String email;
  String state;
  String city;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    mobileNo: (json["mobile_no"].toString().isEmpty) ? "" : json["mobile_no"],
    name: (json["name"].toString().isEmpty) ? "" : json["name"],
    email: (json["email"].toString().isEmpty) ? "" : json["email"],
    state: (json["state"].toString().isEmpty) ? "" : json["state"],
    city: (json["city"].toString().isEmpty) ? "" : json["city"],
  );

  Map<String, dynamic> toJson() => {
    "mobile_no": mobileNo,
    "name": name,
    "email": email,
    "state": state,
    "city": city,
  };
}
