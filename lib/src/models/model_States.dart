// To parse this JSON data, do
//
//     final addon = addonFromJson(jsonString);

import 'dart:convert';

States statesFromJson(String str) => States.fromJson(json.decode(str));

String statesToJson(States data) => json.encode(data.toJson());

class States {
  States({
    this.status,
    this.stateee,
    this.cityyy,
  });

  String status;
  List<Datumii> stateee;
  List<Datumoo> cityyy;

  factory States.fromJson(Map<String, dynamic> json) => States(
    status: json["status"],
    stateee: List<Datumii>.from(json["states"].map((x) => Datumii.fromJson(x))),
    cityyy: List<Datumoo>.from(json["cities"].map((y) => Datumoo.fromJson(y))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "states": List<dynamic>.from(stateee.map((x) => x.toJson())),
    "cities": List<dynamic>.from(cityyy.map((y) => y.toJson())),
  };
}

class Datumii {
  Datumii({
    this.state,
  });

  String state;

  factory Datumii.fromJson(Map<String, dynamic> json) => Datumii(
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "state": state,
  };
}

class Datumoo {
  Datumoo({
    this.city,
  });

  String city;

  factory Datumoo.fromJson(Map<String, dynamic> json) => Datumoo(
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
  };
}
