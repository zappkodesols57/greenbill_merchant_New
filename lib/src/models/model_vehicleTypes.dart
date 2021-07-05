// To parse this JSON data, do
//
//     final vehicleTypes = vehicleTypesFromJson(jsonString);

import 'dart:convert';

List<VehicleTypes> vehicleTypesFromJson(String str) => List<VehicleTypes>.from(json.decode(str).map((x) => VehicleTypes.fromJson(x)));

String vehicleTypesToJson(List<VehicleTypes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleTypes {
  VehicleTypes({
    this.id,
    this.vehicleType,
  });

  int id;
  String vehicleType;

  factory VehicleTypes.fromJson(Map<String, dynamic> json) => VehicleTypes(
    id: json["id"],
    vehicleType: json["vehicle_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type": vehicleType,
  };
}
