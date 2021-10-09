// To parse this JSON data, do
//
//     final normalBusiness = normalBusinessFromJson(jsonString);

import 'dart:convert';

ExeDetails exeDetailsFromJson(String str) => ExeDetails.fromJson(json.decode(str));

String exeDetailsToJson(ExeDetails data) => json.encode(data.toJson());

class ExeDetails {
  ExeDetails({
    this.status,
    this.printed,
    this.sent,
    this.printnsent,
  });

  String status;
  int printed;
  int sent;
  int printnsent;

  factory ExeDetails.fromJson(Map<String, dynamic> json) => ExeDetails(
    status: json["status"],
    printed: json["print_bill_status"],
    printnsent: json["send_print_bill_status"],
    sent: json["send_bill_status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "print_bill_status": printed,
    "send_print_bill_status": printnsent,
    "send_bill_status": sent,
  };
}
