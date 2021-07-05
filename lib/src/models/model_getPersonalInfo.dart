// To parse this JSON data, do
//
//     final getPersonalInfo = getPersonalInfoFromJson(jsonString);

import 'dart:convert';

GetPersonalInfo getPersonalInfoFromJson(String str) => GetPersonalInfo.fromJson(json.decode(str));

String getPersonalInfoToJson(GetPersonalInfo data) => json.encode(data.toJson());

class GetPersonalInfo {
  GetPersonalInfo({
    this.status,
    this.profileData,
    this.imageData,
  });

  String status;
  ProfileData profileData;
  String imageData;

  factory GetPersonalInfo.fromJson(Map<String, dynamic> json) => GetPersonalInfo(
    status: json["status"],
    profileData: ProfileData.fromJson(json["profile_data"]),
    imageData: json["image_data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "profile_data": profileData.toJson(),
    "image_data": imageData,
  };
}

class ProfileData {
  ProfileData({
    this.id,
    this.mobileNo,
    this.password,
    this.mEmail,
    this.isMerchant,
    this.isCustomer,
    this.firstName,
    this.lastName,
    this.mAdhaarNumber,
    this.mDesignation,
    this.mDob,
    this.mPanNumber,
    this.isActive,
    this.dateJoined,
    this.isMerchantStaff,
  });

  int id;
  String mobileNo;
  String password;
  String mEmail;
  bool isMerchant;
  bool isCustomer;
  String firstName;
  String lastName;
  String mAdhaarNumber;
  String mDesignation;
  String mDob;
  String mPanNumber;
  bool isActive;
  DateTime dateJoined;
  bool isMerchantStaff;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    mobileNo: json["mobile_no"],
    password: json["password"],
    mEmail: json["m_email"],
    isMerchant: json["is_merchant"],
    isCustomer: json["is_customer"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    mAdhaarNumber: json["m_adhaar_number"],
    mDesignation: json["m_designation"],
    mDob: json["m_dob"],
    mPanNumber: json["m_pan_number"],
    isActive: json["is_active"],
    dateJoined: DateTime.parse(json["date_joined"]),
    isMerchantStaff: json["is_merchant_staff"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile_no": mobileNo,
    "password": password,
    "m_email": mEmail,
    "is_merchant": isMerchant,
    "is_customer": isCustomer,
    "first_name": firstName,
    "last_name": lastName,
    "m_adhaar_number": mAdhaarNumber,
    "m_designation": mDesignation,
    "m_dob": mDob,
    "m_pan_number": mPanNumber,
    "is_active": isActive,
    "date_joined": dateJoined.toIso8601String(),
    "is_merchant_staff": isMerchantStaff,
  };
}
