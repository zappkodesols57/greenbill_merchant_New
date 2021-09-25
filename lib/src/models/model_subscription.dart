// To parse this JSON data, do
//
//     final subscription = subscriptionFromJson(jsonString);

import 'dart:convert';

Subscription subscriptionFromJson(String str) => Subscription.fromJson(json.decode(str));

String subscriptionToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
  Subscription({
    this.status,
    this.totalAmountAvilable,
    this.totalPromotionalSmsAvilable,
    this.totalTransactionalSmsAvilable,
    this.subscriptionData,
    this.promotionalSmsData,
    this.transactionalSmsData,
  });

  String status;
  double totalAmountAvilable;
  int totalPromotionalSmsAvilable;
  int totalTransactionalSmsAvilable;
  List<SubscriptionDatum> subscriptionData;
  List<PromotionalSmsDatum> promotionalSmsData;
  List<TransactionalSmsDatum> transactionalSmsData;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    status: json["status"],
    totalAmountAvilable: json["total_amount_avilable"],
    totalPromotionalSmsAvilable: json["total_promotional_sms_avilable"],
    totalTransactionalSmsAvilable: json["total_transactional_sms_avilable"],
    subscriptionData: List<SubscriptionDatum>.from(json["subscription_data"].map((x) => SubscriptionDatum.fromJson(x))),
    promotionalSmsData: List<PromotionalSmsDatum>.from(json["promotional_sms_data"].map((x) => PromotionalSmsDatum.fromJson(x))),
    transactionalSmsData: List<TransactionalSmsDatum>.from(json["transactional_sms_data"].map((x) => TransactionalSmsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "total_amount_avilable": totalAmountAvilable,
    "total_promotional_sms_avilable": totalPromotionalSmsAvilable,
    "total_transactional_sms_avilable": totalTransactionalSmsAvilable,
    "subscription_data": List<dynamic>.from(subscriptionData.map((x) => x.toJson())),
    "promotional_sms_data": List<dynamic>.from(promotionalSmsData.map((x) => x.toJson())),
    "transactional_sms_data": List<dynamic>.from(transactionalSmsData.map((x) => x.toJson())),
  };
}

class PromotionalSmsDatum {
  PromotionalSmsDatum({
    this.promotionalSmsSubscriptionName,
    this.promotionalSmsPurchaseDate,
    this.promotionalSmsPurchaseCost,
    this.promotionalSmsTotalSms,
    this.promotionalSmsPerSmsCost,
    this.promotionalSmsTotalSmsAvilable,
  });

  String promotionalSmsSubscriptionName;
  String promotionalSmsPurchaseDate;
  double promotionalSmsPurchaseCost;
  String promotionalSmsTotalSms;
  String promotionalSmsPerSmsCost;
  double promotionalSmsTotalSmsAvilable;

  factory PromotionalSmsDatum.fromJson(Map<String, dynamic> json) => PromotionalSmsDatum(
    promotionalSmsSubscriptionName: json["promotional_sms_subscription_name"],
    promotionalSmsPurchaseDate: json["promotional_sms_purchase_date"],
    promotionalSmsPurchaseCost: json["promotional_sms_purchase_cost"] == null ? 0 :json["promotional_sms_purchase_cost"],
    promotionalSmsTotalSms: json["promotional_sms_total_sms"],
    promotionalSmsPerSmsCost: json["promotional_sms_per_sms_cost"],
    promotionalSmsTotalSmsAvilable: json["promotional_sms_total_sms_avilable"] == null ? 0 :json["promotional_sms_total_sms_avilable"],
  );

  Map<String, dynamic> toJson() => {
    "promotional_sms_subscription_name": promotionalSmsSubscriptionName,
    "promotional_sms_purchase_date": promotionalSmsPurchaseDate,
    "promotional_sms_purchase_cost": promotionalSmsPurchaseCost,
    "promotional_sms_total_sms": promotionalSmsTotalSms,
    "promotional_sms_per_sms_cost": promotionalSmsPerSmsCost,
    "promotional_sms_total_sms_avilable": promotionalSmsTotalSmsAvilable,
  };
}

