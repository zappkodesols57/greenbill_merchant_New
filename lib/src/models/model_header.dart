// To parse this JSON data, do

import 'dart:convert';

Header headerFromJson(String str) => Header.fromJson(json.decode(str));

String headerToJson(Header data) => json.encode(data.toJson());

class Header {
  Header({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
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
    this.headerId,
    this.createdAt,
    this.headerContent,
    this.statuss,

  });


  int headerId;
  String createdAt;
  String headerContent;
  String statuss;


  factory Datum.fromJson(Map<String, dynamic> json) => Datum(

    headerId: json["id"],
    createdAt: json["created_at"],
    headerContent: json["header_content"],
    statuss: json["status"],

  );

  Map<String, dynamic> toJson() => {

    "id": headerId,
    "created_at": createdAt,
    "header_content": headerContent,
    "status": statuss,
  };
}
