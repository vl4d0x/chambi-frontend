import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  UserRole? _selectedRole;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserRole? get selectedRole => _selectedRole;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

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
    _currentUser = UserModel(
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
    _currentUser = UserModel(
      id: 'mock-google-uid-001',
      name: 'Alex Johnson',
      email: 'alex@gmail.com',
      role: _selectedRole ?? UserRole.contractor,
    );

    _setLoading(false);
    return true;
  }

  // ─── Contractor Registration ───────────────────────────────────────────────

  /// TODO(backend): Replace with Firebase Auth createUserWithEmailAndPassword,
  /// then write a Firestore/REST document with role: 'contractor' and location fields.
  /// Location: send location.toJson() — backend stores latitude/longitude as doubles
  /// and addressType as string. Future migration to PostGIS is additive only.
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
    _currentUser = UserModel(
      id: 'mock-contractor-001',
      name: name,
      email: email,
      role: UserRole.contractor,
      phone: phone,
      location: location,
    );

    _setLoading(false);
    return true;
  }

  // ─── Tasker Registration ───────────────────────────────────────────────────

  /// TODO(backend): Replace with Firebase Auth createUserWithEmailAndPassword,
  /// upload avatar and portfolio images to Firebase Storage,
  /// then write a REST document with role: 'tasker' and location + image URLs.
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
    _currentUser = UserModel(
      id: 'mock-tasker-001',
      name: name,
      email: email,
      role: UserRole.tasker,
      phone: phone,
      location: location,
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
