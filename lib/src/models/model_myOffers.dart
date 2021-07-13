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
    this.merchantState,
    this.merchantDistrict,
    this.merchantCity,
    this.merchantArea,
    this.offerAmount,
    this.cout,
    this.merchantUser,
    this.merchantBusinessId,
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
  dynamic merchantState;
  dynamic merchantDistrict;
  dynamic merchantCity;
  dynamic merchantArea;
  String offerAmount;
  int cout;
  int merchantUser;
  int merchantBusinessId;

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
    merchantState: json["merchant_state"],
    merchantDistrict: json["merchant_district"],
    merchantCity: json["merchant_city"],
    merchantArea: json["merchant_area"],
    offerAmount: json["offer_amount"],
    cout: json["cout"],
    merchantUser: json["merchant_user"] == null ? null : json["merchant_user"],
    merchantBusinessId: json["merchant_business_id"],
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
    "merchant_state": merchantState,
    "merchant_district": merchantDistrict,
    "merchant_city": merchantCity,
    "merchant_area": merchantArea,
    "offer_amount": offerAmount,
    "cout": cout,
    "merchant_user": merchantUser == null ? null : merchantUser,
    "merchant_business_id": merchantBusinessId,
  };
}