class SubscriptionDatum {
  SubscriptionDatum({
    this.perBillCost,
    this.perReceiptCost,
    this.perCashMemoCost,
    this.perDigitalBillCost,
    this.perDigitalReceiptCost,
    this.perDigitalCashMemoCost,
    this.subscriptionName,
    this.purchaseDate,
    this.purchaseCost,
    this.totalAmountAvilable,
    this.expiryDate,
    this.validForMonth,
    this.noOfUsers,
  });

  String perBillCost;
  String perReceiptCost;
  String perCashMemoCost;
  String perDigitalBillCost;
  String perDigitalReceiptCost;
  String perDigitalCashMemoCost;
  String subscriptionName;
  String purchaseDate;
  double purchaseCost;
  double totalAmountAvilable;
  String expiryDate;
  String validForMonth;
  String noOfUsers;

  factory SubscriptionDatum.fromJson(Map<String, dynamic> json) => SubscriptionDatum(
    perBillCost: json["per_bill_cost"],
    perReceiptCost: json["per_receipt_cost"],
    perCashMemoCost: json["per_cash_memo_cost"],
    perDigitalBillCost: json["per_digital_bill_cost"],
    perDigitalReceiptCost: json["per_digital_receipt_cost"],
    perDigitalCashMemoCost: json["per_digital_cash_memo_cost"],
    subscriptionName: json["subscription_name"],
    purchaseDate: json["purchase_date"],
    purchaseCost: json["purchase_cost"].toDouble(),
    totalAmountAvilable: json["total_amount_avilable"] == null ? 0 : json["total_amount_avilable"],
    expiryDate: json["expiry_date"],
    validForMonth: json["valid_for_month"] ,
    noOfUsers: json["number_of_users"] ,
  );

  Map<String, dynamic> toJson() => {
    "per_bill_cost": perBillCost,
    "per_receipt_cost": perReceiptCost,
    "per_cash_memo_cost": perCashMemoCost,
    "per_digital_bill_cost": perDigitalBillCost,
    "per_digital_receipt_cost": perDigitalReceiptCost,
    "per_digital_cash_memo_cost": perDigitalCashMemoCost,
    "subscription_name": subscriptionName,
    "purchase_date": purchaseDate,
    "purchase_cost": purchaseCost,
    "total_amount_avilable": totalAmountAvilable,
    "expiry_date": expiryDate,
    "valid_for_month": validForMonth,
    "number_of_users": noOfUsers,
  };
}

class TransactionalSmsDatum {
  TransactionalSmsDatum({
    this.transactionalSmsSubscriptionName,
    this.transactionalSmsPurchaseDate,
    this.transactionalSmsPurchaseCost,
    this.transactionalSmsTotalSms,
    this.transactionalSmsPerSmsCost,
    this.transactionalSmsTotalSmsAvilable,
  });

  String transactionalSmsSubscriptionName;
  String transactionalSmsPurchaseDate;
  double transactionalSmsPurchaseCost;
  String transactionalSmsTotalSms;
  String transactionalSmsPerSmsCost;
  double transactionalSmsTotalSmsAvilable;

  factory TransactionalSmsDatum.fromJson(Map<String, dynamic> json) => TransactionalSmsDatum(
    transactionalSmsSubscriptionName: json["transactional_sms_subscription_name"],
    transactionalSmsPurchaseDate: json["transactional_sms_purchase_date"],
    transactionalSmsPurchaseCost: json["transactional_sms_purchase_cost"] == null ? 0 :json["transactional_sms_purchase_cost"],
    transactionalSmsTotalSms: json["transactional_sms_total_sms"],
    transactionalSmsPerSmsCost: json["transactional_sms_per_sms_cost"],
    transactionalSmsTotalSmsAvilable: json["transactional_sms_total_sms_avilable"] == null ? 0 :json["transactional_sms_total_sms_avilable"],
  );

  Map<String, dynamic> toJson() => {
    "transactional_sms_subscription_name": transactionalSmsSubscriptionName,
    "transactional_sms_purchase_date": transactionalSmsPurchaseDate,
    "transactional_sms_purchase_cost": transactionalSmsPurchaseCost,
    "transactional_sms_total_sms": transactionalSmsTotalSms,
    "transactional_sms_per_sms_cost": transactionalSmsPerSmsCost,
    "transactional_sms_total_sms_avilable": transactionalSmsTotalSmsAvilable,
  };
}
