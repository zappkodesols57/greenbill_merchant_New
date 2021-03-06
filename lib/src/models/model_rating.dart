// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';

Rating ratingFromJson(String str) => Rating.fromJson(json.decode(str));

String ratingToJson(Rating data) => json.encode(data.toJson());

class Rating {
  Rating({
    this.status,
    this.data,
    this.count,
  });

  String status;
  List<Datum> data;
  int count;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    count: json["merchant_rating_count"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "merchant_rating_count": count,
  };
}

class Datum {
  Datum({
    this.id,
    this.userId,
    this.mobileNo,
    this.billAmount,
    this.billDate,
    this.invoiceNo,
    this.storeFeedback,
    this.merchantReplay,
    this.rating,
    this.ratingId
  });

  int id;
  String userId;
  String storeFeedback;
  String merchantReplay;
  String mobileNo;
  String billAmount;
  String billDate;
  String invoiceNo;
  String rating;
  String ratingId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    mobileNo: json["mobile_no"],
    billAmount: json["bill_amount"],
    billDate: json["bill_date"],
    invoiceNo: json["invoice_no"],
    rating: json["rating"],
    ratingId: json["rating_id"],
    storeFeedback: json["store_feedback"],
    merchantReplay: json["merchant_reply"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "mobile_no": mobileNo,
    "bill_amount": billAmount,
    "bill_date": billDate,
    "invoice_no": invoiceNo,
    "rating": rating,
    "rating_id": ratingId,
    "store_feedback": storeFeedback,
    "merchant_reply": merchantReplay,
  };
}


