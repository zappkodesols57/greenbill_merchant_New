// To parse this JSON data, do
//
//     final suggestStoreList = suggestStoreListFromJson(jsonString);

import 'dart:convert';

SuggestStoreList suggestStoreListFromJson(String str) => SuggestStoreList.fromJson(json.decode(str));

String suggestStoreListToJson(SuggestStoreList data) => json.encode(data.toJson());

class SuggestStoreList {
  SuggestStoreList({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory SuggestStoreList.fromJson(Map<String, dynamic> json) => SuggestStoreList(
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
    this.mBusinessId,
    this.userId,
    this.suggestedBusinessName,
    this.contactNo,
    this.address,
    this.date,
  });

  int id;
  String mBusinessId;
  String userId;
  String suggestedBusinessName;
  String contactNo;
  String address;
  String date;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mBusinessId: json["m_business_id"],
    userId: json["user_id"],
    suggestedBusinessName: json["suggested_business_name"],
    contactNo: json["contact_no"],
    address: json["address"],
    date: json["suggested_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "m_business_id": mBusinessId,
    "user_id": userId,
    "suggested_business_name": suggestedBusinessName,
    "contact_no": contactNo,
    "address": address,
    "suggested_date": date,
  };
}
