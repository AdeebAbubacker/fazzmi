// To parse this JSON data, do
//
//     final storeSubCategoryModel = storeSubCategoryModelFromJson(jsonString);

import 'dart:convert';

StoreSubCategoryModel storeSubCategoryModelFromJson(String str) =>
    StoreSubCategoryModel.fromJson(json.decode(str));

String storeSubCategoryModelToJson(StoreSubCategoryModel data) =>
    json.encode(data.toJson());

class StoreSubCategoryModel {
  StoreSubCategoryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  Data? data;

  factory StoreSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      StoreSubCategoryModel(
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
    this.storeId,
    this.name,
    this.description,
    this.deliveryDate,
    this.shopType,
    this.minOrderAmount,
    this.image,
    this.storeCategory,
    this.featuredProducts,
  });

  int? storeId;
  String? name;
  String? description;
  String? deliveryDate;
  String? shopType;
  String? minOrderAmount;
  String? image;
  List<StoreCategory>? storeCategory;
  List<FeaturedProduct>? featuredProducts;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeId: json["store_id"] == null ? null : json["store_id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        deliveryDate:
            json["delivery_date"] == null ? null : json["delivery_date"],
        shopType: json["shop_type"] == null ? null : json["shop_type"],
        minOrderAmount:
            json["min_order_amount"] == null ? null : json["min_order_amount"],
        image: json["image"] == null ? null : json["image"],
        storeCategory: json["store_category"] == null
            ? null
            : List<StoreCategory>.from(
                json["store_category"].map((x) => StoreCategory.fromJson(x))),
        featuredProducts: json["featured_products"] == null
            ? null
            : List<FeaturedProduct>.from(json["featured_products"]
                .map((x) => FeaturedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId == null ? null : storeId,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "delivery_date": deliveryDate == null ? null : deliveryDate,
        "shop_type": shopType == null ? null : shopType,
        "min_order_amount": minOrderAmount == null ? null : minOrderAmount,
        "image": image == null ? null : image,
        "store_category": storeCategory == null
            ? null
            : List<dynamic>.from(storeCategory!.map((x) => x.toJson())),
        "featured_products": featuredProducts == null
            ? null
            : List<dynamic>.from(featuredProducts!.map((x) => x.toJson())),
      };
}

class FeaturedProduct {
  FeaturedProduct(
      {this.productId,
      this.name,
      this.sku,
      this.shortDescription,
      this.price,
      this.specialPrice,
      this.deliveryDate,
      this.type,
      this.shopType,
      this.image,
      this.salable_qty});

  String? productId;
  String? name;
  String? sku;
  String? shortDescription;
  String? price;
  dynamic specialPrice;
  dynamic salable_qty;
  String? deliveryDate;
  String? type;
  String? shopType;
  String? image;

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) =>
      FeaturedProduct(
        productId: json["product_id"] == null ? null : json["product_id"],
        name: json["name"] == null ? null : json["name"],
        sku: json["sku"] == null ? null : json["sku"],
        shortDescription: json["short_description"] == null
            ? null
            : json["short_description"],
        price: json["price"] == null ? null : json["price"],
        salable_qty: json["salable_qty"] == null ? null : json["salable_qty"],
        specialPrice: json["special_price"],
        deliveryDate:
            json["delivery_date"] == null ? null : json["delivery_date"],
        type: json["type"] == null ? null : json["type"],
        shopType: json["shop_type"] == null ? null : json["shop_type"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId == null ? null : productId,
        "name": name == null ? null : name,
        "sku": sku == null ? null : sku,
        "salable_qty": salable_qty == null ? null : salable_qty,
        "short_description": shortDescription == null ? null : shortDescription,
        "price": price == null ? null : price,
        "special_price": specialPrice,
        "delivery_date": deliveryDate == null ? null : deliveryDate,
        "type": type == null ? null : type,
        "shop_type": shopType == null ? null : shopType,
        "image": image == null ? null : image,
      };
}

class StoreCategory {
  StoreCategory({
    this.categoryId,
    this.categoryTitle,
    this.categoryImage,
  });

  String? categoryId;
  String? categoryTitle;
  String? categoryImage;

  factory StoreCategory.fromJson(Map<String, dynamic> json) => StoreCategory(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        categoryTitle:
            json["category_title"] == null ? null : json["category_title"],
        categoryImage:
            json["category_image"] == null ? null : json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId == null ? null : categoryId,
        "category_title": categoryTitle == null ? null : categoryTitle,
        "category_image": categoryImage == null ? null : categoryImage,
      };
}
