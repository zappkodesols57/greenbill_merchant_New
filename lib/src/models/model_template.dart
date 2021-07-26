// To parse this JSON data, do

import 'dart:convert';

Template templateFromJson(String str) => Template.fromJson(json.decode(str));

String templateToJson(Template data) => json.encode(data.toJson());

class Template {
  Template({
    this.status,
    this.data,
  });

  String status;
  List<Datud> data;

  factory Template.fromJson(Map<String, dynamic> json) => Template(
    status: json["status"],
    data: List<Datud>.from(json["data"].map((x) => Datud.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datud {
  Datud({
    this.templateID,
    this.createdAt,
    this.templateContent,
    this.statuss,

  });

  int templateID;
  String createdAt;
  String templateContent;
  String statuss;




  factory Datud.fromJson(Map<String, dynamic> json) => Datud(

    templateID:json["id"],
    createdAt: json["created_at"],
    templateContent: json["template_content"],
    statuss: json["status"],

  );

  Map<String, dynamic> toJson() => {

    "id":templateID,
    "created_at": createdAt,
    "template_content": templateContent,
    "status": statuss,
  };
}
