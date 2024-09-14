// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) =>
    SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) =>
    json.encode(data.toJson());

class SubCategoryModel {
  SubCategoryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  Data? data;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.mainCategoryId,
    this.mainCategoryTitle,
    this.mainCategoryImage,
    this.storeId,
    this.storeName,
    this.parentCategoryId,
    this.storeBanner,
    this.mainCategoryList,
  });

  String? mainCategoryId;
  String? mainCategoryTitle;
  String? mainCategoryImage;
  String? storeId;
  String? storeName;
  String? parentCategoryId;
  String? storeBanner;
  List<MainCategoryList>? mainCategoryList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mainCategoryId:
            json["main_category_id"] == null ? null : json["main_category_id"],
        mainCategoryTitle: json["main_category_title"] == null
            ? null
            : json["main_category_title"],
        mainCategoryImage: json["main_category_image"] == null
            ? null
            : json["main_category_image"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        storeName: json["store_name"] == null ? null : json["store_name"],
        parentCategoryId: json["parent_category_id"] == null
            ? null
            : json["parent_category_id"],
        storeBanner: json["store_banner"] == null ? null : json["store_banner"],
        mainCategoryList: json["main_category_list"] == null
            ? null
            : List<MainCategoryList>.from(json["main_category_list"]
                .map((x) => MainCategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_category_id": mainCategoryId == null ? null : mainCategoryId,
        "main_category_title":
            mainCategoryTitle == null ? null : mainCategoryTitle,
        "main_category_image":
            mainCategoryImage == null ? null : mainCategoryImage,
        "store_id": storeId == null ? null : storeId,
        "store_name": storeName == null ? null : storeName,
        "parent_category_id":
            parentCategoryId == null ? null : parentCategoryId,
        "store_banner": storeBanner == null ? null : storeBanner,
        "main_category_list": mainCategoryList == null
            ? null
            : List<dynamic>.from(mainCategoryList!.map((x) => x.toJson())),
      };
}

class MainCategoryList {
  MainCategoryList({
    this.categoryId,
    this.id,
    this.categoryTitle,
    this.parentCategoryId,
    this.categoryImage,
  });

  String? categoryId;
  int? id;
  String? categoryTitle;
  String? parentCategoryId;
  String? categoryImage;

  factory MainCategoryList.fromJson(Map<String, dynamic> json) =>
      MainCategoryList(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        id: json["id"] == null ? null : json["id"],
        categoryTitle:
            json["category_title"] == null ? null : json["category_title"],
        parentCategoryId: json["parent_category_id"] == null
            ? null
            : json["parent_category_id"],
        categoryImage:
            json["category_image"] == null ? null : json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId == null ? null : categoryId,
        "id": id == null ? null : id,
        "category_title": categoryTitle == null ? null : categoryTitle,
        "parent_category_id":
            parentCategoryId == null ? null : parentCategoryId,
        "category_image": categoryImage == null ? null : categoryImage,
      };
}
