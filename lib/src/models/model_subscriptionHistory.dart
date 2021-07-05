// To parse this JSON data, do
//
//     final subscriptionHistory = subscriptionHistoryFromJson(jsonString);

import 'dart:convert';

SubscriptionHistory subscriptionHistoryFromJson(String str) => SubscriptionHistory.fromJson(json.decode(str));

String subscriptionHistoryToJson(SubscriptionHistory data) => json.encode(data.toJson());

class SubscriptionHistory {
  SubscriptionHistory({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) => SubscriptionHistory(
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
    this.subscriptionPlanId,
    this.subscriptionName,
    this.businessIds,
    this.validForMonth,
    this.perBillCost,
    this.perReceiptCost,
    this.perCashMemoCost,
    this.perDigitalBillCost,
    this.perDigitalReceiptCost,
    this.perDigitalCashMemoCost,
    this.totalSms,
    this.perSmsCost,
    this.isSubscriptionPlan,
    this.isPromotionalSmsPlan,
    this.isTransactionalSmsPlan,
    this.isAddOnPlan,
    this.cost,
    this.purchaseDate,
    this.expiryDate,
    this.transactionId,
    this.payuTransactionId,
    this.invoiceNo,
    this.mode,
    this.chequeNo,
    this.bankTransactionId,
    this.merchantId,
    this.subscriptionBillUrl,
  });

  int id;
  String subscriptionPlanId;
  String subscriptionName;
  String businessIds;
  String validForMonth;
  String perBillCost;
  String perReceiptCost;
  String perCashMemoCost;
  String perDigitalBillCost;
  String perDigitalReceiptCost;
  String perDigitalCashMemoCost;
  String totalSms;
  String perSmsCost;
  bool isSubscriptionPlan;
  bool isPromotionalSmsPlan;
  bool isTransactionalSmsPlan;
  bool isAddOnPlan;
  double cost;
  String purchaseDate;
  String expiryDate;
  String transactionId;
  String payuTransactionId;
  String invoiceNo;
  String mode;
  String chequeNo;
  String bankTransactionId;
  int merchantId;
  String subscriptionBillUrl;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    subscriptionPlanId: json["subscription_plan_id"],
    subscriptionName: json["subscription_name"],
    businessIds: json["business_ids"],
    validForMonth: json["valid_for_month"] == null ? null : json["valid_for_month"],
    perBillCost: json["per_bill_cost"] == null ? null : json["per_bill_cost"],
    perReceiptCost: json["per_receipt_cost"] == null ? null : json["per_receipt_cost"],
    perCashMemoCost: json["per_cash_memo_cost"] == null ? null : json["per_cash_memo_cost"],
    perDigitalBillCost: json["per_digital_bill_cost"] == null ? null : json["per_digital_bill_cost"],
    perDigitalReceiptCost: json["per_digital_receipt_cost"] == null ? null : json["per_digital_receipt_cost"],
    perDigitalCashMemoCost: json["per_digital_cash_memo_cost"] == null ? null : json["per_digital_cash_memo_cost"],
    totalSms: json["total_sms"] == null ? null : json["total_sms"],
    perSmsCost: json["per_sms_cost"] == null ? null : json["per_sms_cost"],
    isSubscriptionPlan: json["is_subscription_plan"],
    isPromotionalSmsPlan: json["is_promotional_sms_plan"],
    isTransactionalSmsPlan: json["is_transactional_sms_plan"],
    isAddOnPlan: json["is_add_on_plan"],
    cost: json["cost"].toDouble(),
    purchaseDate: json["purchase_date"],
    expiryDate: json["expiry_date"] == null ? null : json["expiry_date"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    payuTransactionId: json["payu_transaction_id"] == null ? null : json["payu_transaction_id"],
    invoiceNo: json["invoice_no"] == null ? null : json["invoice_no"],
    mode: json["mode"] == null ? null : json["mode"],
    chequeNo: json["cheque_no"] == null ? null : json["cheque_no"],
    bankTransactionId: json["bank_transaction_id"] == null ? null : json["bank_transaction_id"],
    merchantId: json["merchant_id"],
    subscriptionBillUrl: json["subscription_bill_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subscription_plan_id": subscriptionPlanId,
    "subscription_name": subscriptionName,
    "business_ids": businessIds,
    "valid_for_month": validForMonth == null ? null : validForMonth,
    "per_bill_cost": perBillCost == null ? null : perBillCost,
    "per_receipt_cost": perReceiptCost == null ? null : perReceiptCost,
    "per_cash_memo_cost": perCashMemoCost == null ? null : perCashMemoCost,
    "per_digital_bill_cost": perDigitalBillCost == null ? null : perDigitalBillCost,
    "per_digital_receipt_cost": perDigitalReceiptCost == null ? null : perDigitalReceiptCost,
    "per_digital_cash_memo_cost": perDigitalCashMemoCost == null ? null : perDigitalCashMemoCost,
    "total_sms": totalSms == null ? null : totalSms,
    "per_sms_cost": perSmsCost == null ? null : perSmsCost,
    "is_subscription_plan": isSubscriptionPlan,
    "is_promotional_sms_plan": isPromotionalSmsPlan,
    "is_transactional_sms_plan": isTransactionalSmsPlan,
    "is_add_on_plan": isAddOnPlan,
    "cost": cost,
    "purchase_date": purchaseDate,
    "expiry_date": expiryDate == null ? null : expiryDate,
    "transaction_id": transactionId == null ? null : transactionId,
    "payu_transaction_id": payuTransactionId == null ? null : payuTransactionId,
    "invoice_no": invoiceNo == null ? null : invoiceNo,
    "mode": mode == null ? null : mode,
    "cheque_no": chequeNo == null ? null : chequeNo,
    "bank_transaction_id": bankTransactionId == null ? null : bankTransactionId,
    "merchant_id": merchantId,
    "subscription_bill_url": subscriptionBillUrl,
  };
}
