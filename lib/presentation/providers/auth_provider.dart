import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../data/services/purchase_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final PurchaseRepository _purchaseRepository;

  AuthProvider(this._authRepository, {PurchaseRepository? purchaseRepository})
      : _purchaseRepository = purchaseRepository ?? PurchaseService();

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _emailVerified = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;
  bool get emailVerified => _emailVerified;

  Future<void> checkCurrentUser() async {
    try {
      _user = await _authRepository.getCurrentUser();
    } catch (e) {
      debugPrint('[AuthProvider] checkCurrentUser error: $e');
      _user = null;
    }
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.signIn(email: email, password: password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp({required String name, required String email, required String password, String? phone}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.signUp(name: name, email: email, password: password, phone: phone);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _authRepository.sendEmailVerification();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> checkEmailVerified() async {
    _emailVerified = await _authRepository.isEmailVerified();
    notifyListeners();
    return _emailVerified;
  }

  Future<void> sendVerificationCode({String locale = 'tr'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.sendVerificationCode(locale: locale);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyCode(String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final verified = await _authRepository.verifyCode(code);
      if (verified) {
        _emailVerified = true;
      }
      return verified;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetCode(String email, {String locale = 'tr'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.sendPasswordResetCode(email, locale: locale);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyPasswordResetCode(String email, String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authRepository.verifyPasswordResetCode(email, code);
      return result;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmNewPassword(String email, String code, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.confirmNewPassword(email, code, newPassword);
    } catch (e) {
      _error = e.toString();
      debugPrint('[AuthProvider] confirmNewPassword error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deactivateAccount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.deactivateAccount();
      _user = null;
      _emailVerified = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePhone(String phone) async {
    if (_user == null) return;
    await _authRepository.updatePhone(_user!.id, phone);
    _user = User(
      id: _user!.id,
      name: _user!.name,
      email: _user!.email,
      phone: phone,
      planId: _user!.planId,
      emailVerified: _user!.emailVerified,
      isActive: _user!.isActive,
      createdAt: _user!.createdAt,
      lastLogin: _user!.lastLogin,
    );
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    if (_user == null) return;
    await _authRepository.updateName(_user!.id, name);
    _user = User(
      id: _user!.id,
      name: name,
      email: _user!.email,
      phone: _user!.phone,
      planId: _user!.planId,
      emailVerified: _user!.emailVerified,
      isActive: _user!.isActive,
      createdAt: _user!.createdAt,
      lastLogin: _user!.lastLogin,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await _purchaseRepository.logout();
    await _authRepository.signOut();
    _user = null;
    _emailVerified = false;
    _error = null;
    notifyListeners();
  }
}
