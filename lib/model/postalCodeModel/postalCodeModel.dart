// To parse this JSON data, do
//
//     final postalCodeModel = postalCodeModelFromJson(jsonString);

import 'dart:convert';

PostalCodeModel postalCodeModelFromJson(String str) =>
    PostalCodeModel.fromJson(json.decode(str));

String postalCodeModelToJson(PostalCodeModel data) =>
    json.encode(data.toJson());

class PostalCodeModel {
  PostalCodeModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory PostalCodeModel.fromJson(Map<String, dynamic> json) =>
      PostalCodeModel(
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
    this.id,
    this.postcode,
  });

  String? id;
  String? postcode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        postcode: json["postcode"] == null ? null : json["postcode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "postcode": postcode == null ? null : postcode,
      };
}
