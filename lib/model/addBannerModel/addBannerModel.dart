// To parse this JSON data, do
//
//     final addBannerModel = addBannerModelFromJson(jsonString);

import 'dart:convert';

AddBannerModel addBannerModelFromJson(String str) =>
    AddBannerModel.fromJson(json.decode(str));

String addBannerModelToJson(AddBannerModel data) => json.encode(data.toJson());

class AddBannerModel {
  AddBannerModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory AddBannerModel.fromJson(Map<String, dynamic> json) => AddBannerModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.title,
      this.image,
      this.sortOrder,
      this.store,
      this.storeName,
      this.parentCategoryId,
      this.shop_type});

  String? title;
  String? image;
  String? sortOrder;
  String? store;
  String? storeName;
  String? shop_type;
  dynamic parentCategoryId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        shop_type: json["shop_type"],
        image: json["image"],
        sortOrder: json["sort_order"],
        store: json["store"],
        storeName: json["store_name"],
        parentCategoryId: json["parent_category_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "shop_type": shop_type,
        "image": image,
        "sort_order": sortOrder,
        "store": store,
        "store_name": storeName,
        "parent_category_id": parentCategoryId,
      };
}
