// To parse this JSON data, do
//
//     final storeList = storeListFromJson(jsonString);

import 'dart:convert';

List<StoreList> storeListFromJson(String str) => List<StoreList>.from(json.decode(str).map((x) => StoreList.fromJson(x)));

String storeListToJson(List<StoreList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreList {
  StoreList({
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

  factory StoreList.fromJson(Map<String, dynamic> json) => StoreList(
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