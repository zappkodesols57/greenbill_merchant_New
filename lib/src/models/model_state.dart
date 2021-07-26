// To parse this JSON data, do

import 'dart:convert';

StateM stateMFromJson(String str) => StateM.fromJson(json.decode(str));

String stateMToJson(StateM data) => json.encode(data.toJson());

class StateM {
  StateM({
    this.status,
    this.data,
  });

  String status;
  List<Datus> data;

  factory StateM.fromJson(Map<String, dynamic> json) => StateM(
    status: json["status"],
    data: List<Datus>.from(json["data"].map((x) => Datus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datus {
  Datus({
    this.cState,

  });

  String cState;

  factory Datus.fromJson(Map<String, dynamic> json) => Datus(

    cState:json["c_state"],

  );

  Map<String, dynamic> toJson() => {
    "c_state":cState,
  };
}
