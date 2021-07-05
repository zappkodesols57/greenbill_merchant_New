// To parse this JSON data, do
//
//     final allUsers = allUsersFromJson(jsonString);

import 'dart:convert';

AllUsers allUsersFromJson(String str) => AllUsers.fromJson(json.decode(str));

String allUsersToJson(AllUsers data) => json.encode(data.toJson());

class AllUsers {
  AllUsers({
    this.data,
  });

  List<Datum> data;

  factory AllUsers.fromJson(Map<String, dynamic> json) => AllUsers(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.mobileNo,
    this.email,
    this.roleId,
    this.roleName,
  });

  int id;
  String name;
  String mobileNo;
  String email;
  String roleId;
  String roleName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    mobileNo: json["mobile_no"],
    email: json["email"],
    roleId: json["role_id"],
    roleName: json["role_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile_no": mobileNo,
    "email": email,
    "role_id": roleId,
    "role_name": roleName,
  };
}
