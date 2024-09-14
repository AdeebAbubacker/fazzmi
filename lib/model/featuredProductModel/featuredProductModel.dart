// To parse this JSON data, do
//
//     final featuredProductModel = featuredProductModelFromJson(jsonString);

import 'dart:convert';

FeaturedProductModel featuredProductModelFromJson(String str) =>
    FeaturedProductModel.fromJson(json.decode(str));

String featuredProductModelToJson(FeaturedProductModel data) =>
    json.encode(data.toJson());

class FeaturedProductModel {
  FeaturedProductModel({
    this.message,
    this.status,
    this.productCount,
    this.totalPage,
    this.data,
  });

  String? message;
  int? status;
  int? productCount;
  int? totalPage;
  List<FeaturedProductItem>? data;

  factory FeaturedProductModel.fromJson(Map<String, dynamic> json) =>
      FeaturedProductModel(
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
        productCount:
            json["product_count"] == null ? null : json["product_count"],
        totalPage: json["total_page"] == null ? null : json["total_page"],
        data: json["data"] == null
            ? null
            : List<FeaturedProductItem>.from(
                json["data"].map((x) => FeaturedProductItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "status": status == null ? null : status,
        "product_count": productCount == null ? null : productCount,
        "total_page": totalPage == null ? null : totalPage,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FeaturedProductItem {
  FeaturedProductItem({
    this.id,
    this.sku,
    this.name,
    this.type,
    this.price,
    this.specialPrice,
    this.finalPrice,
    this.description,
    this.shortDescription,
    this.image,
    this.store,
    this.stock,
  });

  String? id;
  String? sku;
  String? name;
  String? type;
  String? price;
  dynamic specialPrice;
  dynamic finalPrice;
  dynamic description;
  dynamic shortDescription;
  String? image;
  String? store;
  dynamic stock;

  factory FeaturedProductItem.fromJson(Map<String, dynamic> json) =>
      FeaturedProductItem(
        id: json["id"] == null ? null : json["id"],
        sku: json["sku"] == null ? null : json["sku"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        price: json["price"] == null ? null : json["price"],
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        finalPrice: json["final_price"] == null ? null : json["final_price"],
        description: json["description"] == null ? null : json["description"],
        shortDescription: json["short_description"] == null
            ? null
            : json["short_description"],
        image: json["image"] == null ? null : json["image"],
        store: json["store"] == null ? null : json["store"],
        stock: json["stock"] == null ? null : json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "sku": sku == null ? null : sku,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "price": price == null ? null : price,
        "special_price": specialPrice == null ? null : specialPrice,
        "final_price": finalPrice == null ? null : finalPrice,
        "description": description == null ? null : description,
        "short_description": shortDescription == null ? null : shortDescription,
        "image": image == null ? null : image,
        "store": store == null ? null : store,
        "stock": stock == null ? null : stock,
      };
}
