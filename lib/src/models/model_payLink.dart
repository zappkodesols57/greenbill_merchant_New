// To parse this JSON data, do
//
//     final payLinks = payLinksFromJson(jsonString);

import 'dart:convert';

PayLinks payLinksFromJson(String str) => PayLinks.fromJson(json.decode(str));

String payLinksToJson(PayLinks data) => json.encode(data.toJson());

class PayLinks {
  PayLinks({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory PayLinks.fromJson(Map<String, dynamic> json) => PayLinks(
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
    this.mBusinessId,
    this.mobileNo,
    this.name,
    this.email,
    this.amount,
    this.description,
    this.paymentDone,
    this.paymentDate,
    this.paymentUrl,
    this.createdAt,
  });

  int id;
  String mBusinessId;
  String mobileNo;
  String name;
  String email;
  String amount;
  String description;
  bool paymentDone;
  String paymentDate;
  String paymentUrl;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mBusinessId: json["m_business_id"],
    mobileNo: json["mobile_no"],
    name: json["name"],
    email: json["email"],
    amount: json["amount"],
    description: json["description"],
    paymentDone: json["payment_done"],
    paymentDate: json["payment_date"],
    paymentUrl: json["payment_url"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "m_business_id": mBusinessId,
    "mobile_no": mobileNo,
    "name": name,
    "email": email,
    "amount": amount,
    "description": description,
    "payment_done": paymentDone,
    "payment_date": paymentDate,
    "payment_url": paymentUrl,
    "created_at": createdAt.toIso8601String(),
  };
}
