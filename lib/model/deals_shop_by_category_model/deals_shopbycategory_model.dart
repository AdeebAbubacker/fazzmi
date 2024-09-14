// To parse this JSON data, do
//
//     final dealsShopBycategoryModel = dealsShopBycategoryModelFromJson(jsonString);

import 'dart:convert';

DealsShopBycategoryModel dealsShopBycategoryModelFromJson(String str) =>
    DealsShopBycategoryModel.fromJson(json.decode(str));

String dealsShopBycategoryModelToJson(DealsShopBycategoryModel data) =>
    json.encode(data.toJson());

class DealsShopBycategoryModel {
  DealsShopBycategoryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  Data? data;

  factory DealsShopBycategoryModel.fromJson(Map<String, dynamic> json) =>
      DealsShopBycategoryModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.mainCategoryId,
    this.mainCategoryTitle,
    this.mainCategoryList,
  });

  String? mainCategoryId;
  String? mainCategoryTitle;
  List<MainCategoryList>? mainCategoryList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mainCategoryId: json["main_category_id"],
        mainCategoryTitle: json["main_category_title"],
        mainCategoryList: List<MainCategoryList>.from(json["main_category_list"]
            .map((x) => MainCategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_category_id": mainCategoryId,
        "main_category_title": mainCategoryTitle,
        "main_category_list":
            List<dynamic>.from(mainCategoryList!.map((x) => x.toJson())),
      };
}

class MainCategoryList {
  MainCategoryList(
      {this.categoryId,
      this.categoryTitle,
      this.categoryImage,
      this.parent_category_id});

  String? categoryId;
  String? categoryTitle;
  String? categoryImage;
  String? parent_category_id;

  factory MainCategoryList.fromJson(Map<String, dynamic> json) =>
      MainCategoryList(
        categoryId: json["category_id"],
        parent_category_id: json["parent_category_id"],
        categoryTitle: json["category_title"],
        categoryImage: json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "parent_category_id": parent_category_id,
        "category_title": categoryTitle,
        "category_image": categoryImage,
      };
}
