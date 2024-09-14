// To parse this JSON data, do
//
//     final storeCategoryModel = storeCategoryModelFromJson(jsonString);

import 'dart:convert';

StoreCategoryModel storeCategoryModelFromJson(String str) =>
    StoreCategoryModel.fromJson(json.decode(str));

String storeCategoryModelToJson(StoreCategoryModel data) =>
    json.encode(data.toJson());

class StoreCategoryModel {
  StoreCategoryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory StoreCategoryModel.fromJson(Map<String, dynamic> json) =>
      StoreCategoryModel(
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
    this.storeId,
    this.title,
    this.description,
    this.deliveryDate,
    this.shopType,
    this.parentCategoryId,
    this.image,
    this.featuredProducts, // Added property for featured products
  });

  String? storeId;
  String? title;
  String? description;
  String? deliveryDate;
  String? shopType;
  String? parentCategoryId;
  String? image;
  List<FeaturedProduct>? featuredProducts; // Added property for featured products

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        storeId: json["store_id"] == null ? null : json["store_id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        deliveryDate:
            json["delivery_date"] == null ? null : json["delivery_date"],
        shopType: json["shop_type"] == null ? null : json["shop_type"],
        parentCategoryId: json["parent_category_id"] == null
            ? null
            : json["parent_category_id"],
        image: json["image"] == null ? null : json["image"],
        featuredProducts: json["featured_products"] == null
            ? null
            : List<FeaturedProduct>.from(json["featured_products"]
                .map((x) => FeaturedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId == null ? null : storeId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "delivery_date": deliveryDate == null ? null : deliveryDate,
        "shop_type": shopType == null ? null : shopType,
        "parent_category_id":
            parentCategoryId == null ? null : parentCategoryId,
        "image": image == null ? null : image,
        "featured_products": featuredProducts == null
            ? null
            : List<dynamic>.from(featuredProducts!.map((x) => x.toJson())),
      };
}

class FeaturedProduct {
  FeaturedProduct({
    this.productId,
    this.name,
    this.sku,
    this.shortDescription,
    this.price,
    this.specialPrice,
    this.deliveryDate,
    this.type,
    this.shopType,
    this.salableQty,
    this.productImage,
  });

  String? productId;
  String? name;
  String? sku;
  String? shortDescription;
  String? price;
  int? specialPrice;
  String? deliveryDate;
  String? type;
  String? shopType;
  int? salableQty;
  String? productImage;

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) => FeaturedProduct(
        productId: json["product_id"] == null ? null : json["product_id"],
        name: json["name"] == null ? null : json["name"],
        sku: json["sku"] == null ? null : json["sku"],
        shortDescription:
            json["short_description"] == null ? null : json["short_description"],
        price: json["price"] == null ? null : json["price"],
        specialPrice: json["special_price"] == null ? null : json["special_price"],
        deliveryDate: json["delivery_date"] == null ? null : json["delivery_date"],
        type: json["type"] == null ? null : json["type"],
        shopType: json["shop_type"] == null ? null : json["shop_type"],
        salableQty: json["salable_qty"] == null ? null : json["salable_qty"],
        productImage: json["image"] == null ? null : json["image"],
      );

  get quantity => null;

  Map<String, dynamic> toJson() => {
        "product_id": productId == null ? null : productId,
        "name": name == null ? null : name,
        "sku": sku == null ? null : sku,
        "short_description": shortDescription == null ? null : shortDescription,
        "price": price == null ? null : price,
        "special_price": specialPrice == null ? null : specialPrice,
        "delivery_date": deliveryDate == null ? null : deliveryDate,
        "type": type == null ? null : type,
        "shop_type": shopType == null ? null : shopType,
        "salable_qty": salableQty == null ? null : salableQty,
        "image": productImage == null ? null : productImage,
      };
}

