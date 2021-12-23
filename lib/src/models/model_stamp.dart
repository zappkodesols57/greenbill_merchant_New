// To parse this JSON data, do

import 'dart:convert';

Stamp stampFromJson(String str) => Stamp.fromJson(json.decode(str));

String stampToJson(Stamp data) => json.encode(data.toJson());

class Stamp {
  Stamp({
    this.status,
    this.data1,
    this.data2,
  });

  String status;
  List<Datum1> data1;
  List<Datum2> data2;

  factory Stamp.fromJson(Map<String, dynamic> json) => Stamp(
    status: json["status"],
    data1: List<Datum1>.from(json["data1"].map((x) => Datum1.fromJson(x))),
    data2: List<Datum2>.from(json["data2"].map((x) => Datum2.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data1": List<dynamic>.from(data1.map((x) => x.toJson())),
    "data2": List<dynamic>.from(data2.map((x) => x.toJson())),
  };
}

class Datum1 {
  Datum1({
    this.stampId,
    this.stampName,
    this.type,
  });


  int stampId;
  String stampName;
  String type;


  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(

    stampId: json["id"],
    stampName: json["stamp_name"],
    type: json["type"],

  );

  Map<String, dynamic> toJson() => {

    "id": stampId,
    "stamp_name": stampName,
    "type": type,
  };
}


class Datum2 {
  Datum2({
    this.stamp2Id,
    this.stamp2Name,
    this.type2,
  });

  int stamp2Id;
  String stamp2Name;
  String type2;

  factory Datum2.fromJson(Map<String, dynamic> json) => Datum2(

    stamp2Id: json["id"],
    stamp2Name: json["stamp_name"],
    type2: json["type"],

  );

  Map<String, dynamic> toJson() => {

    "id": stamp2Id,
    "stamp_name": stamp2Name,
    "type": type2,
  };
}
