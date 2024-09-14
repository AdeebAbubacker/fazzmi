// To parse this JSON data, do
//
//     final productDetailPageModel = productDetailPageModelFromJson(jsonString);

import 'dart:convert';

ProductDetailPageModel productDetailPageModelFromJson(String str) =>
    ProductDetailPageModel.fromJson(json.decode(str));

String productDetailPageModelToJson(ProductDetailPageModel data) =>
    json.encode(data.toJson());

class ProductDetailPageModel {
  ProductDetailPageModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  dynamic status;
  dynamic code;
  dynamic message;
  Data? data;

  factory ProductDetailPageModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailPageModel(
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.productInfo,
  });

  ProductInfo? productInfo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        productInfo: json["product_info"] == null
            ? null
            : ProductInfo.fromJson(json["product_info"]),
      );

  Map<String, dynamic> toJson() => {
        "product_info": productInfo == null ? null : productInfo!.toJson(),
      };
}

class ProductInfo {
  ProductInfo(
      {this.brand,
      this.item_weight,
      this.entityId,
      this.attributeSetId,
      this.typeId,
      this.sku,
      this.hasOptions,
      this.requiredOptions,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.price,
      this.msrpDisplayActualPriceType,
      this.urlKey,
      this.thumbnail,
      this.swatchImage,
      this.smallImage,
      this.optionsContainer,
      this.name,
      this.metaTitle,
      this.metaDescription,
      this.color,
      this.giftMessageAvailable,
      this.metaKeyword,
      this.shortDescription,
      this.description,
      this.delivery,
      this.size,
      this.productStore,
      this.taxClassId,
      this.visibility,
      this.status,
      this.options,
      this.mediaGallery,
      this.extensionAttributes,
      this.tierPrice,
      this.tierPriceChanged,
      this.quantityAndStockStatus,
      this.categoryIds,
      this.isSalable,
      this.firstChild,
      this.specialPrice,
      this.specialFromDate,
      this.specialToDate,
      this.discount,
      this.deliveryDate,
      this.available,
      this.variations,
      this.sub_title,
      this.product_type_fazzmi,
      this.cutoffTime,
      this.wishlistId,
      this.salable_qty});

