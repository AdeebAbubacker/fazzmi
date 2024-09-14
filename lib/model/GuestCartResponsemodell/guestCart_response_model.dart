// To parse this JSON data, do
//
//     final guestCartResponsemodel = guestCartResponsemodelFromJson(jsonString);

import 'dart:convert';

GuestCartResponsemodel guestCartResponsemodelFromJson(String str) =>
    GuestCartResponsemodel.fromJson(json.decode(str));

String guestCartResponsemodelToJson(GuestCartResponsemodel data) =>
    json.encode(data.toJson());

class GuestCartResponsemodel {
  GuestCartResponsemodel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isVirtual,
    this.items,
    this.itemsCount,
    this.itemsQty,
    this.customer,
    this.billingAddress,
    this.origOrderId,
    this.currency,
    this.customerIsGuest,
    this.customerNoteNotify,
    this.customerTaxClassId,
    this.storeId,
    this.extensionAttributes,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActive;
  bool? isVirtual;
  List<Item>? items;
  int? itemsCount;
  int? itemsQty;
  Customer? customer;
  Address? billingAddress;
  int? origOrderId;
  Currency? currency;
  bool? customerIsGuest;
  bool? customerNoteNotify;
  int? customerTaxClassId;
  int? storeId;
  GuestCartResponsemodelExtensionAttributes? extensionAttributes;

