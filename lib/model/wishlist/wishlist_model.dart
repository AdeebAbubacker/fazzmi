// To parse this JSON data, do
//
//     final viewWishListModel = viewWishListModelFromJson(jsonString);

import 'dart:convert';

ViewWishListModel viewWishListModelFromJson(String str) =>
    ViewWishListModel.fromJson(json.decode(str));

String viewWishListModelToJson(ViewWishListModel data) =>
    json.encode(data.toJson());

class ViewWishListModel {
  ViewWishListModel({
    this.message,
    this.status,
    this.data,
  });

  String? message;
  int? status;
  List<Datum>? data;

  factory ViewWishListModel.fromJson(Map<String, dynamic> json) =>
      ViewWishListModel(
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.wishlistItemId,
      this.wishlistId,
      this.sku,
      this.price,
      this.specialPrice,
      this.shortDescription,
      this.image,
      this.productId,
      this.storeId,
      this.addedAt,
      this.description,
      this.qty,
      this.type,
      this.parent_category_id,
      this.shop_type,
      this.store_name});

  dynamic wishlistItemId;
  dynamic wishlistId;
  String? sku;
  dynamic price;
  dynamic specialPrice;
  String? shortDescription;
  String? image;
  dynamic productId;
  dynamic storeId;
  DateTime? addedAt;
  dynamic description;
  dynamic qty;
  String? type;
  String? parent_category_id;
  String? store_name;
  String? shop_type;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        wishlistItemId:
            json["wishlist_item_id"] == null ? null : json["wishlist_item_id"],
        shop_type: json["shop_type"] == null ? null : json["shop_type"],
        store_name: json["store_name"] == null ? null : json["store_name"],
        parent_category_id: json["parent_category_id"] == null
            ? null
            : json["parent_category_id"],
        wishlistId: json["wishlist_id"] == null ? null : json["wishlist_id"],
        sku: json["sku"] == null ? null : json["sku"],
        price: json["price"],
        specialPrice: json["special_price"],
        shortDescription: json["short_description"] == null
            ? null
            : json["short_description"],
        image: json["image"] == null ? null : json["image"],
        productId: json["product_id"] == null ? null : json["product_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        addedAt:
            json["added_at"] == null ? null : DateTime.parse(json["added_at"]),
        description: json["description"],
        qty: json["qty"] == null ? null : json["qty"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "parent_category_id":
            parent_category_id == null ? null : parent_category_id,
        "store_name": store_name == null ? null : store_name,
        "shop_type": shop_type == null ? null : shop_type,
        "wishlist_item_id": wishlistItemId == null ? null : wishlistItemId,
        "wishlist_id": wishlistId == null ? null : wishlistId,
        "sku": sku == null ? null : sku,
        "price": price,
        "special_price": specialPrice,
        "short_description": shortDescription == null ? null : shortDescription,
        "image": image == null ? null : image,
        "product_id": productId == null ? null : productId,
        "store_id": storeId == null ? null : storeId,
        "added_at": addedAt == null ? null : addedAt!.toIso8601String(),
        "description": description,
        "qty": qty == null ? null : qty,
        "type": type == null ? null : type,
      };
}
