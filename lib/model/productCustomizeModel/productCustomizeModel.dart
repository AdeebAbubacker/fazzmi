// To parse this JSON data, do
//
//     final productCustomize = productCustomizeFromJson(jsonString);

import 'dart:convert';

ProductCustomize productCustomizeFromJson(String str) =>
    ProductCustomize.fromJson(json.decode(str));

String productCustomizeToJson(ProductCustomize data) =>
    json.encode(data.toJson());

class ProductCustomize {
  ProductCustomize({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory ProductCustomize.fromJson(Map<String, dynamic> json) =>
      ProductCustomize(
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
    this.childSku,
    this.color,
    this.price,
    this.specialPrice,
    this.stock,
    this.colorValue,
    this.image,
    this.colorWatchImage,
    this.size,
    this.sizeValue,
    this.sizeWatchImage,
    this.id,
  });

  String? childSku;
  String? color;
  String? price;
  dynamic specialPrice;
  dynamic stock;
  String? colorValue;
  String? image;
  String? colorWatchImage;
  String? size;
  String? sizeValue;
  String? sizeWatchImage;
  int? id;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        childSku: json["child_sku"] == null ? null : json["child_sku"],
        color: json["color"] == null ? null : json["color"],
        price: json["price"] == null ? null : json["price"],
        specialPrice: json["special_price"],
        stock: json["stock"],
        colorValue: json["color_value"] == null ? null : json["color_value"],
        image: json["image"] == null ? null : json["image"],
        colorWatchImage: json["color_watch_image"] == null
            ? null
            : json["color_watch_image"],
        size: json["size"] == null ? null : json["size"],
        sizeValue: json["size_value"] == null ? null : json["size_value"],
        sizeWatchImage:
            json["size_watch_image"] == null ? null : json["size_watch_image"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "child_sku": childSku == null ? null : childSku,
        "color": color == null ? null : color,
        "price": price == null ? null : price,
        "special_price": specialPrice,
        "stock": stock,
        "color_value": colorValue == null ? null : colorValue,
        "image": image == null ? null : image,
        "color_watch_image": colorWatchImage == null ? null : colorWatchImage,
        "size": size == null ? null : size,
        "size_value": sizeValue == null ? null : sizeValue,
        "size_watch_image": sizeWatchImage == null ? null : sizeWatchImage,
        "id": id == null ? null : id,
      };
}
