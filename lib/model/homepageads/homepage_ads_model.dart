// To parse this JSON data, do
//
//     final homePageAds = homePageAdsFromJson(jsonString);

import 'dart:convert';

HomePageAds homePageAdsFromJson(String str) =>
    HomePageAds.fromJson(json.decode(str));

String homePageAdsToJson(HomePageAds data) => json.encode(data.toJson());

class HomePageAds {
  HomePageAds({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  int? status;
  int? code;
  String? message;
  List<Datum>? data;

  factory HomePageAds.fromJson(Map<String, dynamic> json) => HomePageAds(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.title,
    this.image,
    this.sortOrder,
    this.store,
    this.storeName,
    this.parentCategoryId,
    this.shop_type,
  });

  String? title;
  String? image;
  String? sortOrder;
  String? store;
  String? storeName;
  dynamic parentCategoryId;
  String? shop_type;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      title: json["title"] == null ? null : json["title"],
      shop_type: json["shop_type"] == null ? null : json["shop_type"],
      image: json["image"] == null ? null : json["image"],
      sortOrder: json["sort_order"] == null ? null : json["sort_order"],
      store: json["store"] == null ? null : json["store"],
      storeName: json["store_name"] == null ? null : json["store_name"],
      parentCategoryId: json["parent_category_id"]);

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "image": image == null ? null : image,
        "sortOrder": sortOrder == null ? null : sortOrder,
        "store": store == null ? null : store,
        "storeName": storeName == null ? null : storeName,
        "parentCategoryId": parentCategoryId,
        "shop_type": shop_type == null ? null : shop_type,
      };
}
