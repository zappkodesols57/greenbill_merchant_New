// To parse this JSON data, do
//
//     final hSupportModules = hSupportModulesFromJson(jsonString);

import 'dart:convert';

HSupportModules hSupportModulesFromJson(String str) => HSupportModules.fromJson(json.decode(str));

String hSupportModulesToJson(HSupportModules data) => json.encode(data.toJson());

class HSupportModules {
  HSupportModules({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory HSupportModules.fromJson(Map<String, dynamic> json) => HSupportModules(
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
    this.moduleName,
  });

  String id;
  String moduleName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    moduleName: json["module_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "module_name": moduleName,
  };
}
