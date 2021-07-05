// To parse this JSON data, do
//
//     final offersList = offersListFromJson(jsonString);

import 'dart:convert';

OffersListModel offersListFromJson(String str) => OffersListModel.fromJson(json.decode(str));

String offersListToJson(OffersListModel data) => json.encode(data.toJson());

class OffersListModel {
  OffersListModel({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory OffersListModel.fromJson(Map<String, dynamic> json) => OffersListModel(
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
    this.merchantUser,
    this.merchantBusinessId,
    this.mBusinessLogo,
    this.mBusinessName,
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
  String offerBusinessCategory;
  DateTime createdDate;
  String offerPanel;
  int merchantUser;
  int merchantBusinessId;
  String mBusinessLogo;
  String mBusinessName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    offerName: json["offer_name"],
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
    merchantUser: json["merchant_user"],
    merchantBusinessId: json["merchant_business_id"],
    mBusinessLogo: json["m_business_logo"],
    mBusinessName: json["m_business_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "offer_name": offerName,
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
    "merchant_user": merchantUser,
    "merchant_business_id": merchantBusinessId,
    "m_business_logo": mBusinessLogo,
    "m_business_name": mBusinessName,
  };
}
