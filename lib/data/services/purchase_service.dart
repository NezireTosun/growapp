import 'package:growapp/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../domain/repositories/purchase_repository.dart';

class PurchaseService implements PurchaseRepository {
  static const String _proEntitlement = 'Grow APP Pro';

  static const _iosApiKey = String.fromEnvironment('REVENUECAT_IOS_KEY');
  static const _androidApiKey = String.fromEnvironment('REVENUECAT_ANDROID_KEY');

  static bool _configured = false;

  PurchaseService();

  /// RevenueCat SDK'yı başlatır. main.dart'ta çağrılmalı.
  Future<void> initialize() async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
    final key = defaultTargetPlatform == TargetPlatform.android ? _androidApiKey : _iosApiKey;
    if (key.isEmpty) {
      AppLogger.e('[PurchaseService]', 'RevenueCat API key eksik — initialize atlanıyor');
      return;
    }
    await Purchases.configure(PurchasesConfiguration(key));
    _configured = true;
  }

  /// Kullanıcıyı RevenueCat'e tanıtır (login sonrası çağrılmalı)
  Future<void> login(String userId) async {
    if (!_configured) return;
    await Purchases.logIn(userId);
  }

  /// Logout (çıkış yapınca çağrılmalı)
  @override
  Future<void> logout() async {
    if (!_configured) return;
    await Purchases.logOut();
  }

  /// Mevcut subscriber bilgisini getirir
  Future<CustomerInfo> getCustomerInfo() async {
    return Purchases.getCustomerInfo();
  }

  /// Kullanıcının pro üye olup olmadığını kontrol eder
  Future<bool> checkProStatus() async {
    if (!_configured) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(_proEntitlement);
    } catch (e) {
      AppLogger.e('[PurchaseService]', 'checkProStatus error', e);
      return false;
    }
  }

  /// Mevcut teklifleri getirir (fiyat göstermek için)
  Future<Offerings?> getOfferings() async {
    if (!_configured) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      AppLogger.e('[PurchaseService]', 'getOfferings error', e);
      return null;
    }
  }

  /// Pro planı satın alır
  Future<CustomerInfo> purchasePro() async {
    if (!_configured) throw Exception('product-not-found');
    final Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
    } catch (e) {
      AppLogger.e('[PurchaseService]', 'getOfferings error', e);
      throw Exception('product-not-found');
    }
    final package = offerings.current?.monthly;
    if (package == null) throw Exception('product-not-found');
    return Purchases.purchasePackage(package);
  }

  /// Önceki satın almaları geri yükler
  Future<CustomerInfo> restorePurchases() async {
    if (!_configured) throw Exception('not-configured');
    return Purchases.restorePurchases();
  }

  /// CustomerInfo'dan pro durumunu okur
  bool isProFromCustomerInfo(CustomerInfo info) {
    return info.entitlements.active.containsKey(_proEntitlement);
  }

  /// Pro planın fiyat string'ini getirir (ör. "₺299,99/ay")
  Future<String?> getProMonthlyPrice() async {
    if (!_configured) return null;
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.monthly?.storeProduct.priceString;
    } catch (e) {
      return null;
    }
  }
}