  factory GuestCartResponsemodel.fromJson(Map<String, dynamic> json) =>
      GuestCartResponsemodel(
        id: json["id"] == null ? null : json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isActive: json["is_active"] == null ? null : json["is_active"],
        isVirtual: json["is_virtual"] == null ? null : json["is_virtual"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        itemsCount: json["items_count"] == null ? null : json["items_count"],
        itemsQty: json["items_qty"] == null ? null : json["items_qty"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        billingAddress: json["billing_address"] == null
            ? null
            : Address.fromJson(json["billing_address"]),
        origOrderId:
            json["orig_order_id"] == null ? null : json["orig_order_id"],
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        customerIsGuest: json["customer_is_guest"] == null
            ? null
            : json["customer_is_guest"],
        customerNoteNotify: json["customer_note_notify"] == null
            ? null
            : json["customer_note_notify"],
        customerTaxClassId: json["customer_tax_class_id"] == null
            ? null
            : json["customer_tax_class_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : GuestCartResponsemodelExtensionAttributes.fromJson(
                json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "is_active": isActive == null ? null : isActive,
        "is_virtual": isVirtual == null ? null : isVirtual,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "items_count": itemsCount == null ? null : itemsCount,
        "items_qty": itemsQty == null ? null : itemsQty,
        "customer": customer == null ? null : customer!.toJson(),
        "billing_address":
            billingAddress == null ? null : billingAddress!.toJson(),
        "orig_order_id": origOrderId == null ? null : origOrderId,
        "currency": currency == null ? null : currency!.toJson(),
        "customer_is_guest": customerIsGuest == null ? null : customerIsGuest,
        "customer_note_notify":
            customerNoteNotify == null ? null : customerNoteNotify,
        "customer_tax_class_id":
            customerTaxClassId == null ? null : customerTaxClassId,
        "store_id": storeId == null ? null : storeId,
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes!.toJson(),
      };
}

class Address {
  Address({
    this.id,
    this.region,
    this.regionId,
    this.regionCode,
    this.countryId,
    this.street,
    this.telephone,
    this.postcode,
    this.city,
    this.firstname,
    this.lastname,
    this.email,
    this.sameAsBilling,
    this.saveInAddressBook,
  });

  int? id;
  dynamic region;
  dynamic regionId;
  dynamic regionCode;
  dynamic countryId;
  List<String>? street;
  dynamic telephone;
  dynamic postcode;
  dynamic city;
  dynamic firstname;
  dynamic lastname;
  dynamic email;
  int? sameAsBilling;
  int? saveInAddressBook;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"],
        region: json["region"],
        regionId: json["region_id"],
        regionCode: json["region_code"],
        countryId: json["country_id"],
        street: json["street"] == null
            ? null
            : List<String>.from(json["street"].map((x) => x)),
        telephone: json["telephone"],
        postcode: json["postcode"],
        city: json["city"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        sameAsBilling:
            json["same_as_billing"] == null ? null : json["same_as_billing"],
        saveInAddressBook: json["save_in_address_book"] == null
            ? null
            : json["save_in_address_book"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "region": region,
        "region_id": regionId,
        "region_code": regionCode,
        "country_id": countryId,
        "street":
            street == null ? null : List<dynamic>.from(street!.map((x) => x)),
        "telephone": telephone,
        "postcode": postcode,
        "city": city,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "same_as_billing": sameAsBilling == null ? null : sameAsBilling,
        "save_in_address_book":
            saveInAddressBook == null ? null : saveInAddressBook,
      };
}

class Currency {
  Currency({
    this.globalCurrencyCode,
    this.baseCurrencyCode,
    this.storeCurrencyCode,
    this.quoteCurrencyCode,
    this.storeToBaseRate,
    this.storeToQuoteRate,
    this.baseToGlobalRate,
    this.baseToQuoteRate,
  });

  String? globalCurrencyCode;
  String? baseCurrencyCode;
  String? storeCurrencyCode;
  String? quoteCurrencyCode;
  int? storeToBaseRate;
  int? storeToQuoteRate;
  int? baseToGlobalRate;
  int? baseToQuoteRate;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        globalCurrencyCode: json["global_currency_code"] == null
            ? null
            : json["global_currency_code"],
        baseCurrencyCode: json["base_currency_code"] == null
            ? null
            : json["base_currency_code"],
        storeCurrencyCode: json["store_currency_code"] == null
            ? null
            : json["store_currency_code"],
        quoteCurrencyCode: json["quote_currency_code"] == null
            ? null
            : json["quote_currency_code"],
        storeToBaseRate: json["store_to_base_rate"] == null
            ? null
            : json["store_to_base_rate"],
        storeToQuoteRate: json["store_to_quote_rate"] == null
            ? null
            : json["store_to_quote_rate"],
        baseToGlobalRate: json["base_to_global_rate"] == null
            ? null
            : json["base_to_global_rate"],
        baseToQuoteRate: json["base_to_quote_rate"] == null
            ? null
            : json["base_to_quote_rate"],
      );

  Map<String, dynamic> toJson() => {
        "global_currency_code":
            globalCurrencyCode == null ? null : globalCurrencyCode,
        "base_currency_code":
            baseCurrencyCode == null ? null : baseCurrencyCode,
        "store_currency_code":
            storeCurrencyCode == null ? null : storeCurrencyCode,
        "quote_currency_code":
            quoteCurrencyCode == null ? null : quoteCurrencyCode,
        "store_to_base_rate": storeToBaseRate == null ? null : storeToBaseRate,
        "store_to_quote_rate":
            storeToQuoteRate == null ? null : storeToQuoteRate,
        "base_to_global_rate":
            baseToGlobalRate == null ? null : baseToGlobalRate,
        "base_to_quote_rate": baseToQuoteRate == null ? null : baseToQuoteRate,
      };
}

class Customer {
  Customer({
    this.email,
    this.firstname,
    this.lastname,
  });

  dynamic email;
  dynamic firstname;
  dynamic lastname;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
      };
}

class GuestCartResponsemodelExtensionAttributes {
  GuestCartResponsemodelExtensionAttributes({
    this.shippingAssignments,
  });

  List<ShippingAssignment>? shippingAssignments;

  factory GuestCartResponsemodelExtensionAttributes.fromJson(
          Map<String, dynamic> json) =>
      GuestCartResponsemodelExtensionAttributes(
        shippingAssignments: json["shipping_assignments"] == null
            ? null
            : List<ShippingAssignment>.from(json["shipping_assignments"]
                .map((x) => ShippingAssignment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shipping_assignments": shippingAssignments == null
            ? null
            : List<dynamic>.from(shippingAssignments!.map((x) => x.toJson())),
      };
}

class ShippingAssignment {
  ShippingAssignment({
    this.shipping,
    this.items,
  });

  Shipping? shipping;
  List<Item>? items;

  factory ShippingAssignment.fromJson(Map<String, dynamic> json) =>
      ShippingAssignment(
        shipping: json["shipping"] == null
            ? null
            : Shipping.fromJson(json["shipping"]),
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shipping": shipping == null ? null : shipping!.toJson(),
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
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
  ItemExtensionAttributes? extensionAttributes;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["item_id"] == null ? null : json["item_id"],
        sku: json["sku"] == null ? null : json["sku"],
        qty: json["qty"] == null ? null : json["qty"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        productType: json["product_type"] == null ? null : json["product_type"],
        quoteId: json["quote_id"] == null ? null : json["quote_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ItemExtensionAttributes.fromJson(json["extension_attributes"]),
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

class ItemExtensionAttributes {
  ItemExtensionAttributes({
    this.image,
    this.productId,
    this.store,
    this.store_name,
    this.parent_category_id,
    this.special_price,
    this.price,
    this.stock,
  });

  String? image;
  String? productId;
  String? store;
  String? store_name;
  String? parent_category_id;
  dynamic special_price;
  dynamic price;
  dynamic stock;

  factory ItemExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ItemExtensionAttributes(
        image: json["image"] == null ? null : json["image"],
        parent_category_id: json["parent_category_id"] == null
            ? null
            : json["parent_category_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        store: json["store"] == null ? null : json["store"],
        store_name: json["store_name"] == null ? null : json["store_name"],
        special_price:
            json["special_price"] == null ? null : json["special_price"],
        price: json["price"] == null ? null : json["price"],
        stock: json["stock"] == null ? null : json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "parent_category_id":
            parent_category_id == null ? null : parent_category_id,
        "image": image == null ? null : image,
        "product_id": productId == null ? null : productId,
        "store": store == null ? null : store,
        "store_name": store_name == null ? null : store_name,
        "special_price": special_price == null ? null : special_price,
        "price": price == null ? null : price,
        "stock": stock == null ? null : stock,
      };
}

class Shipping {
  Shipping({
    this.address,
    this.method,
  });

  Address? address;
  dynamic method;

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "address": address == null ? null : address!.toJson(),
        "method": method,
      };
}
