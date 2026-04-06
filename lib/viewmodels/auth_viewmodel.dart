import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/contractor_model.dart';
import '../models/tasker_model.dart';

class AuthViewModel extends ChangeNotifier {
  UserRole? _selectedRole;
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserRole? get selectedRole => _selectedRole;
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Typed getters — null if the current user is not that role
  ContractorModel? get currentContractor =>
      _currentUser is ContractorModel ? _currentUser as ContractorModel : null;
  TaskerModel? get currentTasker =>
      _currentUser is TaskerModel ? _currentUser as TaskerModel : null;

  // ─── Role Selection ────────────────────────────────────────────────────────

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  // ─── Login ─────────────────────────────────────────────────────────────────

  /// TODO(backend): Replace with real Firebase Auth email/password sign-in.
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(milliseconds: 800));

    if (email.isEmpty || password.length < 6) {
      _errorMessage = 'Please enter a valid email and password.';
      _setLoading(false);
      return false;
    }

    // TODO(backend): Remove mock user.
    _currentUser = _mockUserForRole(
      id: 'mock-uid-001',
      name: 'Alex Johnson',
      email: email,
      role: _selectedRole ?? UserRole.contractor,
    );

    _setLoading(false);
    return true;
  }

  /// TODO(backend): Replace with Firebase Google Sign-In.
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(milliseconds: 1000));

    // TODO(backend): Remove mock user.
    _currentUser = _mockUserForRole(
      id: 'mock-google-uid-001',
      name: 'Alex Johnson',
      email: 'alex@gmail.com',
      role: _selectedRole ?? UserRole.contractor,
    );

    _setLoading(false);
    return true;
  }

  // ─── Contractor Registration ───────────────────────────────────────────────

  /// TODO(backend): Replace with real REST call to POST /api/contractors.
  /// Send ContractorModel fields as JSON; backend stores lat/lng as doubles
  /// (PostGIS migration is additive — no contract change needed).
  Future<bool> registerContractor({
    required String name,
    required String email,
    required String password,
    required String phone,
    AddressModel? location,
    bool isGooglePath = false,
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(milliseconds: 1000));

    // TODO(backend): Remove mock user.
    _currentUser = ContractorModel(
      id: 'mock-contractor-001',
      name: name,
      email: email,
      phone: phone,
      location: location,
      password: isGooglePath ? null : password,
    );

    _setLoading(false);
    return true;
  }

  // ─── Tasker Registration ───────────────────────────────────────────────────

  /// TODO(backend): Replace with real REST call to POST /api/taskers.
  /// Upload avatar and portfolio images first, then send TaskerModel fields
  /// including image URLs and location.toJson().
  Future<bool> registerTasker({
    required String name,
    required String email,
    required String password,
    required String phone,
    AddressModel? location,
    String? profilePhotoPath,
    List<String> portfolioPhotoPaths = const [],
    bool isGooglePath = false,
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(milliseconds: 1200));

    // TODO(backend): Remove mock user.
    _currentUser = TaskerModel(
      id: 'mock-tasker-001',
      name: name,
      email: email,
      phone: phone,
      location: location,
      password: isGooglePath ? null : password,
    );

    _setLoading(false);
    return true;
  }

  // ─── Logout ────────────────────────────────────────────────────────────────

  /// TODO(backend): Call FirebaseAuth.instance.signOut() and GoogleSignIn().signOut()
  Future<void> logout() async {
    _currentUser = null;
    _selectedRole = null;
    notifyListeners();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  AppUser _mockUserForRole({
    required String id,
    required String name,
    required String email,
    required UserRole role,
  }) {
    return role == UserRole.tasker
        ? TaskerModel(id: id, name: name, email: email)
        : ContractorModel(id: id, name: name, email: email);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
