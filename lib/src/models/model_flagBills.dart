// To parse this JSON data, do
//
//     final flagBillsList = flagBillsListFromJson(jsonString);

import 'dart:convert';

FlagBillsList flagBillsListFromJson(String str) => FlagBillsList.fromJson(json.decode(str));

String flagBillsListToJson(FlagBillsList data) => json.encode(data.toJson());

class FlagBillsList {
  FlagBillsList({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory FlagBillsList.fromJson(Map<String, dynamic> json) => FlagBillsList(
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
    this.mobileNo,
    this.invoiceNo,
    this.amount,
    this.createdBy,
    this.createdDate,
    this.flaggedBy,
    this.flaggedDate,
    this.flaggedTime,
    this.flaggedReason,
  });

  int id;
  String mobileNo;
  String invoiceNo;
  String amount;
  String createdBy;
  String createdDate;
  String flaggedBy;
  String flaggedDate;
  String flaggedTime;
  String flaggedReason;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mobileNo: json["mobile_no"],
    invoiceNo: json["invoice_no"],
    amount: json["amount"],
    createdBy: json["created_by"],
    createdDate: json["Created_date"],
    flaggedBy: json["flagged_by"],
    flaggedDate: json["flagged_date"],
    flaggedTime: json["flagged_time"],
    flaggedReason: json["flagged_reason"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile_no": mobileNo,
    "invoice_no": invoiceNo,
    "amount": amount,
    "created_by": createdBy,
    "Created_date": createdDate,
    "flagged_by": flaggedBy,
    "flagged_date": flaggedDate,
    "flagged_time": flaggedTime,
    "flagged_reason": flaggedReason,
  };
}
