// To parse this JSON data, do
//
//     final remainingSpace = remainingSpaceFromJson(jsonString);

import 'dart:convert';

RemainingSpace remainingSpaceFromJson(String str) => RemainingSpace.fromJson(json.decode(str));

String remainingSpaceToJson(RemainingSpace data) => json.encode(data.toJson());

class RemainingSpace {
  RemainingSpace({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory RemainingSpace.fromJson(Map<String, dynamic> json) => RemainingSpace(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

Datum datumFromJson(String str) => Datum.fromJson(json.decode(str));
class Datum {
  Datum({
    this.id,
    this.vehicleType,
    this.spacesCount,
    this.availableParkingSpace,
  });

  int id;
  String vehicleType;
  String spacesCount;
  int availableParkingSpace;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vehicleType: json["vehicle_type"],
    spacesCount: json["spaces_count"],
    availableParkingSpace: json["available_parking_space"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type": vehicleType,
    "spaces_count": spacesCount,
    "available_parking_space": availableParkingSpace,
  };
}
