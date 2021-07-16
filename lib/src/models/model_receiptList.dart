// To parse this JSON data, do
//
//     final receiptList = receiptListFromJson(jsonString);

import 'dart:convert';

ReceiptList receiptListFromJson(String str) => ReceiptList.fromJson(json.decode(str));

String receiptListToJson(ReceiptList data) => json.encode(data.toJson());

class ReceiptList {
  ReceiptList({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory ReceiptList.fromJson(Map<String, dynamic> json) => ReceiptList(
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
    this.receiptNo,
    this.mobileNumber,
    this.date,
    this.total,
  });

  int id;
  String receiptNo;
  String mobileNumber;
  String date;
  double total;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    receiptNo: json["receipt_no"],
    mobileNumber: json["mobile_number"],
    date: json["date"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "receipt_no": receiptNo,
    "mobile_number": mobileNumber,
    "date": date,
    "total": total,
  };
}
