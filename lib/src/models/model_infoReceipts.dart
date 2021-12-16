// To parse this JSON data, do
//
//     final customerBills = customerBillsFromJson(jsonString);

import 'dart:convert';

CustomerReceipt customerReceiptFromJson(String str) => CustomerReceipt.fromJson(json.decode(str));

String customerReceiptToJson(CustomerReceipt data) => json.encode(data.toJson());

class CustomerReceipt {
  CustomerReceipt({
    this.status,
    this.personalDetails,
    this.datar,
  });

  String status;
  PersonalDetails personalDetails;
  List<datareceipt> datar;

  factory CustomerReceipt.fromJson(Map<String, dynamic> json) => CustomerReceipt(
    status: json["status"],
    personalDetails: PersonalDetails.fromJson(json["personal_details"]),
    datar: List<datareceipt>.from(json["data"].map((x) => datareceipt.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "personal_details": personalDetails.toJson(),
    "data": List<dynamic>.from(datar.map((x) => x.toJson())),
  };
}

class datareceipt {
  datareceipt({
    this.Id,
    this.date,
    this.receptNo,
    this.amount,
    this.receiptUrl,
  });

  int Id;
  String date;
  String receptNo;
  String amount;
  String receiptUrl;

  factory datareceipt.fromJson(Map<String, dynamic> json) => datareceipt(
    Id: json["id"],
    date: json["date"],
    amount: json["amount"],
    receptNo: json["receipt_no"],
    receiptUrl: json["receipt_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": Id,
    "date": date,
    "amount": amount,
    "receipt_no": receptNo,
    "receipt_url": receiptUrl,
  };
}

class PersonalDetails {
  PersonalDetails({
    this.mobileNo,
    this.name,
  });

  String mobileNo;
  String name;

  factory PersonalDetails.fromJson(Map<String, dynamic> json) => PersonalDetails(
    mobileNo: (json["mobile_no"].toString().isEmpty) ? "--//--" : json["mobile_no"],
    name: (json["name"].toString().isEmpty) ? "--//--" : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "mobile_no": mobileNo,
    "name": name,
  };
}
