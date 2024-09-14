import 'dart:convert';

HomepageCategoryModel homepageCategoryModelFromJson(String str) =>
    HomepageCategoryModel.fromJson(json.decode(str));

String homepageCategoryModelToJson(HomepageCategoryModel data) =>
    json.encode(data.toJson());

class HomepageCategoryModel {
  HomepageCategoryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory HomepageCategoryModel.fromJson(Map<String, dynamic> json) =>
      HomepageCategoryModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.categoryId,
    this.categoryTitle,
    this.categoryImage,
  });

  String? categoryId;
  String? categoryTitle;
  String? categoryImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["category_id"],
        categoryTitle: json["category_title"],
        categoryImage: json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_title": categoryTitle,
        "category_image": categoryImage,
      };
}
