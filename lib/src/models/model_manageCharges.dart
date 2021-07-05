// To parse this JSON data, do
//
//     final manageCharges = manageChargesFromJson(jsonString);

import 'dart:convert';

ManageChargesList manageChargesFromJson(String str) => ManageChargesList.fromJson(json.decode(str));

String manageChargesToJson(ManageChargesList data) => json.encode(data.toJson());

class ManageChargesList {
  ManageChargesList({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory ManageChargesList.fromJson(Map<String, dynamic> json) => ManageChargesList(
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
    this.vehicleTypeId,
    this.vehicleType,
    this.chargesBy,
    this.charges,
    this.additionalHoursCharges,
    this.forHours,
    this.forAdditionalHours,
    this.createdAt,
    this.user,
  });

  int id;
  String mBusinessId;
  String vehicleTypeId;
  String vehicleType;
  String chargesBy;
  String charges;
  String additionalHoursCharges;
  String forHours;
  String forAdditionalHours;
  DateTime createdAt;
  int user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mBusinessId: json["m_business_id"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleType: json["vehicle_type"],
    chargesBy: json["charges_by"],
    charges: json["charges"],
    additionalHoursCharges: json["additional_hours_charges"],
    forHours: json["for_hours"],
    forAdditionalHours: json["for_additional_hours"],
    createdAt: DateTime.parse(json["created_at"]),
    user: json["user"] == null ? null : json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "m_business_id": mBusinessId,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_type": vehicleType,
    "charges_by": chargesBy,
    "charges": charges,
    "additional_hours_charges": additionalHoursCharges,
    "for_hours": forHours,
    "for_additional_hours": forAdditionalHours,
    "created_at": createdAt.toIso8601String(),
    "user": user == null ? null : user,
  };
}
