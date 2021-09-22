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
    this.term1,
    this.term2,
    this.term3,
  });

  String templateNo;
  String term1;
  String term2;
  String term3;

  factory Datum3.fromJson(Map<String, dynamic> json) => Datum3(
    templateNo: json["template_id"],
    term1: json["term1"],
    term2: json["term2"],
    term3: json["term3"],
  );

  Map<String, dynamic> toJson() => {
    "template_id": templateNo,
    "term1": term1,
    "term2": term2,
    "term3": term3,
  };
}
