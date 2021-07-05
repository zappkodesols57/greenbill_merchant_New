// To parse this JSON data, do
//
//     final payments = paymentsFromJson(jsonString);

import 'dart:convert';

Payments paymentsFromJson(String str) => Payments.fromJson(json.decode(str));

String paymentsToJson(Payments data) => json.encode(data.toJson());

class Payments {
  Payments({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
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
    this.userId,
    this.mUserId,
    this.mBusinessId,
    this.mobileNo,
    this.vehicleType,
    this.vehicleTypeId,
    this.vehicleNumber,
    this.amount,
    this.date,
    this.time,
    this.invoiceNo,
    this.exitGate,
    this.createdAt,
    this.workerName,
    this.additionalHoursCharges,
    this.cUniqueId,
    this.billFile,
    this.exitCheck,
    this.outDate,
    this.outTime,
    this.billUrl,
    this.duration,
    this.billCategoryId,
    this.billTags,
    this.remarks,
    this.billFlag,
    this.rating,
    this.isCheckoutpin,
    this.manageSpace,
    this.chargesBy,
    this.flagUpdateAt,
    this.flagBy,
    this.reasonId,
    this.reason,
    this.forHours,
    this.forAdditionalHours,
  });

  int id;
  String userId;
  String mUserId;
  String mBusinessId;
  String mobileNo;
  String vehicleType;
  String vehicleTypeId;
  String vehicleNumber;
  String amount;
  String date;
  String time;
  String invoiceNo;
  String exitGate;
  DateTime createdAt;
  String workerName;
  String additionalHoursCharges;
  String cUniqueId;
  String billFile;
  bool exitCheck;
  dynamic outDate;
  dynamic outTime;
  String billUrl;
  dynamic duration;
  String billCategoryId;
  String billTags;
  String remarks;
  bool billFlag;
  String rating;
  bool isCheckoutpin;
  bool manageSpace;
  String chargesBy;
  DateTime flagUpdateAt;
  String flagBy;
  String reasonId;
  String reason;
  String forHours;
  String forAdditionalHours;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    mUserId: json["m_user_id"],
    mBusinessId: json["m_business_id"],
    mobileNo: json["mobile_no"],
    vehicleType: json["vehicle_type"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleNumber: json["vehicle_number"],
    amount: json["amount"],
    date: json["date"],
    time: json["time"],
    invoiceNo: json["invoice_no"],
    exitGate: json["exit_gate"],
    createdAt: DateTime.parse(json["created_at"]),
    workerName: json["worker_name"],
    additionalHoursCharges: json["additional_hours_charges"],
    cUniqueId: json["c_unique_id"],
    billFile: json["bill_file"],
    exitCheck: json["exit_check"],
    outDate: json["out_date"],
    outTime: json["out_time"],
    billUrl: json["bill_url"],
    duration: json["duration"],
    billCategoryId: json["bill_category_id"],
    billTags: json["bill_tags"],
    remarks: json["remarks"],
    billFlag: json["bill_flag"],
    rating: json["rating"],
    isCheckoutpin: json["is_checkoutpin"],
    manageSpace: json["manage_space"],
    chargesBy: json["charges_by"],
    flagUpdateAt: DateTime.parse(json["flag_update_at"]),
    flagBy: json["flag_by"],
    reasonId: json["reason_id"],
    reason: json["reason"],
    forHours: json["for_hours"],
    forAdditionalHours: json["for_additional_hours"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "m_user_id": mUserId,
    "m_business_id": mBusinessId,
    "mobile_no": mobileNo,
    "vehicle_type": vehicleType,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_number": vehicleNumber,
    "amount": amount,
    "date": date,
    "time": time,
    "invoice_no": invoiceNo,
    "exit_gate": exitGate,
    "created_at": createdAt.toIso8601String(),
    "worker_name": workerName,
    "additional_hours_charges": additionalHoursCharges,
    "c_unique_id": cUniqueId,
    "bill_file": billFile,
    "exit_check": exitCheck,
    "out_date": outDate,
    "out_time": outTime,
    "bill_url": billUrl,
    "duration": duration,
    "bill_category_id": billCategoryId,
    "bill_tags": billTags,
    "remarks": remarks,
    "bill_flag": billFlag,
    "rating": rating,
    "is_checkoutpin": isCheckoutpin,
    "manage_space": manageSpace,
    "charges_by": chargesBy,
    "flag_update_at": flagUpdateAt.toIso8601String(),
    "flag_by": flagBy,
    "reason_id": reasonId,
    "reason": reason,
    "for_hours": forHours,
    "for_additional_hours": forAdditionalHours,
  };
}
