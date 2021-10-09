// To parse this JSON data, do
//
//     final myOffer = myOfferFromJson(jsonString);

import 'dart:convert';

MyOffer myOfferFromJson(String str) => MyOffer.fromJson(json.decode(str));

String myOfferToJson(MyOffer data) => json.encode(data.toJson());

class MyOffer {
  MyOffer({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory MyOffer.fromJson(Map<String, dynamic> json) => MyOffer(
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
    this.offerName,
    this.offerCaption,
    this.validFrom,
    this.validThrough,
    this.offerImage,
    this.disapprovedReason,
    this.status,
    this.offerType,
    this.offerBusinessCategory,
    this.createdDate,
    this.offerPanel,
    this.oBusinessName,
    this.merchantBusinessName,
    this.checkBusinessCategory,
    this.customerCity,
    this.customerState,
    this.customerArea,
    this.offerAmount,
    this.cout,
    this.totalUser,
    this.totalAmt,
    this.activeStatus,
  });

  int id;
  String offerName;
  String offerCaption;
  String validFrom;
  String validThrough;
  String offerImage;
  String disapprovedReason;
  String status;
  String offerType;
  dynamic offerBusinessCategory;
  DateTime createdDate;
  String offerPanel;
  dynamic oBusinessName;
  dynamic merchantBusinessName;
  dynamic checkBusinessCategory;
  dynamic customerCity;
  dynamic customerState;
  dynamic customerArea;
  String offerAmount;
  int cout;
  int totalUser;
  int totalAmt;
  bool activeStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    offerName: json["offer_name"] == null ? null : json["offer_name"],
    offerCaption: json["offer_caption"],
    validFrom: json["valid_from"],
    validThrough: json["valid_through"],
    offerImage: json["offer_image"],
    disapprovedReason: json["disapproved_reason"],
    status: json["status"],
    offerType: json["Offer_type"],
    offerBusinessCategory: json["offer_business_category"],
    createdDate: DateTime.parse(json["created_date"]),
    offerPanel: json["offer_panel"],
    oBusinessName: json["o_business_name"],
    merchantBusinessName: json["merchant_business_name"],
    checkBusinessCategory: json["check_business_category"],
    customerCity: json["customer_city"],
    customerState: json["customer_state"],
    customerArea: json["customer_area"],
    offerAmount: json["offer_amount"],
    cout: json["cout"],
    activeStatus: json["active_status"],
    totalUser: json["total_users"],
    totalAmt: json["total_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "offer_name": offerName == null ? null : offerName,
    "offer_caption": offerCaption,
    "valid_from": validFrom,
    "valid_through": validThrough,
    "offer_image": offerImage,
    "disapproved_reason": disapprovedReason,
    "status": status,
    "Offer_type": offerType,
    "offer_business_category": offerBusinessCategory,
    "created_date": createdDate.toIso8601String(),
    "offer_panel": offerPanel,
    "o_business_name": oBusinessName,
    "merchant_business_name": merchantBusinessName,
    "check_business_category": checkBusinessCategory,
    "customer_city": customerCity,
    "customer_state": customerState,
    "customer_area": customerArea,
    "offer_amount": offerAmount,
    "cout": cout,
    "active_status": activeStatus,
    "total_users": totalUser,
    "total_amount": totalAmt,

  };
}
