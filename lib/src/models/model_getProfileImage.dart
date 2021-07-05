// To parse this JSON data, do
//
//     final getProfileImage = getProfileImageFromJson(jsonString);

import 'dart:convert';

GetProfileImage getProfileImageFromJson(String str) => GetProfileImage.fromJson(json.decode(str));

String getProfileImageToJson(GetProfileImage data) => json.encode(data.toJson());

class GetProfileImage {
  GetProfileImage({
    this.status,
    this.data,
  });

  String status;
  Data data;

  factory GetProfileImage.fromJson(Map<String, dynamic> json) => GetProfileImage(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.mobileNo,
    this.firstName,
    this.lastName,
    this.cUniqueId,
    this.profileImage,
  });

  String mobileNo;
  String firstName;
  String lastName;
  String cUniqueId;
  String profileImage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mobileNo: json["mobile_no"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    cUniqueId: json["c_unique_id"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "mobile_no": mobileNo,
    "first_name": firstName,
    "last_name": lastName,
    "c_unique_id": cUniqueId,
    "profile_image": profileImage,
  };
}
