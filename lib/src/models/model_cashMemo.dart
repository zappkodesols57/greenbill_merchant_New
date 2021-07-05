// To parse this JSON data, do
//
//     final cashMemo = cashMemoFromJson(jsonString);

import 'dart:convert';

CashMemo cashMemoFromJson(String str) => CashMemo.fromJson(json.decode(str));

String cashMemoToJson(CashMemo data) => json.encode(data.toJson());

class CashMemo {
  CashMemo({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory CashMemo.fromJson(Map<String, dynamic> json) => CashMemo(
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
    this.memoNo,
    this.name,
    this.address,
    this.mobileNumber,
    this.date,
    this.total,
    this.memoUrl,
  });

  int id;
  String memoNo;
  String name;
  String address;
  String mobileNumber;
  String date;
  String total;
  String memoUrl;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    memoNo: json["memo_no"],
    name: json["name"],
    address: json["address"],
    mobileNumber: json["mobile_number"],
    date: json["date"],
    total: json["total"],
    memoUrl: json["memo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "memo_no": memoNo,
    "name": name,
    "address": address,
    "mobile_number": mobileNumber,
    "date": date,
    "total": total,
    "memo_url": memoUrl,
  };
}
