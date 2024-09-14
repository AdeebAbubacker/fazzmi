// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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
  Datum(
      {this.categoryId,
      this.id,
      this.title,
      this.description,
      this.categoryImage,
      this.image,
      this.featuredProducts,
      this.store_banner,
      this.store_id,
      this.store_name});

  String? categoryId;
  int? id;
  String? title;
  dynamic description;
  String? categoryImage;
  String? image;
  String? store_id;
  String? store_name;
  String? store_banner;
  List<FeaturedProduct>? featuredProducts;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        store_id: json["store_id"] == null ? null : json["store_id"],
        store_name: json["store_name"] == null ? null : json["store_name"],
        store_banner:
            json["store_banner"] == null ? null : json["store_banner"],
        description: json["description"],
        categoryImage:
            json["category_image"] == null ? null : json["category_image"],
        image: json["image"] == null ? null : json["image"],
        featuredProducts: json["featured_products"] == null
            ? null
            : List<FeaturedProduct>.from(json["featured_products"]
                .map((x) => FeaturedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId == null ? null : categoryId,
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "store_id": store_id == null ? null : store_id,
        "store_name": store_name == null ? null : store_name,
        "store_banner": store_banner == null ? null : store_banner,
        "description": description,
        "category_image": categoryImage == null ? null : categoryImage,
        "image": image == null ? null : image,
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
      this.store,
      this.shopType,
      this.image,
      this.store_name,
      this.parent_category_id});

  String? productId;
  String? name;
  String? sku;
  String? shortDescription;
  String? price;
  String? specialPrice;
  String? deliveryDate;
  String? type;
  String? store;
  String? store_name;
  String? shopType;
  String? image;
  String? parent_category_id;

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) =>
      FeaturedProduct(
        parent_category_id: json["parent_category_id"] == null
            ? null
            : json["parent_category_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        name: json["name"] == null ? null : json["name"],
        store_name: json["store_name"] == null ? null : json["store_name"],
        sku: json["sku"] == null ? null : json["sku"],
        shortDescription: json["short_description"] == null
            ? null
            : json["short_description"],
        price: json["price"] == null ? null : json["price"],
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        deliveryDate:
            json["delivery_date"] == null ? null : json["delivery_date"],
        type: json["type"] == null ? null : json["type"],
        store: json["store"] == null ? null : json["store"],
        shopType: json["shop_type"] == null ? null : json["shop_type"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "parent_category_id":
            parent_category_id == null ? null : parent_category_id,
        "product_id": productId == null ? null : productId,
        "name": name == null ? null : name,
        "store_name": store_name == null ? null : store_name,
        "sku": sku == null ? null : sku,
        "short_description": shortDescription == null ? null : shortDescription,
        "price": price == null ? null : price,
        "special_price": specialPrice == null ? null : specialPrice,
        "delivery_date": deliveryDate == null ? null : deliveryDate,
        "type": type == null ? null : type,
        "store": store == null ? null : store,
        "shop_type": shopType == null ? null : shopType,
        "image": image == null ? null : image,
      };
}
