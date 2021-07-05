// To parse this JSON data, do
//
//     final rejected = rejectedFromJson(jsonString);

import 'dart:convert';

Rejected rejectedFromJson(String str) => Rejected.fromJson(json.decode(str));

String rejectedToJson(Rejected data) => json.encode(data.toJson());

class Rejected {
  Rejected({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory Rejected.fromJson(Map<String, dynamic> json) => Rejected(
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
    this.mobileNo,
    this.amount,
    this.billDate,
    this.billFile,
    this.dbTable,
    this.customerAdded,
    this.rejectStatus,
  });

  int billId;
  String invoiceNo;
  String mobileNo;
  String amount;
  String billDate;
  String billFile;
  String dbTable;
  bool customerAdded;
  bool rejectStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    billId: json["bill_id"],
    invoiceNo: json["invoice_no"],
    mobileNo: json["mobile_no"],
    amount: json["amount"],
    billDate: json["bill_date"],
    billFile: json["bill_file"],
    dbTable: json["db_table"],
    customerAdded: json["customer_added"],
    rejectStatus: json["reject_status"],
  );

  Map<String, dynamic> toJson() => {
    "bill_id": billId,
    "invoice_no": invoiceNo,
    "mobile_no": mobileNo,
    "amount": amount,
    "bill_date": billDate,
    "bill_file": billFile,
    "db_table": dbTable,
    "customer_added": customerAdded,
    "reject_status": rejectStatus,
  };
}
