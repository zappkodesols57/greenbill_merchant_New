// To parse this JSON data, do
//
//     final subscriptionBulkSms = subscriptionBulkSmsFromJson(jsonString);

import 'dart:convert';

SubscriptionBulkSms subscriptionBulkSmsFromJson(String str) => SubscriptionBulkSms.fromJson(json.decode(str));

String subscriptionBulkSmsToJson(SubscriptionBulkSms data) => json.encode(data.toJson());

class SubscriptionBulkSms {
  SubscriptionBulkSms({
    this.status,
    this.data,
  });

  String status;
  List<Datu> data;

  factory SubscriptionBulkSms.fromJson(Map<String, dynamic> json) => SubscriptionBulkSms(
    status: json["status"],
    data: List<Datu>.from(json["data"].map((x) => Datu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datu {
  Datu({
    this.id,
    this.subscriptionName,
    this.totalSms,
    this.perSmsCost,
    this.totalSmsCost,
    this.discountIn,
    this.discountPercentage,
    this.discountAmount,
    this.createdDate,
    this.isActive,
  });

  int id;
  String subscriptionName;
  String totalSms;
  String perSmsCost;
  String totalSmsCost;
  String discountIn;
  String discountPercentage;
  String discountAmount;
  DateTime createdDate;
  bool isActive;

  factory Datu.fromJson(Map<String, dynamic> json) => Datu(
    id: json["id"],
    subscriptionName: json["subscription_name"],
    totalSms: json["total_sms"],
    perSmsCost: json["per_sms_cost"],
    totalSmsCost: json["total_sms_cost"],
    discountIn: json["discount_in"],
    discountPercentage: json["discount_percentage"],
    discountAmount: json["discount_amount"],
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
    "created_date": createdDate.toIso8601String(),
    "is_active": isActive,
  };
}
