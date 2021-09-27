// To parse this JSON data, do
//
//     final subscriptionHistory = subscriptionHistoryFromJson(jsonString);

import 'dart:convert';

SubscriptionHistory subscriptionHistoryFromJson(String str) => SubscriptionHistory.fromJson(json.decode(str));

String subscriptionHistoryToJson(SubscriptionHistory data) => json.encode(data.toJson());

class SubscriptionHistory {
  SubscriptionHistory({
    this.status,
    this.result,
  });

  String status;
  List<Datum> result;

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) => SubscriptionHistory(
    status: json["status"],
    result: List<Datum>.from(json["result"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.billId,
    this.date,
    this.subType,
    this.mode,
    this.modeId,
    this.transactionId,
    this.amount,
    this.business,
    this.url,
  });

  int billId;
  String date;
  String subType;
  String mode;
  String modeId;
  String transactionId;
  String amount;
  String business;
  String url;


  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    billId: json["bill_id"],
    date: json["date"],
    subType: json["subscription_type"],
    mode: json["recharge_mode"],
    modeId: json["recharge_mode_id"],
    transactionId: json["transaction_id"],
    amount: json["amount"],
    business: json["business"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "bill_id": billId,
    "date": date,
    "subscription_type": subType,
    "recharge_mode": mode,
    "recharge_mode_id": modeId,
    "transaction_id": transactionId,
    "amount": amount,
    "business": business,
    "url": url,

  };
}
