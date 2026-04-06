import 'user_model.dart';

class ContractorModel extends AppUser {
  const ContractorModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.phone,
    super.location,
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
