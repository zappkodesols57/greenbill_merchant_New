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
    this.amount,
  });

  String mobileNo;
  String amount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    mobileNo: (json["mobile_no"].toString().isEmpty) ? "--//--" : json["mobile_no"],
    amount: (json["amount"].toString().isEmpty) ? "--//--" : json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "mobile_no": mobileNo,
    "amount": amount,
  };
}
