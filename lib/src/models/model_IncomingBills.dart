// To parse this JSON data, do
//
//     final incomingBills = incomingBillsFromJson(jsonString);

import 'dart:convert';

IncomingBills incomingBillsFromJson(String str) => IncomingBills.fromJson(json.decode(str));

String incomingBillsToJson(IncomingBills data) => json.encode(data.toJson());

class IncomingBills {
  IncomingBills({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory IncomingBills.fromJson(Map<String, dynamic> json) => IncomingBills(
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
    this.billId,
    this.invoiceNo,
    this.billAmount,
    this.billDate,
    this.businessName,
    this.billUrl,
    this.billImage,
  });

  int billId;
  String invoiceNo;
  String billAmount;
  String billDate;
  String businessName;
  String billUrl;
  String billImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    billId: json["bill_id"],
    invoiceNo: json["invoice_no"],
    billAmount: json["bill_amount"],
    billDate: json["bill_date"],
    businessName: json["business_name"],
    billUrl: json["bill_url"],
    billImage: json["bill_image"],
  );

  Map<String, dynamic> toJson() => {
    "bill_id": billId,
    "invoice_no": invoiceNo,
    "bill_amount": billAmount,
    "bill_date": billDate,
    "business_name": businessName,
    "bill_url": billUrl,
    "bill_image": billImage,
  };
}
