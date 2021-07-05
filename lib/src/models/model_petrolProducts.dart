// To parse this JSON data, do
//
//     final petrolProducts = petrolProductsFromJson(jsonString);

import 'dart:convert';

PetrolProducts petrolProductsFromJson(String str) => PetrolProducts.fromJson(json.decode(str));

String petrolProductsToJson(PetrolProducts data) => json.encode(data.toJson());

class PetrolProducts {
  PetrolProducts({
    this.status,
    this.data,
  });

  String status;
  List<Datum> data;

  factory PetrolProducts.fromJson(Map<String, dynamic> json) => PetrolProducts(
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
    this.productName,
    this.productCost,
    this.productAvailability,
  });

  int id;
  String mBusinessId;
  String productName;
  String productCost;
  String productAvailability;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mBusinessId: json["m_business_id"],
    productName: json["product_name"],
    productCost: json["product_cost"],
    productAvailability: json["product_availability"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "m_business_id": mBusinessId,
    "product_name": productName,
    "product_cost": productCost,
    "product_availability": productAvailability,
  };
}
