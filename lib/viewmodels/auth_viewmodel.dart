import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';

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
  /// Call: FirebaseAuth.instance.signInWithEmailAndPassword(email, password)
  /// Then fetch user document from Firestore to populate UserModel.
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(milliseconds: 800)); // mock delay

    // Mock validation – remove when backend is connected
    if (email.isEmpty || password.length < 6) {
      _errorMessage = 'Please enter a valid email and password.';
      _setLoading(false);
      return false;
    }

    // TODO(backend): Remove mock user. Fetch real user from Firestore after auth.
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
  /// Call: GoogleSignIn().signIn() → GoogleAuthProvider.credential() →
  /// FirebaseAuth.instance.signInWithCredential(credential)
  /// Then upsert user document in Firestore.
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _clearError();

    await Future.delayed(const Duration(milliseconds: 1000)); // mock delay

    // TODO(backend): Remove mock user. Populate from Google account + Firestore.
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
  /// then write a Firestore document to /users/{uid} with role: 'contractor'
  /// and address fields.
  Future<bool> registerContractor({
    required String name,
    required String email,
    required String password,
    required String address,
    required String city,
    required String zipCode,
    required String phone,
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
      address: address,
      city: city,
      zipCode: zipCode,
    );

    _setLoading(false);
    return true;
  }

  // ─── Tasker Registration ───────────────────────────────────────────────────

  /// TODO(backend): Replace with Firebase Auth createUserWithEmailAndPassword,
  /// then upload avatar and portfolio images to Firebase Storage,
  /// then write a Firestore document to /users/{uid} with role: 'tasker',
  /// skills, bio, and the Storage download URLs for images.
  Future<bool> registerTasker({
    required String name,
    required String email,
    required String password,
    required List<String> skills,
    required String bio,
    // TODO(backend): Change these to List<File> or List<XFile> for real upload
    required List<String> portfolioImagePaths,
    required String? avatarImagePath,
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
      skills: skills,
      bio: bio,
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
