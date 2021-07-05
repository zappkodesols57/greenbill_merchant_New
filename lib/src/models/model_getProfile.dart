// To parse this JSON data, do
//
//     final getProfile = getProfileFromJson(jsonString);

import 'dart:convert';

GetProfile getProfileFromJson(String str) => GetProfile.fromJson(json.decode(str));

String getProfileToJson(GetProfile data) => json.encode(data.toJson());

class GetProfile {
  GetProfile({
    this.status,
    this.profileData,
    this.imageData,
    this.generalSettingData,
  });

  String status;
  ProfileData profileData;
  String imageData;
  GeneralSettingData generalSettingData;

  factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
    status: json["status"],
    profileData: ProfileData.fromJson(json["profile_data"]),
    imageData: json["image_data"],
    generalSettingData: GeneralSettingData.fromJson(json["general_setting_data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "profile_data": profileData.toJson(),
    "image_data": imageData,
    "general_setting_data": generalSettingData.toJson(),
  };
}

class GeneralSettingData {
  GeneralSettingData({
    this.mBusinessName,
    this.mBusinessCategory,
    this.mArea,
    this.mCity,
    this.mDistrict,
    this.mState,
    this.mPinCode,
  });

  String mBusinessName;
  String mBusinessCategory;
  String mArea;
  String mCity;
  String mDistrict;
  String mState;
  String mPinCode;

  factory GeneralSettingData.fromJson(Map<String, dynamic> json) => GeneralSettingData(
    mBusinessName: json["m_business_name"],
    mBusinessCategory: json["m_business_category"],
    mArea: json["m_area"],
    mCity: json["m_city"],
    mDistrict: json["m_district"],
    mState: json["m_state"],
    mPinCode: json["m_pin_code"],
  );

  Map<String, dynamic> toJson() => {
    "m_business_name": mBusinessName,
    "m_business_category": mBusinessCategory,
    "m_area": mArea,
    "m_city": mCity,
    "m_district": mDistrict,
    "m_state": mState,
    "m_pin_code": mPinCode,
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
  dynamic mDob;
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
