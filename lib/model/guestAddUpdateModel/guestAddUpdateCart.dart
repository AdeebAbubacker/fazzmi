// To parse this JSON data, do
//
//     final guestAddUpdateCartModel = guestAddUpdateCartModelFromJson(jsonString);

import 'dart:convert';

GuestAddUpdateCartModel guestAddUpdateCartModelFromJson(String str) =>
    GuestAddUpdateCartModel.fromJson(json.decode(str));

String guestAddUpdateCartModelToJson(GuestAddUpdateCartModel data) =>
    json.encode(data.toJson());

class GuestAddUpdateCartModel {
  GuestAddUpdateCartModel({
    this.itemId,
    this.sku,
    this.qty,
    this.name,
    this.price,
    this.productType,
    this.quoteId,
    this.extensionAttributes,
  });

  int? itemId;
  String? sku;
  int? qty;
  String? name;
  dynamic price;
  String? productType;
  String? quoteId;
  ExtensionAttributes? extensionAttributes;

  factory GuestAddUpdateCartModel.fromJson(Map<String, dynamic> json) =>
      GuestAddUpdateCartModel(
        itemId: json["item_id"],
        sku: json["sku"],
        qty: json["qty"],
        name: json["name"],
        price: json["price"],
        productType: json["product_type"],
        quoteId: json["quote_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ExtensionAttributes.fromJson(json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "sku": sku,
        "qty": qty,
        "name": name,
        "price": price,
        "product_type": productType,
        "quote_id": quoteId,
        "extension_attributes":
            // ignore: prefer_null_aware_operators
            extensionAttributes == null ? null : extensionAttributes!.toJson(),
      };
}

class ExtensionAttributes {
  ExtensionAttributes({
    this.image,
  });

  String? image;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ExtensionAttributes(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
