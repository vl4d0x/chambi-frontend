import 'user_model.dart';

class ContractorModel extends AppUser {
  /// Only populated on the create path (registration).
  /// Never received from the backend — always null after a fetch.
  final String? password;

  /// A contractor may have multiple named locations
  /// (e.g. "Home", "Main Office", "Grandma's house").
  final List<AddressModel> locations;

  const ContractorModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.phone,
    this.password,
    this.locations = const [],
  });

  @override
  UserRole get role => UserRole.contractor;

  ContractorModel copyWith({
    String? name,
    String? avatarUrl,
    String? phone,
    List<AddressModel>? locations,
  }) {
    return ContractorModel(
      id: id,
      name: name ?? this.name,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      locations: locations ?? this.locations,
    );
  }
}
