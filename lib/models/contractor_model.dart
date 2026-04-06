import 'user_model.dart';

class ContractorModel extends AppUser {
  /// Only populated on the create path (registration).
  /// Never received from the backend — always null after a fetch.
  final String? password;

  const ContractorModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.phone,
    super.location,
    this.password,
  });

  @override
  UserRole get role => UserRole.contractor;

  ContractorModel copyWith({
    String? name,
    String? avatarUrl,
    String? phone,
    AddressModel? location,
  }) {
    return ContractorModel(
      id: id,
      name: name ?? this.name,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }
}
