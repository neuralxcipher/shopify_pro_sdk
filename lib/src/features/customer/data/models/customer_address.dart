/// CustomerAddress model for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// A shipping/billing address associated with a Shopify customer.
final class CustomerAddress {
  const CustomerAddress({
    required this.id,
    this.address1,
    this.address2,
    this.city,
    this.company,
    this.country,
    this.countryCodeV2,
    this.firstName,
    this.lastName,
    this.phone,
    this.province,
    this.provinceCode,
    this.zip,
    this.isDefault = false,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        id: json['id'] as String,
        address1: json['address1'] as String?,
        address2: json['address2'] as String?,
        city: json['city'] as String?,
        company: json['company'] as String?,
        country: json['country'] as String?,
        countryCodeV2: json['countryCodeV2'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        province: json['province'] as String?,
        provinceCode: json['provinceCode'] as String?,
        zip: json['zip'] as String?,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  final String id;
  final String? address1;
  final String? address2;
  final String? city;
  final String? company;
  final String? country;
  final String? countryCodeV2;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? province;
  final String? provinceCode;
  final String? zip;
  final bool isDefault;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  String get formattedAddress => [
        if (address1 != null) address1,
        if (address2 != null) address2,
        if (city != null) city,
        if (province != null) province,
        if (zip != null) zip,
        if (country != null) country,
      ].join(', ');

  Map<String, dynamic> toJson() => {
        'id': id,
        if (address1 != null) 'address1': address1,
        if (address2 != null) 'address2': address2,
        if (city != null) 'city': city,
        if (company != null) 'company': company,
        if (country != null) 'country': country,
        if (countryCodeV2 != null) 'countryCodeV2': countryCodeV2,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (phone != null) 'phone': phone,
        if (province != null) 'province': province,
        if (zip != null) 'zip': zip,
        'isDefault': isDefault,
      };

  Map<String, dynamic> toInputJson() => {
        if (address1 != null) 'address1': address1,
        if (address2 != null) 'address2': address2,
        if (city != null) 'city': city,
        if (company != null) 'company': company,
        if (country != null) 'country': country,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (phone != null) 'phone': phone,
        if (province != null) 'province': province,
        if (zip != null) 'zip': zip,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAddress &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
