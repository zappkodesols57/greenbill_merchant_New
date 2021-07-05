// To parse this JSON data, do
//
//     final monthlyParking = monthlyParkingFromJson(jsonString);

import 'dart:convert';

MonthlyParking monthlyParkingFromJson(String str) => MonthlyParking.fromJson(json.decode(str));

String monthlyParkingToJson(MonthlyParking data) => json.encode(data.toJson());

class MonthlyParking {
  MonthlyParking({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory MonthlyParking.fromJson(Map<String, dynamic> json) => MonthlyParking(
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
    this.businessName,
    this.businessLogo,
    this.mobileNo,
    this.amount,
    this.vehicalNo,
    this.validFrom,
    this.validTo,
    this.comments,
    this.createdAt,
    this.passType,
    this.companyId,
    this.companyName,
  });

  int id;
  String businessName;
  String businessLogo;
  String mobileNo;
  String amount;
  String vehicalNo;
  String validFrom;
  String validTo;
  String comments;
  DateTime createdAt;
  String passType;
  String companyId;
  String companyName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    businessName: json["business_name"],
    businessLogo: json["business_logo"],
    mobileNo: json["mobile_no"],
    amount: json["amount"],
    vehicalNo: json["vehical_no"],
    validFrom: json["valid_from"],
    validTo: json["valid_to"],
    comments: json["comments"],
    createdAt: DateTime.parse(json["created_at"]),
    passType: json["pass_type"],
    companyId: json["company_id"],
    companyName: json["company_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_name": businessName,
    "business_logo": businessLogo,
    "mobile_no": mobileNo,
    "amount": amount,
    "vehical_no": vehicalNo,
    "valid_from": validFrom,
    "valid_to": validTo,
    "comments": comments,
    "created_at": createdAt.toIso8601String(),
    "pass_type": passType,
    "company_id": companyId,
    "company_name": companyName,
  };
}
