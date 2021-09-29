import 'dart:convert';

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    this.status,
    this.data,
  });

  String status;
  List<Bell> data;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    status: json["status"],
    data: List<Bell>.from(json["data"].map((x) => Bell.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Bell {
  Bell({
    this.id,
    this.name,
    this.noticeTitle,
    this.message,
    this.createdAt,
    this.image,

  });

  int id;
  String name;
  String noticeTitle;
  String message;
  String createdAt;
  String image;


  factory Bell.fromJson(Map<String, dynamic> json) => Bell(
    id: json["id"],
    name: json["name"],
    noticeTitle: json["notice_title"],
    message: json["message"],
    createdAt: json["created_at"],
    image: json["notice_file"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "notice_title": noticeTitle,
    "message": message,
    "created_at": createdAt,
    "notice_file": image,

  };
}


