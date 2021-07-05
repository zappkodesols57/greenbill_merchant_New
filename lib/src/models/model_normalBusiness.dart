// To parse this JSON data, do
//
//     final normalBusiness = normalBusinessFromJson(jsonString);

import 'dart:convert';

NormalBusiness normalBusinessFromJson(String str) => NormalBusiness.fromJson(json.decode(str));

String normalBusinessToJson(NormalBusiness data) => json.encode(data.toJson());

class NormalBusiness {
  NormalBusiness({
    this.status,
    this.data,
  });

  String status;
  Data data;

  factory NormalBusiness.fromJson(Map<String, dynamic> json) => NormalBusiness(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.todaysTransaction,
    this.averageTransaction,
    this.totalSales,
    this.averageSales,
  });

  int todaysTransaction;
  String averageTransaction;
  String totalSales;
  String averageSales;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    todaysTransaction: json["todays_transaction"],
    averageTransaction: json["average_transaction"],
    totalSales: json["total_sales"],
    averageSales: json["average_sales"],
  );

  Map<String, dynamic> toJson() => {
    "todays_transaction": todaysTransaction,
    "average_transaction": averageTransaction,
    "total_sales": totalSales,
    "average_sales": averageSales,
  };
}
