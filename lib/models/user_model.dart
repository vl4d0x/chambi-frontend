export 'address_model.dart';

enum UserRole { contractor, tasker }

enum AuthStatus { unauthenticated, authenticated }

/// Shared base class for both user types.
/// Use [ContractorModel] or [TaskerModel] directly — never instantiate AppUser.
/// Location is NOT stored here because each role handles it differently:
/// - ContractorModel holds List<AddressModel> locations (multiple)
/// - TaskerModel holds AddressModel? location (single)
abstract class AppUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
  });

  UserRole get role;
}
