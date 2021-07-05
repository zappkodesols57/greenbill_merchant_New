// To parse this JSON data, do
//
//     final allQr = allQrFromJson(jsonString);

import 'dart:convert';

AllQr allQrFromJson(String str) => AllQr.fromJson(json.decode(str));

String allQrToJson(AllQr data) => json.encode(data.toJson());

class AllQr {
  AllQr({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory AllQr.fromJson(Map<String, dynamic> json) => AllQr(
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
    this.id,
    this.userId,
    this.mobileNo,
    this.vehicleNo,
    this.vehicleType,
    this.description,
    this.createdAt,
  });

  int id;
  String userId;
  String mobileNo;
  String vehicleNo;
  String vehicleType;
  String description;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    mobileNo: json["mobile_no"],
    vehicleNo: json["vehicle_no"],
    vehicleType: json["vehicle_type"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "mobile_no": mobileNo,
    "vehicle_no": vehicleNo,
    "vehicle_type": vehicleType,
    "description": description,
    "created_at": createdAt.toIso8601String(),
  };
}
