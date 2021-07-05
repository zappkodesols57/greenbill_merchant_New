// To parse this JSON data, do
//
//     final hSupportData = hSupportDataFromJson(jsonString);

import 'dart:convert';

HSupportData hSupportDataFromJson(String str) => HSupportData.fromJson(json.decode(str));

String hSupportDataToJson(HSupportData data) => json.encode(data.toJson());

class HSupportData {
  HSupportData({
    this.status,
    this.faqs,
  });

  String status;
  List<Faq> faqs;

  factory HSupportData.fromJson(Map<String, dynamic> json) => HSupportData(
    status: json["status"],
    faqs: List<Faq>.from(json["faqs"].map((x) => Faq.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "faqs": List<dynamic>.from(faqs.map((x) => x.toJson())),
  };
}

class Faq {
  Faq({
    this.id,
    this.userName,
    this.moduleName,
    this.question,
    this.answer,
  });

  int id;
  String userName;
  String moduleName;
  String question;
  String answer;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    id: json["id"],
    userName: json["user_name"],
    moduleName: json["module_name"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "module_name": moduleName,
    "question": question,
    "answer": answer,
  };
}
