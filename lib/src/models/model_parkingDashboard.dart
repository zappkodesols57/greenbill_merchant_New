// To parse this JSON data, do
//
//     final parkingDashboardData = parkingDashboardDataFromJson(jsonString);

import 'dart:convert';

ParkingDashboardData parkingDashboardDataFromJson(String str) => ParkingDashboardData.fromJson(json.decode(str));

String parkingDashboardDataToJson(ParkingDashboardData data) => json.encode(data.toJson());

class ParkingDashboardData {
  ParkingDashboardData({
    this.status,
    this.todaysPayments,
    this.todaysBill,
    this.spaceAvailable,
    this.notExited,
  });

  String status;
  TodaysPayments todaysPayments;
  TodaysBill todaysBill;
  List<SpaceAvailable> spaceAvailable;
  List<NotExited> notExited;

  factory ParkingDashboardData.fromJson(Map<String, dynamic> json) => ParkingDashboardData(
    status: json["status"],
    todaysPayments: TodaysPayments.fromJson(json["todays_payments"]),
    todaysBill: TodaysBill.fromJson(json["todays_bill"]),
    spaceAvailable: List<SpaceAvailable>.from(json["space_available"].map((x) => SpaceAvailable.fromJson(x))),
    notExited: List<NotExited>.from(json["not_exited"].map((x) => NotExited.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "todays_payments": todaysPayments.toJson(),
    "todays_bill": todaysBill.toJson(),
    "space_available": List<dynamic>.from(spaceAvailable.map((x) => x.toJson())),
    "not_exited": List<dynamic>.from(notExited.map((x) => x.toJson())),
  };
}

class NotExited {
  NotExited({
    this.vehicleType,
    this.spaceUsed,
  });

  String vehicleType;
  int spaceUsed;

  factory NotExited.fromJson(Map<String, dynamic> json) => NotExited(
    vehicleType: json["vehicle_type"],
    spaceUsed: json["space_used"],
  );

  Map<String, dynamic> toJson() => {
    "vehicle_type": vehicleType,
    "space_used": spaceUsed,
  };
}

class SpaceAvailable {
  SpaceAvailable({
    this.vehicleType,
    this.availableParkingSpace,
    this.totalSpace,
  });

  String vehicleType;
  String availableParkingSpace;
  String totalSpace;

  factory SpaceAvailable.fromJson(Map<String, dynamic> json) => SpaceAvailable(
    vehicleType: json["vehicle_type"],
    availableParkingSpace: json["available_parking_space"],
    totalSpace: json["total_space"],
  );

  Map<String, dynamic> toJson() => {
    "vehicle_type": vehicleType,
    "available_parking_space": availableParkingSpace,
    "total_space": totalSpace,
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
