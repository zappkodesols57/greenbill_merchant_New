// To parse this JSON data, do
//
//     final paymentHistory = paymentHistoryFromJson(jsonString);

import 'dart:convert';

import 'package:greenbill_merchant/src/ui/drawer/ReceivedPayments/receivedPayments.dart';

ReceivedPayments receivedPaymentsFromJson(String str) => ReceivedPayments.fromJson(json.decode(str));

String receivedPaymentsToJson(ReceivedPayments data) => json.encode(data.toJson());

class ReceivedPayments {
  ReceivedPayments({
    this.status,
    this.data,
    this.totalPaymentReceived,
    this.totalPaymentReceivedCount,
  });

  String status;
  List<Datum> data;
  double totalPaymentReceived;
  int totalPaymentReceivedCount;

  factory ReceivedPayments.fromJson(Map<String, dynamic> json) => ReceivedPayments(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    totalPaymentReceived: json["total_payment_received"],
    totalPaymentReceivedCount: json["total_payments_received_count"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total_payment_received": totalPaymentReceived,
    "total_payments_received_count": totalPaymentReceivedCount,
  };
}

class Datum {
  Datum({
    this.mobile,
    this.amount,
    this.transactionId,
    this.createdAt,
    this.paymentDate,
  });

  String mobile;
  String amount;
  String paymentDate;
  String transactionId;
  String createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    mobile: json["mobile_no"],
    transactionId: json["transaction_id"],
    createdAt: json["created_at"],
    paymentDate: json["payment_date_new"],
    amount: json["amount"] == null ? null : json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "mobile_no": mobile,
    "amount": amount == null ? null : amount,
    "payment_date_new": paymentDate,
    "transaction_id": transactionId,
    "created_at": createdAt,
  };
}
