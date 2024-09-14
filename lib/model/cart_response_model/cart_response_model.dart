// To parse this JSON data, do
//
//     final cartResponseModel = cartResponseModelFromJson(jsonString);

import 'dart:convert';

CartResponseModel cartResponseModelFromJson(String str) =>
    CartResponseModel.fromJson(json.decode(str));

String cartResponseModelToJson(CartResponseModel data) =>
    json.encode(data.toJson());

class CartResponseModel {
  CartResponseModel({
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

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      CartResponseModel(
        itemId: json["item_id"] == null ? null : json["item_id"],
        sku: json["sku"] == null ? null : json["sku"],
        qty: json["qty"] == null ? null : json["qty"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        productType: json["product_type"] == null ? null : json["product_type"],
        quoteId: json["quote_id"] == null ? null : json["quote_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ExtensionAttributes.fromJson(json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId == null ? null : itemId,
        "sku": sku == null ? null : sku,
        "qty": qty == null ? null : qty,
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "product_type": productType == null ? null : productType,
        "quote_id": quoteId == null ? null : quoteId,
        "extension_attributes":
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
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image == null ? null : image,
      };
}
