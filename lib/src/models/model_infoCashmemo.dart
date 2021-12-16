// To parse this JSON data, do
//
//     final customerBills = customerBillsFromJson(jsonString);

import 'dart:convert';

CustomerCashmemo customerMemoFromJson(String str) => CustomerCashmemo.fromJson(json.decode(str));

String customerMemoToJson(CustomerCashmemo data) => json.encode(data.toJson());

class CustomerCashmemo {
  CustomerCashmemo({
    this.status,
    this.personalDetails,
    this.datad,
  });

  String status;
  PersonalDetails personalDetails;
  List<datacash> datad;

  factory CustomerCashmemo.fromJson(Map<String, dynamic> json) => CustomerCashmemo(
    status: json["status"],
    personalDetails: PersonalDetails.fromJson(json["personal_details"]),
    datad: List<datacash>.from(json["data"].map((x) => datacash.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "personal_details": personalDetails.toJson(),
    "data": List<dynamic>.from(datad.map((x) => x.toJson())),
  };
}

class datacash {
  datacash({
    this.Id,
    this.date,
    this.memoNo,
    this.amount,
    this.memoUrl,

  });

  int Id;
  String date;
  String memoNo;
  String amount;
  String memoUrl;

  factory datacash.fromJson(Map<String, dynamic> json) => datacash(
    Id: json["id"],
    date: json["date"],
    amount: json["amount"],
    memoNo: json["memo_no"],
    memoUrl: json["memo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": Id,
    "date": date,
    "amount": amount,
    "memo_no": memoNo,
    "memo_url": memoUrl,
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
