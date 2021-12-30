// To parse this JSON data, do

import 'dart:convert';

CountBulk countFromJson(String str) => CountBulk.fromJson(json.decode(str));

String countToJson(CountBulk data) => json.encode(data.toJson());

class CountBulk {
  CountBulk({
    this.status,
    this.data,
  });

  String status;
  int data;

  factory CountBulk.fromJson(Map<String, dynamic> json) => CountBulk(
    status: json["status"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
  };
}
