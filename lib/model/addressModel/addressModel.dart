// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  AddressModel({
    this.status,
    this.data,
  });

  int? status;
  List<AddressData>? data;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        status: json["status"],
        data: List<AddressData>.from(
            json["data"].map((x) => AddressData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AddressData {
  AddressData({
    this.addressId,
    this.addressType,
    this.firstname,
    this.lastname,
    this.country,
    this.countryId,
    this.regionId,
    this.region,
    this.city,
    this.street,
    this.addressLine1,
    this.addressLine2,
    this.phoneCode,
    this.telephone,
    this.postcode,
    this.mobile,
    this.area,
    this.building,
    this.apartmentNumber,
    this.floor,
    this.note,
    this.latitude,
    this.longitude,
    this.isDefaultBilling,
    this.isDefaultShipping,
  });

  String? addressId;
  dynamic addressType;
  String? firstname;
  String? lastname;
  String? country;
  String? countryId;
  String? regionId;
  String? region;
  String? city;
  String? street;
  String? addressLine1;
  String? addressLine2;
  String? phoneCode;
  String? telephone;
  String? postcode;
  String? mobile;
  String? area;
  String? building;
  String? apartmentNumber;
  String? floor;
  String? note;
  String? latitude;
  String? longitude;
  int? isDefaultBilling;
  int? isDefaultShipping;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        addressId: json["address_id"],
        addressType: json["address_type"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        country: json["country"],
        countryId: json["country_id"],
        regionId: json["region_id"],
        region: json["region"],
        city: json["city"],
        street: json["street"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        phoneCode: json["phone_code"],
        telephone: json["telephone"],
        postcode: json["postcode"],
        mobile: json["mobile"],
        area: json["area"],
        building: json["building"],
        apartmentNumber: json["apartment_number"],
        floor: json["floor"],
        note: json["note"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isDefaultBilling: json["is_default_billing"],
        isDefaultShipping: json["is_default_shipping"],
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "address_type": addressType,
        "firstname": firstname,
        "lastname": lastname,
        "country": country,
        "country_id": countryId,
        "region_id": regionId,
        "region": region,
        "city": city,
        "street": street,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "phone_code": phoneCode,
        "telephone": telephone,
        "postcode": postcode,
        "mobile": mobile,
        "area": area,
        "building": building,
        "apartment_number": apartmentNumber,
        "floor": floor,
        "note": note,
        "latitude": latitude,
        "longitude": longitude,
        "is_default_billing": isDefaultBilling,
        "is_default_shipping": isDefaultShipping,
      };
}