  dynamic entityId;
  dynamic attributeSetId;
  dynamic typeId;
  dynamic sku;
  dynamic hasOptions;
  dynamic requiredOptions;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic image;
  dynamic price;
  dynamic msrpDisplayActualPriceType;
  dynamic urlKey;
  dynamic thumbnail;
  dynamic swatchImage;
  dynamic smallImage;
  dynamic optionsContainer;
  dynamic name;
  dynamic metaTitle;
  dynamic metaDescription;
  dynamic color;
  dynamic cutoffTime;
  dynamic giftMessageAvailable;
  dynamic metaKeyword;
  dynamic shortDescription;
  dynamic description;
  dynamic delivery;
  dynamic size;
  dynamic brand;
  dynamic item_weight;
  dynamic sub_title;
  dynamic product_type_fazzmi;
  int? wishlistId;
  dynamic productStore;
  dynamic taxClassId;
  dynamic visibility;
  dynamic status;
  List<dynamic>? options;
  MediaGallery? mediaGallery;
  ExtensionAttributes? extensionAttributes;
  List<dynamic>? tierPrice;
  dynamic tierPriceChanged;
  QuantityAndStockStatus? quantityAndStockStatus;
  List<String>? categoryIds;
  dynamic isSalable;
  List<dynamic>? firstChild;
  dynamic specialPrice;
  dynamic specialFromDate;
  dynamic specialToDate;
  dynamic salable_qty;
  dynamic discount;
  DateTime? deliveryDate;
  dynamic available;
  List<Variation>? variations;

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        cutoffTime: json["cutoff_time"] == null ? null : json["cutoff_time"],
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        attributeSetId:
            json["attribute_set_id"] == null ? null : json["attribute_set_id"],
        typeId: json["type_id"] == null ? null : json["type_id"],
        sku: json["sku"] == null ? null : json["sku"],
        hasOptions: json["has_options"] == null ? null : json["has_options"],
        requiredOptions:
            json["required_options"] == null ? null : json["required_options"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        image: json["image"] == null ? null : json["image"],
        price: json["price"] == null ? null : json["price"],
        msrpDisplayActualPriceType:
            json["msrp_display_actual_price_type"] == null
                ? null
                : json["msrp_display_actual_price_type"],
        urlKey: json["url_key"] == null ? null : json["url_key"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        swatchImage: json["swatch_image"] == null ? null : json["swatch_image"],
        smallImage: json["small_image"] == null ? null : json["small_image"],
        optionsContainer: json["options_container"] == null
            ? null
            : json["options_container"],
        name: json["name"] == null ? null : json["name"],
        metaTitle: json["meta_title"] == null ? null : json["meta_title"],
        metaDescription:
            json["meta_description"] == null ? null : json["meta_description"],
        color: json["color"] == null ? null : json["color"],
        giftMessageAvailable: json["gift_message_available"] == null
            ? null
            : json["gift_message_available"],
        metaKeyword: json["meta_keyword"] == null ? null : json["meta_keyword"],
        shortDescription: json["short_description"] == null
            ? null
            : json["short_description"],
        description: json["description"] == null ? null : json["description"],
        delivery: json["delivery"] == null ? null : json["delivery"],
        size: json["size"] == null ? null : json["size"],
        brand: json["brand"] == null ? null : json["brand"],
        item_weight: json["item_weight"] == null ? null : json["item_weight"],
        sub_title: json["sub_title"] == null ? null : json["sub_title"],
        product_type_fazzmi: json["product_type_fazzmi"] == null
            ? null
            : json["product_type_fazzmi"],
        productStore:
            json["product_store"] == null ? null : json["product_store"],
        taxClassId: json["tax_class_id"] == null ? null : json["tax_class_id"],
        visibility: json["visibility"] == null ? null : json["visibility"],
        status: json["status"] == null ? null : json["status"],
        options: json["options"] == null
            ? null
            : List<dynamic>.from(json["options"].map((x) => x)),
        mediaGallery: json["media_gallery"] == null
            ? null
            : MediaGallery.fromJson(json["media_gallery"]),
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ExtensionAttributes.fromJson(json["extension_attributes"]),
        tierPrice: json["tier_price"] == null
            ? null
            : List<dynamic>.from(json["tier_price"].map((x) => x)),
        tierPriceChanged: json["tier_price_changed"] == null
            ? null
            : json["tier_price_changed"],
        quantityAndStockStatus: json["quantity_and_stock_status"] == null
            ? null
            : QuantityAndStockStatus.fromJson(
                json["quantity_and_stock_status"]),
        categoryIds: json["category_ids"] == null
            ? null
            : List<String>.from(json["category_ids"].map((x) => x)),
        isSalable: json["is_salable"] == null ? null : json["is_salable"],
        firstChild: json["first_child"] == null
            ? null
            : List<dynamic>.from(json["first_child"].map((x) => x)),
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        specialFromDate: json["special_from_date"],
        specialToDate: json["special_to_date"],
        discount: json["discount"] == null ? null : json["discount"],
        deliveryDate: json["delivery_date"] == null
            ? null
            : DateTime.parse(json["delivery_date"]),
        available: json["available"] == null ? null : json["available"],
        wishlistId: json["wishlist_id"] == null ? null : json["wishlist_id"],
        salable_qty: json["salable_qty"] == null ? null : json["salable_qty"],
        variations: json["variations"] == null
            ? null
            : List<Variation>.from(
                json["variations"].map((x) => Variation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wishlist_id": wishlistId == null ? null : wishlistId,
        "cutoff_time": cutoffTime == null ? null : cutoffTime,
        "entity_id": entityId == null ? null : entityId,
        "attribute_set_id": attributeSetId == null ? null : attributeSetId,
        "type_id": typeId == null ? null : typeId,
        "sku": sku == null ? null : sku,
        "has_options": hasOptions == null ? null : hasOptions,
        "required_options": requiredOptions == null ? null : requiredOptions,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "image": image == null ? null : image,
        "salable_qty": salable_qty == null ? null : salable_qty,
        "price": price == null ? null : price,
        "msrp_display_actual_price_type": msrpDisplayActualPriceType == null
            ? null
            : msrpDisplayActualPriceType,
        "url_key": urlKey == null ? null : urlKey,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "swatch_image": swatchImage == null ? null : swatchImage,
        "small_image": smallImage == null ? null : smallImage,
        "options_container": optionsContainer == null ? null : optionsContainer,
        "name": name == null ? null : name,
        "meta_title": metaTitle == null ? null : metaTitle,
        "meta_description": metaDescription == null ? null : metaDescription,
        "color": color == null ? null : color,
        "gift_message_available":
            giftMessageAvailable == null ? null : giftMessageAvailable,
        "meta_keyword": metaKeyword == null ? null : metaKeyword,
        "short_description": shortDescription == null ? null : shortDescription,
        "description": description == null ? null : description,
        "delivery": delivery == null ? null : delivery,
        "size": size == null ? null : size,
        "brand": brand == null ? null : brand,
        "item_weight": item_weight == null ? null : item_weight,
        "product_type_fazzmi":
            product_type_fazzmi == null ? null : product_type_fazzmi,
        "sub_title": sub_title == null ? null : sub_title,
        "product_store": productStore == null ? null : productStore,
        "tax_class_id": taxClassId == null ? null : taxClassId,
        "visibility": visibility == null ? null : visibility,
        "status": status == null ? null : status,
        "options":
            options == null ? null : List<dynamic>.from(options!.map((x) => x)),
        "media_gallery": mediaGallery == null ? null : mediaGallery!.toJson(),
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes!.toJson(),
        "tier_price": tierPrice == null
            ? null
            : List<dynamic>.from(tierPrice!.map((x) => x)),
        "tier_price_changed":
            tierPriceChanged == null ? null : tierPriceChanged,
        "quantity_and_stock_status": quantityAndStockStatus == null
            ? null
            : quantityAndStockStatus!.toJson(),
        "category_ids": categoryIds == null
            ? null
            : List<dynamic>.from(categoryIds!.map((x) => x)),
        "is_salable": isSalable == null ? null : isSalable,
        "first_child": firstChild == null
            ? null
            : List<dynamic>.from(firstChild!.map((x) => x)),
        "special_price": specialPrice == null ? null : specialPrice,
        "special_from_date": specialFromDate,
        "special_to_date": specialToDate,
        "discount": discount == null ? null : discount,
        "delivery_date":
            deliveryDate == null ? null : deliveryDate!.toIso8601String(),
        "available": available == null ? null : available,
        "variations": variations == null
            ? null
            : List<dynamic>.from(variations!.map((x) => x.toJson())),
      };
}

class ExtensionAttributes {
  ExtensionAttributes();

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ExtensionAttributes();

  Map<String, dynamic> toJson() => {};
}

class MediaGallery {
  MediaGallery({
    this.images,
    this.values,
  });

  List<Image>? images;
  List<dynamic>? values;

  factory MediaGallery.fromJson(Map<String, dynamic> json) => MediaGallery(
        images: json["images"] == null
            ? null
            : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        values: json["values"] == null
            ? null
            : List<dynamic>.from(json["values"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "images": images == null
            ? null
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "values":
            values == null ? null : List<dynamic>.from(values!.map((x) => x)),
      };
}

class Image {
  Image({
    this.valueId,
    this.file,
    this.mediaType,
    this.entityId,
    this.label,
    this.position,
    this.disabled,
    this.labelDefault,
    this.positionDefault,
    this.disabledDefault,
    this.videoProvider,
    this.videoUrl,
    this.videoTitle,
    this.videoDescription,
    this.videoMetadata,
    this.videoProviderDefault,
    this.videoUrlDefault,
    this.videoTitleDefault,
    this.videoDescriptionDefault,
    this.videoMetadataDefault,
  });

  dynamic valueId;
  dynamic file;
  dynamic mediaType;
  dynamic entityId;
  dynamic label;
  dynamic position;
  dynamic disabled;
  dynamic labelDefault;
  dynamic positionDefault;
  dynamic disabledDefault;
  dynamic videoProvider;
  dynamic videoUrl;
  dynamic videoTitle;
  dynamic videoDescription;
  dynamic videoMetadata;
  dynamic videoProviderDefault;
  dynamic videoUrlDefault;
  dynamic videoTitleDefault;
  dynamic videoDescriptionDefault;
  dynamic videoMetadataDefault;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        valueId: json["value_id"] == null ? null : json["value_id"],
        file: json["file"] == null ? null : json["file"],
        mediaType: json["media_type"] == null ? null : json["media_type"],
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        label: json["label"],
        position: json["position"] == null ? null : json["position"],
        disabled: json["disabled"] == null ? null : json["disabled"],
        labelDefault: json["label_default"],
        positionDefault:
            json["position_default"] == null ? null : json["position_default"],
        disabledDefault:
            json["disabled_default"] == null ? null : json["disabled_default"],
        videoProvider: json["video_provider"],
        videoUrl: json["video_url"],
        videoTitle: json["video_title"],
        videoDescription: json["video_description"],
        videoMetadata: json["video_metadata"],
        videoProviderDefault: json["video_provider_default"],
        videoUrlDefault: json["video_url_default"],
        videoTitleDefault: json["video_title_default"],
        videoDescriptionDefault: json["video_description_default"],
        videoMetadataDefault: json["video_metadata_default"],
      );

  Map<String, dynamic> toJson() => {
        "value_id": valueId == null ? null : valueId,
        "file": file == null ? null : file,
        "media_type": mediaType == null ? null : mediaType,
        "entity_id": entityId == null ? null : entityId,
        "label": label,
        "position": position == null ? null : position,
        "disabled": disabled == null ? null : disabled,
        "label_default": labelDefault,
        "position_default": positionDefault == null ? null : positionDefault,
        "disabled_default": disabledDefault == null ? null : disabledDefault,
        "video_provider": videoProvider,
        "video_url": videoUrl,
        "video_title": videoTitle,
        "video_description": videoDescription,
        "video_metadata": videoMetadata,
        "video_provider_default": videoProviderDefault,
        "video_url_default": videoUrlDefault,
        "video_title_default": videoTitleDefault,
        "video_description_default": videoDescriptionDefault,
        "video_metadata_default": videoMetadataDefault,
      };
}

class QuantityAndStockStatus {
  QuantityAndStockStatus({
    this.isInStock,
    this.qty,
  });

  bool? isInStock;
  dynamic qty;

  factory QuantityAndStockStatus.fromJson(Map<String, dynamic> json) =>
      QuantityAndStockStatus(
        isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
        qty: json["qty"] == null ? null : json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "is_in_stock": isInStock == null ? null : isInStock,
        "qty": qty == null ? null : qty,
      };
}

class Variation {
  Variation({
    this.title,
    this.reqParam,
    this.attributeId,
    this.content,
  });

  dynamic title;
  dynamic reqParam;
  dynamic attributeId;
  List<Content>? content;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        title: json["title"] == null ? null : json["title"],
        reqParam: json["reqParam"] == null ? null : json["reqParam"],
        attributeId: json["attribute_id"] == null ? null : json["attribute_id"],
        content: json["content"] == null
            ? null
            : List<Content>.from(
                json["content"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "reqParam": reqParam == null ? null : reqParam,
        "attribute_id": attributeId == null ? null : attributeId,
        "content": content == null
            ? null
            : List<dynamic>.from(content!.map((x) => x.toJson())),
      };
}

class Content {
  Content({
    this.id,
    this.reqVal,
    this.image,
    this.available,
  });

  dynamic id;
  dynamic reqVal;
  dynamic image;
  bool? available;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"] == null ? null : json["id"],
        reqVal: json["reqVal"] == null ? null : json["reqVal"],
        image: json["image"] == null ? null : json["image"],
        available: json["available"] == null ? null : json["available"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "reqVal": reqVal == null ? null : reqVal,
        "image": image == null ? null : image,
        "available": available == null ? null : available,
      };
}
