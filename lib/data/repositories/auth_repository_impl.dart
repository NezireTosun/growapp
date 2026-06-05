import 'package:growapp/core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<User?> getCurrentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;
    try {
      return await _mapFirebaseUserWithFirestore(fbUser);
    } catch (e) {
      AppLogger.e('[AuthRepository]', 'getCurrentUser Firestore error', e);
      // Firestore erişilemese bile temel Firebase Auth bilgisiyle devam et
      return User(
        id: fbUser.uid,
        name: fbUser.displayName ?? '',
        email: fbUser.email ?? '',
        planId: 'free',
        emailVerified: fbUser.emailVerified,
        isActive: true,
        createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
      );
    }
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Check if account is deactivated
    final userDoc = await _db.collection('users').doc(credential.user!.uid).get();
    final isActive = userDoc.data()?['is_active'] as bool? ?? true;
    if (!isActive) {
      await _auth.signOut();
      throw Exception('account_deactivated');
    }

    return _mapFirebaseUserWithFirestore(credential.user!);
  }

  @override
  Future<User> signUp({required String name, required String email, required String password, String? phone}) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Deactivated account kontrolü — kullanıcı authenticate olduktan sonra
    final existingDoc = await _db.collection('users').doc(credential.user!.uid).get();
    if (existingDoc.exists && existingDoc.data()?['is_active'] == false) {
      await _auth.signOut();
      throw Exception('account_deactivated');
    }

    final fbUser = credential.user!;
    await fbUser.updateDisplayName(name);

    // Save user document to Firestore
    await _db.collection('users').doc(fbUser.uid).set({
      'fullname': name,
      'email': email,
      'phone': phone ?? '',
      'plan_id': 'free',
      'is_active': true,
      'email_verified': false,
      'created_at': FieldValue.serverTimestamp(),
      'last_login': FieldValue.serverTimestamp(),
    });

    return User(
      id: fbUser.uid,
      name: name,
      email: email,
      phone: phone,
      planId: 'free',
      emailVerified: false,
      isActive: true,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final fbUser = _auth.currentUser;
    if (fbUser != null && !fbUser.emailVerified) {
      await fbUser.sendEmailVerification();
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return false;
    await fbUser.reload();
    return fbUser.emailVerified;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> sendPasswordResetCode(String email, {String locale = 'tr'}) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'sendPasswordResetCode',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      // Email artık Functions tarafından SMTP ile gönderilir
      await callable.call({'email': email, 'locale': locale});
    } on FirebaseFunctionsException catch (e) {
      AppLogger.e('[AuthRepo]', 'sendPasswordResetCode error: ${e.code} ${e.message}', e);
      throw Exception(e.code);
    }
  }

  @override
  Future<bool> verifyPasswordResetCode(String email, String code) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'verifyPasswordResetCode',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      await callable.call({'email': email, 'code': code});
      return true;
    } on FirebaseFunctionsException catch (e) {
      AppLogger.e('[AuthRepo]', 'verifyPasswordResetCode error: ${e.code} ${e.message}', e);
      if (e.code == 'deadline-exceeded') throw Exception('expired');
      return false;
    }
  }

  @override
  Future<void> confirmNewPassword(String email, String code, String newPassword) async {
    // Cloud Function public invoker ile çalışıyor — auth gerekmez
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'resetPasswordWithCode',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      await callable.call({'email': email, 'code': code, 'newPassword': newPassword});
    } on FirebaseFunctionsException catch (e) {
      AppLogger.e('[AuthRepo]', 'resetPasswordWithCode error: code=${e.code} message=${e.message}', e);
      throw Exception(e.code);
    }
  }

  @override
  Future<void> deactivateAccount() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return;

    // Set is_active to false in Firestore
    await _db.collection('users').doc(fbUser.uid).set({
      'is_active': false,
      'deactivated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Sign out
    await _auth.signOut();
  }

  @override
  Future<void> updatePhone(String userId, String phone) async{
    await _db.collection('users').doc(userId).set({
      'phone': phone,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateName(String userId, String name) async {
    await _db.collection('users').doc(userId).set({
      'fullname': name,
    }, SetOptions(merge: true));

    final fbUser = _auth.currentUser;
    if (fbUser != null) {
      await fbUser.updateDisplayName(name);
    }
  }

  static const _demoEmail = 'sunssquad988@gmail.com';
  static const _demoBypassCode = '000000';

  @override
  Future<void> sendVerificationCode({String locale = 'tr'}) async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return;

    // Demo hesabı için kod gönderme — bypass aktif, sabit kod 000000
    if (fbUser.email?.toLowerCase() == _demoEmail) {
      // Firestore'a sabit kodu yaz — reviewer manuel girişte de çalışsın
      final expires = DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch;
      await _db.collection('users').doc(fbUser.uid).set({
        'verification_code': _demoBypassCode,
        'verification_code_expires': expires,
      }, SetOptions(merge: true));
      return;
    }

    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'sendVerificationCode',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      await callable.call({'locale': locale});
    } on FirebaseFunctionsException catch (e) {
      AppLogger.e('[AuthRepo]', 'sendVerificationCode error: ${e.code} ${e.message}', e);
      throw Exception(e.code);
    }
  }

  @override
  Future<bool> verifyCode(String code) async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return false;

    // Demo hesabı için sabit kod ile bypass — App Store review için
    if (fbUser.email?.toLowerCase() == _demoEmail && code == _demoBypassCode) {
      await _db.collection('users').doc(fbUser.uid).set({
        'email_verified': true,
      }, SetOptions(merge: true));
      return true;
    }

    // Firestore'dan kodu kontrol et
    final doc = await _db.collection('users').doc(fbUser.uid).get();
    final data = doc.data();
    final storedCode = data?['verification_code'] as String?;
    final expires = data?['verification_code_expires'] as int?;

    if (storedCode == null || expires == null) return false;
    if (DateTime.now().millisecondsSinceEpoch > expires) return false;
    if (storedCode != code) return false;

    // Doğrulandı — temizle ve kaydet
    await _db.collection('users').doc(fbUser.uid).update({
      'email_verified': true,
      'verification_code': FieldValue.delete(),
      'verification_code_expires': FieldValue.delete(),
    });

    return true;
  }

  Future<User> _mapFirebaseUserWithFirestore(fb.User fbUser) async {
    final doc = await _db.collection('users').doc(fbUser.uid).get();
    final data = doc.data();
    final lastLoginTs = data?['last_login'] as Timestamp?;

    // Update last_login + email_verified sync
    await _db.collection('users').doc(fbUser.uid).set({
      'last_login': FieldValue.serverTimestamp(),
      if (fbUser.emailVerified) 'email_verified': true,
    }, SetOptions(merge: true));

    final resolvedName = data?['fullname'] as String? ?? fbUser.displayName ?? '';

    return User(
      id: fbUser.uid,
      name: resolvedName,
      email: fbUser.email ?? '',
      phone: data?['phone'] as String?,
      planId: data?['plan_id'] as String? ?? 'free',
      // Firebase Auth her zaman doğru kaynak — Firestore'daki eski false değeri override edilmemeli
      emailVerified: fbUser.emailVerified || (data?['email_verified'] as bool? ?? false),
      isActive: data?['is_active'] as bool? ?? true,
      createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
      lastLogin: lastLoginTs?.toDate(),
    );
  }
}
