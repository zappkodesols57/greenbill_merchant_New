// To parse this JSON data, do
//
//     final analysis = analysisFromJson(jsonString);

import 'dart:convert';

Analysis analysisFromJson(String str) => Analysis.fromJson(json.decode(str));

String analysisToJson(Analysis data) => json.encode(data.toJson());

class Analysis {
  Analysis({
    this.status,
    this.data,
  });

  String status;
  DataU data;

  factory Analysis.fromJson(Map<String, dynamic> json) => Analysis(
    status: json["status"],
    data: DataU.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class DataU {
  DataU({
    this.newCustomersText,
    this.newCustomersValue,
    this.returningCustomersText,
    this.returningCustomersValue,
  });

  String newCustomersText;
  String newCustomersValue;
  String returningCustomersText;
  String returningCustomersValue;

  factory DataU.fromJson(Map<String, dynamic> json) => DataU(
    newCustomersText: json["new_customers_text"],
    newCustomersValue: json["new_customers_value"],
    returningCustomersText: json["returning_customers_text"],
    returningCustomersValue: json["returning_customers_value"],
  );

  Map<String, dynamic> toJson() => {
    "new_customers_text": newCustomersText,
    "new_customers_value": newCustomersValue,
    "returning_customers_text": returningCustomersText,
    "returning_customers_value": returningCustomersValue,
  };
}
