
class SelectedPlace {
  SelectedPlace({
    this.name,
    this.street,
    this.isoCountryCode,
    this.country,
    this.postalCode,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.locality,
    this.subLocality,
    this.thoroughfare,
    this.subThoroughfare,
    this.latitude,
    this.longitude,
    this.region,
    this.regionId,
  });

  final String? administrativeArea;
  final String? country;
  final String? isoCountryCode;
  final String? locality;
  final String? name;
  final String? postalCode;
  final String? street;
  final String? subAdministrativeArea;
  final String? subLocality;
  final String? subThoroughfare;
  final String? thoroughfare;
  double? latitude;
  double? longitude;
  final String? region;
  final String? regionId;
}
