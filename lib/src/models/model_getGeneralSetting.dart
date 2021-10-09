// To parse this JSON data, do
//
//     final getSetting = getSettingFromJson(jsonString);

import 'dart:convert';

GetSetting getSettingFromJson(String str) => GetSetting.fromJson(json.decode(str));

String getSettingToJson(GetSetting data) => json.encode(data.toJson());

class GetSetting {
  GetSetting({
    this.status,
    this.data,
  });

  String status;
  Data data;

  factory GetSetting.fromJson(Map<String, dynamic> json) => GetSetting(
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
    this.mBusinessName,
    this.mBusinessCategoryId,
    this.mBusinessCategoryName,
    this.mPinCode,
    this.mCity,
    this.mArea,
    this.mDistrict,
    this.mState,
    this.mAddress,
    this.mLandlineNumber,
    this.mAlternateMobileNumber,
    this.mCompanyEmail,
    this.mAlternateEmail,
    this.mPanNumber,
    this.mGstin,
    this.mCin,
    this.mBankAccountNumber,
    this.mBankIfscCode,
    this.mBankName,
    this.mBankBranch,
    this.mGstinCertificate,
    this.mCinCertificate,
    this.mBusinessLogo,
    this.mBusinessStamp,
    this.mDigitalSignature,
    this.webSiteUrl,
    this.busNameBilling,
    this.billingAdd,
    this.billingEmail,
    this.billingPhone,
    this.vatNo,
    this.aadharNo,
    this.entityAccount,
    this.entityBankAc,
    this.firstName,
    this.lastName,
  });

  String mBusinessName;
  int mBusinessCategoryId;
  String mBusinessCategoryName;
  String mPinCode;
  String mCity;
  String mArea;
  String mDistrict;
  String mState;
  String mAddress;
  String mLandlineNumber;
  String mAlternateMobileNumber;
  String mCompanyEmail;
  String mAlternateEmail;
  String mPanNumber;
  String mGstin;
  String mCin;
  String mBankAccountNumber;
  String mBankIfscCode;
  String mBankName;
  String mBankBranch;
  String mGstinCertificate;
  String mCinCertificate;
  String mBusinessLogo;
  String mBusinessStamp;
  String mDigitalSignature;

  String webSiteUrl;
  String busNameBilling;
  String billingAdd;
  String billingEmail;
  String billingPhone;
  String vatNo;
  String aadharNo;
  String entityAccount;
  String entityBankAc;
  String firstName;
  String lastName;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mBusinessName: json["m_business_name"],
    mBusinessCategoryId: json["m_business_category_id"],
    mBusinessCategoryName: json["m_business_category_name"],
    mPinCode: json["m_pin_code"],
    mCity: json["m_city"],
    mArea: json["m_area"],
    mDistrict: json["m_district"],
    mState: json["m_state"],
    mAddress: json["m_address"],
    mLandlineNumber: json["m_landline_number"],
    mAlternateMobileNumber: json["m_alternate_mobile_number"],
    mCompanyEmail: json["m_company_email"],
    mAlternateEmail: json["m_alternate_email"],
    mPanNumber: json["m_pan_number"],
    mGstin: json["m_gstin"],
    mCin: json["m_cin"],
    mBankAccountNumber: json["m_bank_account_number"],
    mBankIfscCode: json["m_bank_IFSC_code"],
    mBankName: json["m_bank_name"],
    mBankBranch: json["m_bank_branch"],
    mGstinCertificate: json["m_GSTIN_certificate"],
    mCinCertificate: json["m_CIN_certificate"],
    mBusinessLogo: json["m_business_logo"],
    mBusinessStamp: json["m_business_stamp"],
    mDigitalSignature: json["m_digital_signature"],
    webSiteUrl: json["m_website_url"],
    busNameBilling: json["m_business_name_for_billing"],
    billingAdd: json["m_billing_address"],
    billingEmail: json["m_billing_email"],
    billingPhone: json["m_billing_phone"],
    vatNo: json["m_vat_tin_number"],
    aadharNo: json["m_aadhaar_number"],
    entityAccount: json["Entity_Account_m"],
    entityBankAc: json["Entity_Bank_Account_m"],
    firstName: json["first_name"],
    lastName: json["last_name"],
  );

  Map<String, dynamic> toJson() => {
    "m_business_name": mBusinessName,
    "m_business_category_id": mBusinessCategoryId,
    "m_business_category_name": mBusinessCategoryName,
    "m_pin_code": mPinCode,
    "m_city": mCity,
    "m_area": mArea,
    "m_district": mDistrict,
    "m_state": mState,
    "m_address": mAddress,
    "m_landline_number": mLandlineNumber,
    "m_alternate_mobile_number": mAlternateMobileNumber,
    "m_company_email": mCompanyEmail,
    "m_alternate_email": mAlternateEmail,
    "m_pan_number": mPanNumber,
    "m_gstin": mGstin,
    "m_cin": mCin,
    "m_bank_account_number": mBankAccountNumber,
    "m_bank_IFSC_code": mBankIfscCode,
    "m_bank_name": mBankName,
    "m_bank_branch": mBankBranch,
    "m_GSTIN_certificate": mGstinCertificate,
    "m_CIN_certificate": mCinCertificate,
    "m_business_logo": mBusinessLogo,
    "m_business_stamp": mBusinessStamp,
    "m_digital_signature": mDigitalSignature,
    "m_website_url": webSiteUrl,
    "m_business_name_for_billing": busNameBilling,
    "m_billing_address": billingAdd,
    "m_billing_email": billingEmail,
    "m_billing_phone": billingPhone,
    "m_vat_tin_number": vatNo,
    "m_aadhaar_number": aadharNo,
    "Entity_Account_m": entityAccount,
    "Entity_Bank_Account_m": entityBankAc,
    "first_name": firstName,
    "last_name": lastName,
  };
}
