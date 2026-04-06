enum AddressType { house, apartment, office, other }

extension AddressTypeLabel on AddressType {
  String get label {
    switch (this) {
      case AddressType.house:
        return 'House';
      case AddressType.apartment:
        return 'Apartment';
      case AddressType.office:
        return 'Office';
      case AddressType.other:
        return 'Other';
    }
  }
}

class AddressModel {
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final AddressType type;
  final String? streetLine;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  const AddressModel({
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    this.type = AddressType.house,
    this.streetLine,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  AddressModel copyWith({AddressType? type}) {
    return AddressModel(
      formattedAddress: formattedAddress,
      latitude: latitude,
      longitude: longitude,
      type: type ?? this.type,
      streetLine: streetLine,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
    );
  }

  /// Serialized for sending to the Spring REST backend.
  /// Store latitude/longitude as plain doubles — ready for PostGIS migration later.
  Map<String, dynamic> toJson() => {
        'formattedAddress': formattedAddress,
        'latitude': latitude,
        'longitude': longitude,
        'addressType': type.name.toUpperCase(),
        if (streetLine != null) 'streetLine': streetLine,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zipCode != null) 'zipCode': zipCode,
        if (country != null) 'country': country,
      };
}
