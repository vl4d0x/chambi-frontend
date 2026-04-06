import 'address_model.dart';

export 'address_model.dart';

enum UserRole { contractor, tasker }

enum AuthStatus { unauthenticated, authenticated }

/// Shared base class for both user types.
/// Use [ContractorModel] or [TaskerModel] directly — never instantiate AppUser.
abstract class AppUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final AddressModel? location;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
    this.location,
  });

  UserRole get role;
}
