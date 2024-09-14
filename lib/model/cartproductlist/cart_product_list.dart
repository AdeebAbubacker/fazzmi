// To parse this JSON data, do
//
//     final viewCartPageModel = viewCartPageModelFromJson(jsonString);

import 'dart:convert';

ViewCartPageModel viewCartPageModelFromJson(String str) =>
    ViewCartPageModel.fromJson(json.decode(str));

String viewCartPageModelToJson(ViewCartPageModel data) =>
    json.encode(data.toJson());

class ViewCartPageModel {
  ViewCartPageModel({
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
  ViewCartPageModelExtensionAttributes? extensionAttributes;

  factory ViewCartPageModel.fromJson(Map<String, dynamic> json) =>
      ViewCartPageModel(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isActive: json["is_active"],
        isVirtual: json["is_virtual"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        itemsCount: json["items_count"],
        itemsQty: json["items_qty"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        billingAddress: json["billing_address"] == null
            ? null
            : Address.fromJson(json["billing_address"]),
        origOrderId:
            json["orig_order_id"],
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        customerIsGuest: json["customer_is_guest"],
        customerNoteNotify: json["customer_note_notify"],
        customerTaxClassId: json["customer_tax_class_id"],
        storeId: json["store_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ViewCartPageModelExtensionAttributes.fromJson(
                json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "is_active": isActive,
        "is_virtual": isVirtual,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "items_count": itemsCount,
        "items_qty": itemsQty,
        "customer": customer == null ? null : customer!.toJson(),
        "billing_address":
            billingAddress == null ? null : billingAddress!.toJson(),
        "orig_order_id": origOrderId,
        "currency": currency == null ? null : currency!.toJson(),
        "customer_is_guest": customerIsGuest,
        "customer_note_notify":
            customerNoteNotify,
        "customer_tax_class_id":
            customerTaxClassId,
        "store_id": storeId,
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
    this.customerId,
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
  int? customerId;
  String? email;
  int? sameAsBilling;
  int? saveInAddressBook;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
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
        customerId: json["customer_id"],
        email: json["email"],
        sameAsBilling:
            json["same_as_billing"],
        saveInAddressBook: json["save_in_address_book"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "customer_id": customerId,
        "email": email,
        "same_as_billing": sameAsBilling,
        "save_in_address_book":
            saveInAddressBook,
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
        globalCurrencyCode: json["global_currency_code"],
        baseCurrencyCode: json["base_currency_code"],
        storeCurrencyCode: json["store_currency_code"],
        quoteCurrencyCode: json["quote_currency_code"],
        storeToBaseRate: json["store_to_base_rate"],
        storeToQuoteRate: json["store_to_quote_rate"],
        baseToGlobalRate: json["base_to_global_rate"],
        baseToQuoteRate: json["base_to_quote_rate"],
      );

  Map<String, dynamic> toJson() => {
        "global_currency_code":
            globalCurrencyCode,
        "base_currency_code":
            baseCurrencyCode,
        "store_currency_code":
            storeCurrencyCode,
        "quote_currency_code":
            quoteCurrencyCode,
        "store_to_base_rate": storeToBaseRate,
        "store_to_quote_rate":
            storeToQuoteRate,
        "base_to_global_rate":
            baseToGlobalRate,
        "base_to_quote_rate": baseToQuoteRate,
      };
}

class Customer {
  Customer({
    this.id,
    this.groupId,
    this.createdAt,
    this.updatedAt,
    this.createdIn,
    this.email,
    this.firstname,
    this.lastname,
    this.storeId,
    this.websiteId,
    this.addresses,
    this.disableAutoGroupChange,
    this.extensionAttributes,
  });

  int? id;
  int? groupId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdIn;
  String? email;
  String? firstname;
  String? lastname;
  int? storeId;
  int? websiteId;
  List<dynamic>? addresses;
  int? disableAutoGroupChange;
  CustomerExtensionAttributes? extensionAttributes;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        groupId: json["group_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdIn: json["created_in"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        storeId: json["store_id"],
        websiteId: json["website_id"],
        addresses: json["addresses"] == null
            ? null
            : List<dynamic>.from(json["addresses"].map((x) => x)),
        disableAutoGroupChange: json["disable_auto_group_change"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : CustomerExtensionAttributes.fromJson(
                json["extension_attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "created_in": createdIn,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "store_id": storeId,
        "website_id": websiteId,
        "addresses": addresses == null
            ? null
            : List<dynamic>.from(addresses!.map((x) => x)),
        "disable_auto_group_change":
            disableAutoGroupChange,
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes!.toJson(),
      };
}

class CustomerExtensionAttributes {
  CustomerExtensionAttributes({
    this.isSubscribed,
  });

  bool? isSubscribed;

  factory CustomerExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      CustomerExtensionAttributes(
        isSubscribed:
            json["is_subscribed"],
      );

  Map<String, dynamic> toJson() => {
        "is_subscribed": isSubscribed,
      };
}

class ViewCartPageModelExtensionAttributes {
  ViewCartPageModelExtensionAttributes({
    this.shippingAssignments,
  });

  List<ShippingAssignment>? shippingAssignments;

  factory ViewCartPageModelExtensionAttributes.fromJson(
          Map<String, dynamic> json) =>
      ViewCartPageModelExtensionAttributes(
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
        itemId: json["item_id"],
        sku: json["sku"],
        qty: json["qty"],
        name: json["name"],
        price: json["price"],
        productType: json["product_type"],
        quoteId: json["quote_id"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ItemExtensionAttributes.fromJson(json["extension_attributes"]),
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
  dynamic special_price;
  dynamic price;
  dynamic stock;

  String? parent_category_id;

  factory ItemExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ItemExtensionAttributes(
        image: json["image"],
        parent_category_id: json["parent_category_id"],
        productId: json["product_id"],
        store: json["store"],
        store_name: json["store_name"],
        special_price:
            json["special_price"],
        price: json["price"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "parent_category_id":
            parent_category_id,
        "image": image,
        "product_id": productId,
        "store": store,
        "store_name": store_name,
        "special_price": special_price,
        "price": price,
        "stock": stock,
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
