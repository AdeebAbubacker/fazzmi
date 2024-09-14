// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  FaqModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.faqId,
    this.title,
    this.comment,
    this.sortOrder,
    this.created,
    this.updated,
  });

  String? faqId;
  String? title;
  String? comment;
  String? sortOrder;
  DateTime? created;
  DateTime? updated;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        faqId: json["faq_id"] == null ? null : json["faq_id"],
        title: json["title"] == null ? null : json["title"],
        comment: json["comment"] == null ? null : json["comment"],
        sortOrder: json["sort_order"] == null ? null : json["sort_order"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "faq_id": faqId == null ? null : faqId,
        "title": title == null ? null : title,
        "comment": comment == null ? null : comment,
        "sort_order": sortOrder == null ? null : sortOrder,
        "created": created == null ? null : created!.toIso8601String(),
        "updated": updated == null ? null : updated!.toIso8601String(),
      };
}
