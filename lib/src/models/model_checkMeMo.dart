// To parse this JSON data, do
//
//     final cashMemo = cashMemoFromJson(jsonString);

import 'dart:convert';

CheckMemo checkMemoFromJson(String str) => CheckMemo.fromJson(json.decode(str));

String checkMemoToJson(CheckMemo data) => json.encode(data.toJson());

class CheckMemo {
  CheckMemo({
    this.status,
    this.data,
  });

  String status;
  List<Datum2> data;

  factory CheckMemo.fromJson(Map<String, dynamic> json) => CheckMemo(
    status: json["status"],
    data: List<Datum2>.from(json["data"].map((x) => Datum2.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum2 {
  Datum2({
    this.templateNo,
    this.term1,
    this.term2,
    this.term3,
  });


  String templateNo;
  String term1;
  String term2;
  String term3;

  factory Datum2.fromJson(Map<String, dynamic> json) => Datum2(
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
