// To parse this JSON data, do
//
//     final myOrderModel = myOrderModelFromJson(jsonString);

import 'dart:convert';

MyOrderModel myOrderModelFromJson(String str) =>
    MyOrderModel.fromJson(json.decode(str));

String myOrderModelToJson(MyOrderModel data) => json.encode(data.toJson());

class MyOrderModel {
  MyOrderModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<Datum>? data;

  factory MyOrderModel.fromJson(Map<String, dynamic> json) => MyOrderModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.entityId,
    this.orderId,
    this.orderCurrency,
    this.status,
    this.createdAt,
    this.customerFirstname,
    this.customerLastname,
    this.shippingMethod,
    this.billingAddress,
    this.shippingAddress,
    this.items,
    this.stores,
  });

  String? entityId;
  String? orderId;
  String? orderCurrency;
  String? status;
  DateTime? createdAt;
  String? customerFirstname;
  String? customerLastname;
  String? shippingMethod;
  IngAddress? billingAddress;
  IngAddress? shippingAddress;
  List<Item>? items;
  List<Store>? stores;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        orderCurrency:
            json["order_currency"] == null ? null : json["order_currency"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        customerFirstname: json["customer_firstname"] == null
            ? null
            : json["customer_firstname"],
        customerLastname: json["customer_lastname"] == null
            ? null
            : json["customer_lastname"],
        shippingMethod:
            json["shipping_method"] == null ? null : json["shipping_method"],
        billingAddress: json["billing_address"] == null
            ? null
            : IngAddress.fromJson(json["billing_address"]),
        shippingAddress: json["shipping_address"] == null
            ? null
            : IngAddress.fromJson(json["shipping_address"]),
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        stores: json["stores"] == null
            ? null
            : List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "entity_id": entityId == null ? null : entityId,
        "order_id": orderId == null ? null : orderId,
        "order_currency": orderCurrency == null ? null : orderCurrency,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "customer_firstname":
            customerFirstname == null ? null : customerFirstname,
        "customer_lastname": customerLastname == null ? null : customerLastname,
        "shipping_method": shippingMethod == null ? null : shippingMethod,
        "billing_address":
            billingAddress == null ? null : billingAddress!.toJson(),
        "shipping_address":
            shippingAddress == null ? null : shippingAddress!.toJson(),
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "stores": stores == null
            ? null
            : List<dynamic>.from(stores!.map((x) => x.toJson())),
      };
}

class IngAddress {
  IngAddress({
    this.entityId,
    this.parentId,
    this.customerAddressId,
    this.quoteAddressId,
    this.regionId,
    this.customerId,
    this.fax,
    this.region,
    this.postcode,
    this.lastname,
    this.street,
    this.city,
    this.email,
    this.telephone,
    this.countryId,
    this.firstname,
    this.addressType,
    this.prefix,
    this.middlename,
    this.suffix,
    this.company,
    this.vatId,
    this.vatIsValid,
    this.vatRequestId,
    this.vatRequestDate,
    this.vatRequestSuccess,
    this.vertexVatCountryCode,
    this.mobile,
    this.area,
    this.building,
    this.apartmentNumber,
    this.floor,
    this.note,
    this.latitude,
    this.longitude,
  });

