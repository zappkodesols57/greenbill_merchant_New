// To parse this JSON data, do
//
//     final storeList = storeListFromJson(jsonString);

import 'dart:convert';

List<StoreBillList> storeBillListFromJson(String str) => List<StoreBillList>.from(json.decode(str).map((x) => StoreBillList.fromJson(x)));

String storeBillListToJson(List<StoreBillList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreBillList {
  StoreBillList({
    this.id,
    this.mBusinessName,
    this.mAddress,
    this.mArea,
    this.mCity,
    this.mUserId,
    this.mBusinessLogo,
    this.mBusinessCategory,
  });

  int id;
  String mBusinessName;
  String mAddress;
  String mArea;
  String mCity;
  int mUserId;
  String mBusinessLogo;
  int mBusinessCategory;

  factory StoreBillList.fromJson(Map<String, dynamic> json) => StoreBillList(
    id: json["id"],
    mBusinessName: json["m_business_name"],
    mAddress: json["m_address"],
    mArea: json["m_area"],
    mCity: json["m_city"],
    mUserId: json["m_user_id"],
    mBusinessLogo: json["m_business_logo"] == null ? null : json["m_business_logo"],
    mBusinessCategory: json["m_business_category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "m_business_name": mBusinessName,
    "m_address": mAddress,
    "m_area": mArea,
    "m_city": mCity,
    "m_user_id": mUserId,
    "m_business_logo": mBusinessLogo == null ? null : mBusinessLogo,
    "m_business_category": mBusinessCategory,
  };
}