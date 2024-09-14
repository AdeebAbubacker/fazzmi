// To parse this JSON data, do
//
//     final dealsStoreCategoryModel = dealsStoreCategoryModelFromJson(jsonString);

import 'dart:convert';

DealsStoreCategoryModel dealsStoreCategoryModelFromJson(String str) =>
    DealsStoreCategoryModel.fromJson(json.decode(str));

String dealsStoreCategoryModelToJson(DealsStoreCategoryModel data) =>
    json.encode(data.toJson());

class DealsStoreCategoryModel {
  DealsStoreCategoryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory DealsStoreCategoryModel.fromJson(Map<String, dynamic> json) =>
      DealsStoreCategoryModel(
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
  Datum({
    this.storeId,
    this.name,
    this.description,
    this.deliveryDate,
    this.shopType,
    this.parentCategoryId,
    this.image,
    this.dealsProducts,
  });

  String? storeId;
  String? name;
  String? description;
  String? deliveryDate;
  String? shopType;
  String? parentCategoryId;
  String? image;
  List<DealsProduct>? dealsProducts;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        storeId: json["store_id"],
        name: json["name"],
        description: json["description"],
        deliveryDate:
            json["delivery_date"],
        shopType: json["shop_type"],
        parentCategoryId: json["parent_category_id"],
        image: json["image"],
        dealsProducts: json["deals_products"] == null
            ? null
            : List<DealsProduct>.from(
                json["deals_products"].map((x) => DealsProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "name": name,
        "description": description,
        "delivery_date": deliveryDate,
        "shop_type": shopType,
        "parent_category_id":
            parentCategoryId,
        "image": image,
        "deals_products": dealsProducts == null
            ? null
            : List<dynamic>.from(dealsProducts!.map((x) => x.toJson())),
      };
}

class DealsProduct {
  DealsProduct({
    this.productId,
    this.name,
    this.sku,
    this.shortDescription,
    this.price,
    this.specialPrice,
    this.deliveryDate,
    this.type,
    this.shopType,
    this.parentCategoryId,
    this.image,
  });

  String? productId;
  String? name;
  String? sku;
  String? shortDescription;
  dynamic price;
  int? specialPrice;
  String? deliveryDate;
  String? type;
  String? shopType;
  String? parentCategoryId;
  String? image;

  factory DealsProduct.fromJson(Map<String, dynamic> json) => DealsProduct(
        productId: json["product_id"],
        name: json["name"],
        sku: json["sku"],
        shortDescription: json["short_description"],
        price: json["price"],
        specialPrice:
            json["special_price"],
        deliveryDate:
            json["delivery_date"],
        type: json["type"],
        shopType: json["shop_type"],
        parentCategoryId: json["parent_category_id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "name": name,
        "sku": sku,
        "short_description": shortDescription,
        "price": price,
        "special_price": specialPrice,
        "delivery_date": deliveryDate,
        "type": type,
        "shop_type": shopType,
        "parent_category_id":
            parentCategoryId,
        "image": image,
      };
}
