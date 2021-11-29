// To parse this JSON data, do
//
//     final allCouponsList = allCouponsListFromJson(jsonString);

import 'dart:convert';

AllCouponsList allCouponsListFromJson(String str) => AllCouponsList.fromJson(json.decode(str));

String allCouponsListToJson(AllCouponsList data) => json.encode(data.toJson());

class AllCouponsList {
  AllCouponsList({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory AllCouponsList.fromJson(Map<String, dynamic> json) => AllCouponsList(
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
    this.merchantBusinessId,
    this.couponName,
    this.validFrom,
    this.validThrough,
    this.couponCode,
    this.couponValue,
    this.greenPoint,
    this.couponLogo,
    this.couponRedeem,
    this.couponCaption,
    this.couponBackgroundColor,
    this.couponValidForUser,
    this.amountIn,
    this.cout,
    this.merchantId,
    this.totalUser,
    this.totalAmt,
    this.expired,
  });

  int id;
  String merchantBusinessId;
  String couponName;
  String validFrom;
  String validThrough;
  String couponCode;
  String couponValue;
  String greenPoint;
  String couponLogo;
  String couponRedeem;
  String couponCaption;
  String couponBackgroundColor;
  String couponValidForUser;
  int cout;
  String amountIn;
  int merchantId;
  String totalUser;
  int totalAmt;
  bool expired;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    merchantBusinessId: json["merchant_business_id"],
    couponName: json["coupon_name"],
    validFrom: json["valid_from"],
    validThrough: json["valid_through"],
    couponCode: json["coupon_code"],
    couponValue: json["coupon_value"],
    greenPoint: json["green_point"],
    couponLogo: json["coupon_logo"],
    cout: json["cout"],
    couponRedeem: json["coupon_redeem"],
    couponCaption: json["coupon_caption"],
    couponBackgroundColor: json["coupon_background_color"],
    couponValidForUser: json["coupon_valid_for_user"],
    amountIn: json["amount_in"],
    merchantId: json["merchant_id"],
    totalUser: json["total_customers"],
    totalAmt: json["total_amount"],
    expired: json["expired"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "merchant_business_id": merchantBusinessId,
    "coupon_name": couponName,
    "valid_from": validFrom,
    "valid_through": validThrough,
    "coupon_code": couponCode,
    "coupon_value": couponValue,
    "green_point": greenPoint,
    "coupon_logo": couponLogo,
    "cout": cout,
    "coupon_redeem": couponRedeem,
    "coupon_caption": couponCaption,
    "coupon_background_color": couponBackgroundColor,
    "coupon_valid_for_user": couponValidForUser,
    "amount_in": amountIn,
    "merchant_id": merchantId,
    "total_customers": totalUser,
    "total_amount": totalAmt,
    "expired": expired,
  };
}