  String? entityId;
  String? parentId;
  String? customerAddressId;
  String? quoteAddressId;
  String? regionId;
  String? customerId;
  String? fax;
  String? region;
  String? postcode;
  String? lastname;
  String? street;
  String? city;
  String? email;
  String? telephone;
  String? countryId;
  String? firstname;
  String? addressType;
  String? prefix;
  String? middlename;
  String? suffix;
  String? company;
  String? vatId;
  String? vatIsValid;
  String? vatRequestId;
  String? vatRequestDate;
  String? vatRequestSuccess;
  String? vertexVatCountryCode;
  String? mobile;
  String? area;
  String? building;
  String? apartmentNumber;
  String? floor;
  String? note;
  String? latitude;
  String? longitude;

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        customerAddressId: json["customer_address_id"] == null
            ? null
            : json["customer_address_id"],
        quoteAddressId:
            json["quote_address_id"] == null ? null : json["quote_address_id"],
        regionId: json["region_id"] == null ? null : json["region_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        fax: json["fax"] == null ? null : json["fax"],
        region: json["region"] == null ? null : json["region"],
        postcode: json["postcode"] == null ? null : json["postcode"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        street: json["street"] == null ? null : json["street"],
        city: json["city"] == null ? null : json["city"],
        email: json["email"] == null ? null : json["email"],
        telephone: json["telephone"] == null ? null : json["telephone"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        prefix: json["prefix"] == null ? null : json["prefix"],
        middlename: json["middlename"] == null ? null : json["middlename"],
        suffix: json["suffix"] == null ? null : json["suffix"],
        company: json["company"] == null ? null : json["company"],
        vatId: json["vat_id"] == null ? null : json["vat_id"],
        vatIsValid: json["vat_is_valid"] == null ? null : json["vat_is_valid"],
        vatRequestId:
            json["vat_request_id"] == null ? null : json["vat_request_id"],
        vatRequestDate:
            json["vat_request_date"] == null ? null : json["vat_request_date"],
        vatRequestSuccess: json["vat_request_success"] == null
            ? null
            : json["vat_request_success"],
        vertexVatCountryCode: json["vertex_vat_country_code"] == null
            ? null
            : json["vertex_vat_country_code"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        area: json["area"] == null ? null : json["area"],
        building: json["building"] == null ? null : json["building"],
        apartmentNumber:
            json["apartment_number"] == null ? null : json["apartment_number"],
        floor: json["floor"] == null ? null : json["floor"],
        note: json["note"] == null ? null : json["note"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "entity_id": entityId == null ? null : entityId,
        "parent_id": parentId == null ? null : parentId,
        "customer_address_id":
            customerAddressId == null ? null : customerAddressId,
        "quote_address_id": quoteAddressId == null ? null : quoteAddressId,
        "region_id": regionId == null ? null : regionId,
        "customer_id": customerId == null ? null : customerId,
        "fax": fax == null ? null : fax,
        "region": region == null ? null : region,
        "postcode": postcode == null ? null : postcode,
        "lastname": lastname == null ? null : lastname,
        "street": street == null ? null : street,
        "city": city == null ? null : city,
        "email": email == null ? null : email,
        "telephone": telephone == null ? null : telephone,
        "country_id": countryId == null ? null : countryId,
        "firstname": firstname == null ? null : firstname,
        "address_type": addressType == null ? null : addressType,
        "prefix": prefix == null ? null : prefix,
        "middlename": middlename == null ? null : middlename,
        "suffix": suffix == null ? null : suffix,
        "company": company == null ? null : company,
        "vat_id": vatId == null ? null : vatId,
        "vat_is_valid": vatIsValid == null ? null : vatIsValid,
        "vat_request_id": vatRequestId == null ? null : vatRequestId,
        "vat_request_date": vatRequestDate == null ? null : vatRequestDate,
        "vat_request_success":
            vatRequestSuccess == null ? null : vatRequestSuccess,
        "vertex_vat_country_code":
            vertexVatCountryCode == null ? null : vertexVatCountryCode,
        "mobile": mobile == null ? null : mobile,
        "area": area == null ? null : area,
        "building": building == null ? null : building,
        "apartment_number": apartmentNumber == null ? null : apartmentNumber,
        "floor": floor == null ? null : floor,
        "note": note == null ? null : note,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
      };
}

class Item {
  Item({
    this.itemId,
    this.qty,
    this.productId,
    this.sku,
    this.name,
    this.store,
    this.attributeSetId,
    this.price,
    this.finalPrice,
    this.discountAmount,
    this.total,
    this.typeId,
    this.createdAt,
    this.updatedAt,
    this.weight,
    this.image,
  });

  String? itemId;
  int? qty;
  String? productId;
  String? sku;
  String? name;
  String? store;
  String? attributeSetId;
  String? price;
  String? finalPrice;
  String? discountAmount;
  String? total;
  String? typeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic weight;
  String? image;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["item_id"] == null ? null : json["item_id"],
        qty: json["qty"] == null ? null : json["qty"],
        productId: json["product_id"] == null ? null : json["product_id"],
        sku: json["sku"] == null ? null : json["sku"],
        name: json["name"] == null ? null : json["name"],
        store: json["store"] == null ? null : json["store"],
        attributeSetId:
            json["attribute_set_id"] == null ? null : json["attribute_set_id"],
        price: json["price"] == null ? null : json["price"],
        finalPrice: json["final_price"] == null ? null : json["final_price"],
        discountAmount:
            json["discount_amount"] == null ? null : json["discount_amount"],
        total: json["total"] == null ? null : json["total"],
        typeId: json["type_id"] == null ? null : json["type_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        weight: json["weight"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId == null ? null : itemId,
        "qty": qty == null ? null : qty,
        "product_id": productId == null ? null : productId,
        "sku": sku == null ? null : sku,
        "name": name == null ? null : name,
        "store": store == null ? null : store,
        "attribute_set_id": attributeSetId == null ? null : attributeSetId,
        "price": price == null ? null : price,
        "final_price": finalPrice == null ? null : finalPrice,
        "discount_amount": discountAmount == null ? null : discountAmount,
        "total": total == null ? null : total,
        "type_id": typeId == null ? null : typeId,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "weight": weight,
        "image": image == null ? null : image,
      };
}

class Store {
  Store({
    this.name,
    this.storeId,
  });

  String? name;
  String? storeId;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json["name"] == null ? null : json["name"],
        storeId: json["store_id"] == null ? null : json["store_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "store_id": storeId == null ? null : storeId,
      };
}
