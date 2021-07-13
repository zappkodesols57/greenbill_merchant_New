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
    this.createdDate,
    this.isActive,
    this.isOffer,
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
  String subscriptionPlanCost;
  String businessCategory;
  String merchantName;
  String customizedPlanFor;
  bool customizedPlan;
  String suitedFor;
  DateTime createdDate;
  bool isActive;
  bool isOffer;

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
    subscriptionPlanCost: json["subscription_plan_cost"],
    businessCategory: json["business_category"],
    merchantName: json["merchant_name"],
    customizedPlanFor: json["customized_plan_for"],
    customizedPlan: json["customized_plan"],
    suitedFor: json["suited_for"],
    createdDate: DateTime.parse(json["created_date"]),
    isActive: json["is_active"],
    isOffer: json["is_offer"],
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
    "created_date": createdDate.toIso8601String(),
    "is_active": isActive,
    "is_offer": isOffer,
  };
}
