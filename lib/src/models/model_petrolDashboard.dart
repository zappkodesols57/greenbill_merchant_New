// To parse this JSON data, do
//
//     final petrolDashboardData = petrolDashboardDataFromJson(jsonString);

import 'dart:convert';

PetrolDashboardData petrolDashboardDataFromJson(String str) => PetrolDashboardData.fromJson(json.decode(str));

String petrolDashboardDataToJson(PetrolDashboardData data) => json.encode(data.toJson());

class PetrolDashboardData {
  PetrolDashboardData({
    this.status,
    this.todaysPayments,
    this.todaysBill,
    this.todaysSales,
    this.todaysRate,
  });

  String status;
  TodaysPayments todaysPayments;
  TodaysBill todaysBill;
  List<TodaysSale> todaysSales;
  List<TodaysRate> todaysRate;

  factory PetrolDashboardData.fromJson(Map<String, dynamic> json) => PetrolDashboardData(
    status: json["status"],
    todaysPayments: TodaysPayments.fromJson(json["todays_payments"]),
    todaysBill: TodaysBill.fromJson(json["todays_bill"]),
    todaysSales: List<TodaysSale>.from(json["todays_sales"].map((x) => TodaysSale.fromJson(x))),
    todaysRate: List<TodaysRate>.from(json["todays_rate"].map((x) => TodaysRate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "todays_payments": todaysPayments.toJson(),
    "todays_bill": todaysBill.toJson(),
    "todays_sales": List<dynamic>.from(todaysSales.map((x) => x.toJson())),
    "todays_rate": List<dynamic>.from(todaysRate.map((x) => x.toJson())),
  };
}

class TodaysBill {
  TodaysBill({
    this.total,
    this.flagged,
  });

  int total;
  int flagged;

  factory TodaysBill.fromJson(Map<String, dynamic> json) => TodaysBill(
    total: json["total"],
    flagged: json["flagged"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "flagged": flagged,
  };
}

class TodaysPayments {
  TodaysPayments({
    this.cash,
    this.online,
  });

  double cash;
  String online;

  factory TodaysPayments.fromJson(Map<String, dynamic> json) => TodaysPayments(
    cash: json["cash"],
    online: json["online"],
  );

  Map<String, dynamic> toJson() => {
    "cash": cash,
    "online": online,
  };
}

class TodaysRate {
  TodaysRate({
    this.productName,
    this.productCost,
  });

  String productName;
  double productCost;

  factory TodaysRate.fromJson(Map<String, dynamic> json) => TodaysRate(
    productName: json["product_name"],
    productCost: json["product_cost"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "product_cost": productCost,
  };
}

class TodaysSale {
  TodaysSale({
    this.productName,
    this.totalAmountColleted,
  });

  String productName;
  double totalAmountColleted;

  factory TodaysSale.fromJson(Map<String, dynamic> json) => TodaysSale(
    productName: json["product_name"],
    totalAmountColleted: json["total_amount_colleted"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "total_amount_colleted": totalAmountColleted,
  };
}
