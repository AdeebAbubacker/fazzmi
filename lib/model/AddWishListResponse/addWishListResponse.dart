// To parse this JSON data, do
//
//     final addWishListResponse = addWishListResponseFromJson(jsonString);

import 'dart:convert';

AddWishListResponse addWishListResponseFromJson(String str) =>
    AddWishListResponse.fromJson(json.decode(str));

String addWishListResponseToJson(AddWishListResponse data) =>
    json.encode(data.toJson());

class AddWishListResponse {
  AddWishListResponse({
    this.message,
    this.status,
    this.data,
  });

  String? message;
  int? status;
  List<Datum>? data;

  factory AddWishListResponse.fromJson(Map<String, dynamic> json) =>
      AddWishListResponse(
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
  Datum({
    this.wishlistItemId,
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
  });

  String? wishlistItemId;
  String? wishlistId;
  String? sku;
  String? price;
  String? specialPrice;
  dynamic shortDescription;
  String? image;
  String? productId;
  String? storeId;
  DateTime? addedAt;
  dynamic description;
  int? qty;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        wishlistItemId:
            json["wishlist_item_id"] == null ? null : json["wishlist_item_id"],
        wishlistId: json["wishlist_id"] == null ? null : json["wishlist_id"],
        sku: json["sku"] == null ? null : json["sku"],
        price: json["price"] == null ? null : json["price"],
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        shortDescription: json["short_description"],
        image: json["image"] == null ? null : json["image"],
        productId: json["product_id"] == null ? null : json["product_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        addedAt:
            json["added_at"] == null ? null : DateTime.parse(json["added_at"]),
        description: json["description"],
        qty: json["qty"] == null ? null : json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "wishlist_item_id": wishlistItemId == null ? null : wishlistItemId,
        "wishlist_id": wishlistId == null ? null : wishlistId,
        "sku": sku == null ? null : sku,
        "price": price == null ? null : price,
        "special_price": specialPrice == null ? null : specialPrice,
        "short_description": shortDescription,
        "image": image == null ? null : image,
        "product_id": productId == null ? null : productId,
        "store_id": storeId == null ? null : storeId,
        "added_at": addedAt == null ? null : addedAt!.toIso8601String(),
        "description": description,
        "qty": qty == null ? null : qty,
      };
}
