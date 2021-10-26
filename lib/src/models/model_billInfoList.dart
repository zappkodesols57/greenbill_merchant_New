// To parse this JSON data, do
//
//     final billInfoModel = billInfoModelFromJson(jsonString);

import 'dart:convert';

BillInfoModel billInfoModelFromJson(String str) => BillInfoModel.fromJson(json.decode(str));

String billInfoModelToJson(BillInfoModel data) => json.encode(data.toJson());

class BillInfoModel {
  BillInfoModel({
    this.status,
    this.allBills,
  });

  String status;
  List<AllBill> allBills;

  factory BillInfoModel.fromJson(Map<String, dynamic> json) => BillInfoModel(
    status: json["status"],
    allBills: List<AllBill>.from(json["all_bills"].map((x) => AllBill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "all_bills": List<dynamic>.from(allBills.map((x) => x.toJson())),
  };
}

class AllBill {
  AllBill({
    this.billId,
    this.invoiceNo,
    this.mobileNo,
    this.amount,
    this.billDate,
    this.billFile,
    this.dbTable,
    this.customerAdded,
    this.time,
  });

  int billId;
  String invoiceNo;
  String mobileNo;
  String amount;
  String billDate;
  String billFile;
  String dbTable;
  String time;
  bool customerAdded;

  factory AllBill.fromJson(Map<String, dynamic> json) => AllBill(
    billId: json["bill_id"],
    invoiceNo: json["invoice_no"],
    mobileNo: json["mobile_no"],
    amount: json["amount"],
    billDate: json["bill_date"],
    billFile: json["bill_file"],
    dbTable: json["db_table"],
    customerAdded: json["customer_added"],
    time: json["created_at"],
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
    "created_at": time,
  };
}
