// To parse this JSON data, do
//
//     final cashMemo = cashMemoFromJson(jsonString);

import 'dart:convert';

CheckReceipt checkReceiptFromJson(String str) => CheckReceipt.fromJson(json.decode(str));

String checkReceiptToJson(CheckReceipt data) => json.encode(data.toJson());

class CheckReceipt {
  CheckReceipt({
    this.status,
    this.data,
  });

  String status;
  List<Datum3> data;

  factory CheckReceipt.fromJson(Map<String, dynamic> json) => CheckReceipt(
    status: json["status"],
    data: List<Datum3>.from(json["data"].map((x) => Datum3.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum3 {
  Datum3({
    this.templateNo,
  });

  String templateNo;

  factory Datum3.fromJson(Map<String, dynamic> json) => Datum3(
    templateNo: json["template_id"],
  );

  Map<String, dynamic> toJson() => {
    "template_id": templateNo,
  };
}
