// To parse this JSON data, do
//
//     final transactionalSms = transactionalSmsFromJson(jsonString);

import 'dart:convert';

TransactionalSms transactionalSmsFromJson(String str) => TransactionalSms.fromJson(json.decode(str));

String transactionalSmsToJson(TransactionalSms data) => json.encode(data.toJson());

class TransactionalSms {
  TransactionalSms({
    this.status,
    this.data,
  });

  String status;
  List<DatuJI> data;

  factory TransactionalSms.fromJson(Map<String, dynamic> json) => TransactionalSms(
    status: json["status"],
    data: List<DatuJI>.from(json["data"].map((x) => DatuJI.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DatuJI {
  DatuJI({
    this.id,
    this.subscriptionName,
    this.totalSms,
    this.perSmsCost,
    this.totalSmsCost,
    this.discountIn,
    this.discountPercentage,
    this.discountAmount,
    this.createdDate,
    this.gstAmt,
    this.totalAmt,
    this.cgst,
    this.igst,
    this.sgst,
    this.isActive,
  });

  int id;
  String subscriptionName;
  String totalSms;
  String perSmsCost;
  double totalSmsCost;
  String discountIn;
  String discountPercentage;
  String discountAmount;
  String totalAmt;
  String gstAmt;
  int sgst;
  int igst;
  int cgst;
  DateTime createdDate;
  bool isActive;

  factory DatuJI.fromJson(Map<String, dynamic> json) => DatuJI(
    id: json["id"],
    subscriptionName: json["subscription_name"],
    totalSms: json["total_sms"],
    perSmsCost: json["per_sms_cost"],
    totalSmsCost: json["total_sms_cost"],
    discountIn: json["discount_in"],
    discountPercentage: json["discount_percentage"],
    discountAmount: json["discount_amount"],
    gstAmt: json["gst_amount"],
    cgst: json["cgst_value"],
    igst: json["igst_value"],
    sgst: json["sgst_value"],
    totalAmt: json["total_amount"],
    createdDate: DateTime.parse(json["created_date"]),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subscription_name": subscriptionName,
    "total_sms": totalSms,
    "per_sms_cost": perSmsCost,
    "total_sms_cost": totalSmsCost,
    "discount_in": discountIn,
    "discount_percentage": discountPercentage,
    "discount_amount": discountAmount,
    "total_amount": totalAmt,
    "gst_amount": gstAmt,
    "sgst_value": sgst,
    "cgst_value": cgst,
    "igst_value": igst,
    "created_date": createdDate.toIso8601String(),
    "is_active": isActive,
  };
}
