// To parse this JSON data, do
//
//     final subscriptionPlans = subscriptionPlansFromJson(jsonString);

import 'dart:convert';

SubscriptionPlans subscriptionPlansFromJson(String str) => SubscriptionPlans.fromJson(json.decode(str));

String subscriptionPlansToJson(SubscriptionPlans data) => json.encode(data.toJson());

class SubscriptionPlans {
  SubscriptionPlans({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory SubscriptionPlans.fromJson(Map<String, dynamic> json) => SubscriptionPlans(
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
    this.subscriptionName,
    this.validForMonth,
    this.perBillCost,
    this.perReceiptCost,
    this.perCashMemoCost,
    this.perDigitalBillCost,
    this.perDigitalReceiptCost,
    this.perDigitalCashMemoCost,
    this.softwareMaintainaceCost,
    this.rechargeAmount,
    this.discountIn,
    this.discountPercentage,
    this.discountAmount,
    this.userType,
    this.subscriptionPlanCost,
    this.businessCategory,
    this.merchantName,
    this.customizedPlanFor,
    this.customizedPlan,
    this.suitedFor,
    this.numberOfUsers,
    this.createdDate,
    this.isActive,
    this.isOffer,
    this.gstAmt,
    this.totalAmt,
    this.cgst,
    this.igst,
    this.sgst,
    this.costPerUser,
    this.sUrl,
  });

  int id;
  String subscriptionName;
  String validForMonth;
  String perBillCost;
  String perReceiptCost;
  String perCashMemoCost;
  String perDigitalBillCost;
  String perDigitalReceiptCost;
  String perDigitalCashMemoCost;
  String softwareMaintainaceCost;
  String rechargeAmount;
  String discountIn;
  String discountPercentage;
  String discountAmount;
  String userType;
  double subscriptionPlanCost;
  String businessCategory;
  String merchantName;
  String numberOfUsers;
  String customizedPlanFor;
  bool customizedPlan;
  String suitedFor;
  DateTime createdDate;
  bool isActive;
  String totalAmt;
  String gstAmt;
  int sgst;
  int igst;
  int cgst;
  bool isOffer;
  String costPerUser;
  String sUrl;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    subscriptionName: json["subscription_name"],
    validForMonth: json["valid_for_month"],
    perBillCost: json["per_bill_cost"],
    perReceiptCost: json["per_receipt_cost"] == null ? null : json["per_receipt_cost"],
    perCashMemoCost: json["per_cash_memo_cost"] == null ? null : json["per_cash_memo_cost"],
    perDigitalBillCost: json["per_digital_bill_cost"],
    perDigitalReceiptCost: json["per_digital_receipt_cost"] == null ? null : json["per_digital_receipt_cost"],
    perDigitalCashMemoCost: json["per_digital_cash_memo_cost"] == null ? null : json["per_digital_cash_memo_cost"],
    softwareMaintainaceCost: json["software_maintainace_cost"],
    rechargeAmount: json["recharge_amount"],
    discountIn: json["discount_in"],
    discountPercentage: json["discount_percentage"],
    discountAmount: json["discount_amount"],
    userType: json["user_type"],
    numberOfUsers: json["number_of_users"],
    subscriptionPlanCost: json["subscription_plan_cost"],
    businessCategory: json["business_category"],
    merchantName: json["merchant_name"],
    customizedPlanFor: json["customized_plan_for"],
    customizedPlan: json["customized_plan"],
    suitedFor: json["suited_for"],
    createdDate: DateTime.parse(json["created_date"]),
    isActive: json["is_active"],
    isOffer: json["is_offer"],
    gstAmt: json["gst_amount"],
    cgst: json["cgst_value"],
    igst: json["igst_value"],
    sgst: json["sgst_value"],
    totalAmt: json["total_amount"],
    costPerUser: json["cost_for_users"],
    sUrl: json["surl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subscription_name": subscriptionName,
    "valid_for_month": validForMonth,
    "per_bill_cost": perBillCost,
    "per_receipt_cost": perReceiptCost == null ? null : perReceiptCost,
    "per_cash_memo_cost": perCashMemoCost == null ? null : perCashMemoCost,
    "per_digital_bill_cost": perDigitalBillCost,
    "per_digital_receipt_cost": perDigitalReceiptCost == null ? null : perDigitalReceiptCost,
    "per_digital_cash_memo_cost": perDigitalCashMemoCost == null ? null : perDigitalCashMemoCost,
    "software_maintainace_cost": softwareMaintainaceCost,
    "recharge_amount": rechargeAmount,
    "discount_in": discountIn,
    "discount_percentage": discountPercentage,
    "discount_amount": discountAmount,
    "user_type": userType,
    "subscription_plan_cost": subscriptionPlanCost,
    "business_category": businessCategory,
    "merchant_name": merchantName,
    "customized_plan_for": customizedPlanFor,
    "customized_plan": customizedPlan,
    "suited_for": suitedFor,
    "number_of_users": numberOfUsers,
    "created_date": createdDate.toIso8601String(),
    "is_active": isActive,
    "total_amount": totalAmt,
    "gst_amount": gstAmt,
    "sgst_value": sgst,
    "cgst_value": cgst,
    "igst_value": igst,
    "is_offer": isOffer,
    "cost_for_users": costPerUser,
    "surl": sUrl,
  };
}
