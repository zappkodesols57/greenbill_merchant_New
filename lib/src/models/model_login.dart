// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDetailsFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDetailsToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  LoginData({
    this.status,
    this.token,
    this.data,
  });

  String status;
  String token;
  Data data;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    status: json["status"],
    token: json["token"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
    "data": data.toJson(),
  };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
