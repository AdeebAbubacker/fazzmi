class SerarchServiceModel {
  int? status;
  int? code;
  String? message;
  Data? data;

  SerarchServiceModel({this.status, this.code, this.message, this.data});

  SerarchServiceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Products>? products;
  List<Store>? store;

  Data({this.products, this.store});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    if (json['store'] != null) {
      store = <Store>[];
      json['store'].forEach((v) {
        store!.add(new Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.store != null) {
      data['store'] = this.store!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? id;
  String? name;
  String? sku;
  String? price;
  String? specialPrice;
  String? image;
  String? storeId;
  String? storeName;
  String? shopType;
  String? parentCategoryId;

  Products(
      {this.id,
      this.name,
      this.sku,
      this.price,
      this.specialPrice,
      this.image,
      this.storeId,
      this.storeName,
      this.shopType,
      this.parentCategoryId});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    price = json['price'];
    specialPrice = json['special_price'];
    image = json['image'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    shopType = json['shop_type'];
    parentCategoryId = json['parent_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['special_price'] = this.specialPrice;
    data['image'] = this.image;
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['shop_type'] = this.shopType;
    data['parent_category_id'] = this.parentCategoryId;
    return data;
  }
}

class Store {
  String? storeId;
  String? name;
  String? description;
  String? deliveryDate;
  String? shopType;
  String? parentCategoryId;
  String? image;

  Store(
      {this.storeId,
      this.name,
      this.description,
      this.deliveryDate,
      this.shopType,
      this.parentCategoryId,
      this.image});

  Store.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    name = json['name'];
    description = json['description'];
    deliveryDate = json['delivery_date'];
    shopType = json['shop_type'];
    parentCategoryId = json['parent_category_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['delivery_date'] = this.deliveryDate;
    data['shop_type'] = this.shopType;
    data['parent_category_id'] = this.parentCategoryId;
    data['image'] = this.image;
    return data;
  }
}
