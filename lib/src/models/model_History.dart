// To parse this JSON data, do
//
//     final paymentHistory = paymentHistoryFromJson(jsonString);

import 'dart:convert';

PaymentHistory paymentHistoryFromJson(String str) => PaymentHistory.fromJson(json.decode(str));

String paymentHistoryToJson(PaymentHistory data) => json.encode(data.toJson());

class PaymentHistory {
  PaymentHistory({
    this.status,
    this.data,
    this.totalAmountSpent,
    this.totalTransactionCount,
  });

  String status;
  List<Datum> data;
  String totalAmountSpent;
  int totalTransactionCount;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    totalAmountSpent: json["total_amount_spent"],
    totalTransactionCount: json["total_transaction_count"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total_amount_spent": totalAmountSpent,
    "total_transaction_count": totalTransactionCount,
  };
}

class Datum {
  Datum({
    this.id,
    this.business,
    this.cost,
    this.transactionId,
    this.mode,
    this.billUrl,
    this.description,
    this.purchaseDate,
  });

  int id;
  double cost;
  String business;
  String description;
  String purchaseDate;
  String transactionId;
  String mode;
  String billUrl;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    business: json["business"],
    description: json["description"],
    transactionId: json["transaction_id"],
    mode: json["mode"],
    purchaseDate: json["purchase_date"],
    cost: json["cost"] == null ? null : json["cost"],
    billUrl: json["bill_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cost": cost == null ? null : cost,
    "business": business,
    "description": description,
    "purchase_date": purchaseDate,
    "transaction_id": transactionId,
    "mode": mode,
    "bill_url": billUrl,
  };
}
