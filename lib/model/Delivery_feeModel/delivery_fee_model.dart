class DeliveryFeeModel {
  String? carrierCode;
  String? methodCode;
  String? carrierTitle;
  String? methodTitle;
  int? amount;
  int? baseAmount;
  bool? available;
  String? errorMessage;
  int? priceExclTax;
  int? priceInclTax;

  DeliveryFeeModel(
      {this.carrierCode,
      this.methodCode,
      this.carrierTitle,
      this.methodTitle,
      this.amount,
      this.baseAmount,
      this.available,
      this.errorMessage,
      this.priceExclTax,
      this.priceInclTax});

  DeliveryFeeModel.fromJson(Map<String, dynamic> json) {
    carrierCode = json['carrier_code'];
    methodCode = json['method_code'];
    carrierTitle = json['carrier_title'];
    methodTitle = json['method_title'];
    amount = json['amount'];
    baseAmount = json['base_amount'];
    available = json['available'];
    errorMessage = json['error_message'];
    priceExclTax = json['price_excl_tax'];
    priceInclTax = json['price_incl_tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carrier_code'] = this.carrierCode;
    data['method_code'] = this.methodCode;
    data['carrier_title'] = this.carrierTitle;
    data['method_title'] = this.methodTitle;
    data['amount'] = this.amount;
    data['base_amount'] = this.baseAmount;
    data['available'] = this.available;
    data['error_message'] = this.errorMessage;
    data['price_excl_tax'] = this.priceExclTax;
    data['price_incl_tax'] = this.priceInclTax;
    return data;
  }
}
