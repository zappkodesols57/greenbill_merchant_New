// To parse this JSON data, do
//
//     final getBillCategory = getBillCategoryFromJson(jsonString);

import 'dart:convert';

GetBillCategory getBillCategoryFromJson(String str) =>
    GetBillCategory.fromJson(json.decode(str));

String getBillCategoryToJson(GetBillCategory data) =>
    json.encode(data.toJson());

class GetBillCategory {
  GetBillCategory({
    this.status,
    this.data,
  });

  String status;
  List<Datumn> data;

  factory GetBillCategory.fromJson(Map<String, dynamic> json) =>
      GetBillCategory(
        status: json["status"],
        data: List<Datumn>.from(json["data"].map((x) => Datumn.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datumn{
  Datumn({
    this.id,
    this.billCategoryName,
    this.billCategoryDescription,
    this.billCount,
    this.icon,
    this.iconUrl,
  });

  int id;
  String billCategoryName;
  String billCategoryDescription;
  int billCount;
  String icon;
  String iconUrl;

  factory Datumn.fromJson(Map<String, dynamic> json) => Datumn(
        id: json["id"],
        billCategoryName: json["bill_category_name"],
        billCategoryDescription: json["bill_category_description"],
        billCount: json["bill_count"],
        icon: json["icon"],
        iconUrl: json["icon_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bill_category_name": billCategoryName,
        "bill_category_description": billCategoryDescription,
        "bill_count": billCount,
        "icon": icon,
        "icon_url": iconUrl
      };
}
