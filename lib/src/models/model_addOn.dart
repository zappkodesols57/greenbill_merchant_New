// To parse this JSON data, do
//
//     final addon = addonFromJson(jsonString);

import 'dart:convert';

Addon addonFromJson(String str) => Addon.fromJson(json.decode(str));

String addonToJson(Addon data) => json.encode(data.toJson());

class Addon {
  Addon({
    this.status,
    this.data,
  });

  String status;
  List<Datumii> data;

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    status: json["status"],
    data: List<Datumii>.from(json["data"].map((x) => Datumii.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datumii {
  Datumii({
    this.id,
    this.addOnName,
    this.perBillCost,
    this.perReceiptCost,
    this.perCashMemoCost,
    this.perDigitalBillCost,
    this.perDigitalReceiptCost,
    this.perDigitalCashMemoCost,
    this.rechargeAmount,
    this.createdDate,
    this.gstAmt,
    this.totalAmt,
    this.cgst,
    this.igst,
    this.sgst,
    this.isActive,
  });

  int id;
  String addOnName;
  String perBillCost;
  dynamic perReceiptCost;
  dynamic perCashMemoCost;
  String perDigitalBillCost;
  dynamic perDigitalReceiptCost;
  dynamic perDigitalCashMemoCost;
  double rechargeAmount;
  String totalAmt;
  String gstAmt;
  int sgst;
  int igst;
  int cgst;
  DateTime createdDate;
  bool isActive;

  factory Datumii.fromJson(Map<String, dynamic> json) => Datumii(
    id: json["id"],
    addOnName: json["add_on_name"],
    perBillCost: json["per_bill_cost"],
    perReceiptCost: json["per_receipt_cost"],
    perCashMemoCost: json["per_cash_memo_cost"],
    perDigitalBillCost: json["per_digital_bill_cost"],
    perDigitalReceiptCost: json["per_digital_receipt_cost"],
    perDigitalCashMemoCost: json["per_digital_cash_memo_cost"],
    rechargeAmount: json["recharge_amount"],
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
    "add_on_name": addOnName,
    "per_bill_cost": perBillCost,
    "per_receipt_cost": perReceiptCost,
    "per_cash_memo_cost": perCashMemoCost,
    "per_digital_bill_cost": perDigitalBillCost,
    "per_digital_receipt_cost": perDigitalReceiptCost,
    "per_digital_cash_memo_cost": perDigitalCashMemoCost,
    "recharge_amount": rechargeAmount,
    "total_amount": totalAmt,
    "gst_amount": gstAmt,
    "sgst_value": sgst,
    "cgst_value": cgst,
    "igst_value": igst,
    "created_date": createdDate.toIso8601String(),
    "is_active": isActive,
  };
}
