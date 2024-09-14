// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel? notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel? data) =>
    json.encode(data!.toJson());

class NotificationModel {
  NotificationModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum?>? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : json["data"] == null
                ? []
                : List<Datum?>.from(
                    json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data == null
            ? []
            : data == null
                ? []
                : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class Datum {
  Datum({this.notificationsId, this.title, this.content, this.created
      // this.customerId,
      // this.created,
      // this.updated,
      });

  String? notificationsId;
  String? title;
  String? content;
  // dynamic customerId;
  dynamic created;
  // DateTime? updated;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        notificationsId: json["notifications_id"],
        title: json["title"],
        content: json["content"],
        // customerId: json["customer_id"],
        created: json["created"],
        // updated: json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "notifications_id": notificationsId,
        "title": title,
        "content": content,
        // "customer_id": customerId,
        "created": created,
        // "updated": updated,
      };
}
