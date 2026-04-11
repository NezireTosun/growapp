import '../entities/user.dart';

/// Temel kimlik doğrulama işlemleri.
abstract class AuthRepository
    implements
        CoreAuthRepository,
        EmailVerificationRepository,
        PasswordResetRepository,
        ProfileRepository {}

/// Giriş / çıkış / kayıt.
abstract class CoreAuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signIn({required String email, required String password});
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
  Future<void> signOut();
  Future<void> deactivateAccount();
}

/// E-posta doğrulama akışı.
abstract class EmailVerificationRepository {
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<void> sendVerificationCode({String locale = 'tr'});
  Future<bool> verifyCode(String code);
}

/// Şifre sıfırlama akışı.
abstract class PasswordResetRepository {
  Future<void> resetPassword(String email);
  Future<void> sendPasswordResetCode(String email, {String locale = 'tr'});
  Future<bool> verifyPasswordResetCode(String email, String code);
  Future<void> confirmNewPassword(String email, String code, String newPassword);
}

/// Profil güncelleme.
abstract class ProfileRepository {
  Future<void> updatePhone(String userId, String phone);
  Future<void> updateName(String userId, String name);
}
