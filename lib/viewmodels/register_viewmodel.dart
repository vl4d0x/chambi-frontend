import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import 'auth_viewmodel.dart';

class RegisterViewModel extends ChangeNotifier {
  final UserRole role;
  RegisterViewModel({required this.role});

  // ── Step tracking ──────────────────────────────────────────────────────────

  int _currentStep = 0;
  bool _isGooglePath = false;

  int get currentStep => _currentStep;
  bool get isGooglePath => _isGooglePath;

  /// Contractor: 3 steps (credentials, identity, address)
  /// Tasker: 4 steps (credentials, identity, address, photo)
  int get totalSteps => role == UserRole.tasker ? 4 : 3;

  // ── Step 0 — Credentials ──────────────────────────────────────────────────

  String email = '';
  String password = '';
  String confirmPassword = '';
  String? _emailError;
  bool isCheckingEmail = false;

  String? get emailError => _emailError;

  /// Mock email availability check.
  /// TODO(backend): Replace with a real REST call: GET /users/check-email?email=...
  Future<void> validateEmailAsync() async {
    isCheckingEmail = true;
    _emailError = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    // Mock: "taken@example.com" simulates an already-registered address
    _emailError =
        email.trim() == 'taken@example.com' ? 'Email is already in use.' : null;
    isCheckingEmail = false;
    notifyListeners();
  }

  /// Mock Google sign-in. Pre-fills name and jumps to step 1.
  /// TODO(backend): Replace with GoogleSignIn().signIn() flow.
  Future<void> startWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _isGooglePath = true;
    email = 'alex@gmail.com';
    name = 'Alex Johnson';
    _currentStep = 1;
    notifyListeners();
  }

  // ── Step 1 — Identity ─────────────────────────────────────────────────────

  String name = '';
  String phone = '';

  // ── Step 2 — Address ──────────────────────────────────────────────────────

  /// Fully built address (name + coords + type). Set by AddressPickerWidget
  /// only once both the location and the user-provided name are confirmed.
  AddressModel? address;

  void setAddress(AddressModel a) {
    address = a;
    notifyListeners();
  }

  // ── Step 3 — Profile Photo (tasker only) ──────────────────────────────────

  XFile? profilePhoto;

  void setProfilePhoto(XFile? file) {
    profilePhoto = file;
    notifyListeners();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  bool get canGoBack => _currentStep > 0;

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // ── Step-level validation ──────────────────────────────────────────────────

  /// Returns an error message if the current step is incomplete, otherwise null.
  String? validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (!_isGooglePath) {
          if (email.trim().isEmpty) return 'Please enter your email.';
          if (!email.contains('@')) return 'Please enter a valid email.';
          if (password.length < 6) return 'Password must be at least 6 characters.';
          if (password != confirmPassword) return 'Passwords do not match.';
          if (_emailError != null) return _emailError;
        }
        return null;
      case 1:
        if (name.trim().isEmpty) return 'Please enter your full name.';
        if (phone.trim().isEmpty) return 'Please enter your phone number.';
        return null;
      case 2:
        if (address == null) return 'Please select an address and give it a name.';
        return null;
      default:
        // Photo steps (3, 4) are optional
        return null;
    }
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  bool isSubmitting = false;
  String? submitError;

  Future<bool> submit(AuthViewModel authVm) async {
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    bool success;

    if (role == UserRole.contractor) {
      success = await authVm.registerContractor(
        name: name.trim(),
        email: email.trim(),
        password: _isGooglePath ? '' : password,
        phone: phone.trim(),
        location: address,
        isGooglePath: _isGooglePath,
      );
    } else {
      success = await authVm.registerTasker(
        name: name.trim(),
        email: email.trim(),
        password: _isGooglePath ? '' : password,
        phone: phone.trim(),
        location: address,
        profilePhotoPath: profilePhoto?.path,
        isGooglePath: _isGooglePath,
      );
    }

    if (!success) {
      submitError = authVm.errorMessage ?? 'Registration failed. Please try again.';
    }

    isSubmitting = false;
    notifyListeners();
    return success;
  }
}
