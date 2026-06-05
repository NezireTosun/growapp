import 'package:growapp/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../data/services/purchase_service.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/plan.dart';
import '../../domain/repositories/business_repository.dart';
import '../../domain/repositories/plan_repository.dart';

class BusinessProvider extends ChangeNotifier {
  final BusinessRepository _businessRepository;
  final PlanRepository _planRepository;
  final PurchaseService _purchaseService;

  BusinessProvider(
    this._businessRepository,
    this._planRepository, {
    PurchaseService? purchaseService,
  }) : _purchaseService = purchaseService ?? PurchaseService();

  bool _isPurchasing = false;
  String? _purchaseError;

  bool get isPurchasing => _isPurchasing;
  String? get purchaseError => _purchaseError;

  List<Business> _businesses = [];
  Business? _activeBusiness;
  Plan? _currentPlan;
  bool _isLoading = false;
  int _messagesUsedToday = 0;
  bool _isPro = false;

  List<Business> get businesses => _businesses;
  Business? get activeBusiness => _activeBusiness;
  Plan? get currentPlan => _currentPlan;
  bool get isLoading => _isLoading;

  bool get isPremium => _isPro || _currentPlan?.id == 'pro';
  bool get isFree => !isPremium;
  bool get canAddBusiness =>
      _businesses.length < (_currentPlan?.maxBusinesses ?? 1);
  bool get hasMultipleBusinesses => _businesses.length > 1;

  int get maxMessagesPerDay => _currentPlan?.maxMessagesPerDay ?? 5;
  int get messagesUsedToday => _messagesUsedToday;
  int get messagesRemaining => maxMessagesPerDay - _messagesUsedToday;
  bool get canSendMessage => _messagesUsedToday < maxMessagesPerDay;

  bool get hasWhatsApp => _currentPlan?.hasWhatsApp ?? false;
  bool get hasNotifications => _currentPlan?.hasNotifications ?? false;
  bool get hasAnalytics => _currentPlan?.hasAnalytics ?? false;
  bool get hasAiInsights => _currentPlan?.hasAiInsights ?? false;

  int get strategicDimensions => _currentPlan?.strategicDimensions ?? 7;
  int get strategicTasks => _currentPlan?.strategicTasks ?? 30;

  bool hasFeature(String feature) =>
      _currentPlan?.features.contains(feature) ?? false;

  Future<void> initialize(String userId, String planId) async {
    _isLoading = true;
    notifyListeners();

    // Önce RevenueCat'ten gerçek abonelik durumunu al
    // Firestore'daki plan_id stale kalabilir (premium alındıktan sonra güncellenmemiş olabilir)
    try {
      await _purchaseService.login(userId);
      _isPro = await _purchaseService.checkProStatus();
    } catch (e) {
      AppLogger.e('[BusinessProvider]', 'RevenueCat error', e);
      _isPro = false;
    }

    // TODO: TEST OVERRIDE — kaldır production'a geçmeden önce
    _isPro = true;

    // RevenueCat pro ise planId'yi override et — Firestore'daki stale 'free' değerini yoksay
    final effectivePlanId = _isPro ? 'pro' : planId;

    try {
      _currentPlan = await _planRepository.getPlanById(effectivePlanId);
      final allBusinesses = await _businessRepository.getUserBusinesses(userId);

      // id bazlı deduplicate
      final seenIds = <String>{};
      final uniqueById = allBusinesses.where((b) => seenIds.add(b.id)).toList();

      // (name+ownerId) bazlı deduplicate: onboarding tekrarından oluşan aynı isimli işletmeleri filtrele
      // Fazla kayıtları Firestore'da arka planda soft-delete et
      final seenKeys = <String>{};
      final unique = <Business>[];
      final duplicates = <Business>[];
      for (final b in uniqueById) {
        final key = '${b.ownerId}_${b.name.trim().toLowerCase()}';
        if (seenKeys.add(key)) {
          unique.add(b);
        } else {
          duplicates.add(b);
        }
      }
      for (final dup in duplicates) {
        _businessRepository.deleteBusiness(dup.id).catchError(
          (e) => AppLogger.e('[BusinessProvider]', 'duplicate cleanup error', e),
        );
      }

      _businesses = unique;

      if (_businesses.isNotEmpty) {
        _activeBusiness = _businesses.first;
      }
    } catch (e) {
      AppLogger.e('[BusinessProvider]', 'initialize error', e);
      _businesses = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void switchBusiness(String businessId) {
    if (_businesses.isEmpty) return;
    final business = _businesses.firstWhere(
      (b) => b.id == businessId,
      orElse: () => _businesses.first,
    );
    _activeBusiness = business;
    notifyListeners();
  }

  void addBusiness(Business business) {
    _businesses.add(business);
    _activeBusiness = business;
    notifyListeners();
  }

  Future<void> updateBusiness(Business business) async {
    await _businessRepository.updateBusiness(business);
    final index = _businesses.indexWhere((b) => b.id == business.id);
    if (index != -1) {
      _businesses[index] = business;
    }
    if (_activeBusiness?.id == business.id) {
      _activeBusiness = business;
    }
    notifyListeners();
  }

  void incrementMessageCount() {
    _messagesUsedToday++;
    notifyListeners();
  }

  void resetDailyMessages() {
    _messagesUsedToday = 0;
    notifyListeners();
  }

  Future<bool> purchasePro(String userId) async {
    _isPurchasing = true;
    _purchaseError = null;
    notifyListeners();

    try {
      final customerInfo = await _purchaseService.purchasePro();
      _isPro = _purchaseService.isProFromCustomerInfo(customerInfo);
      if (_isPro) {
        await _planRepository.updateUserPlan(userId, 'pro');
        _currentPlan = await _planRepository.getPlanById('pro');
      }
      _isPurchasing = false;
      notifyListeners();
      return _isPro;
    } on PurchasesError catch (e) {
      if (e.code != PurchasesErrorCode.purchaseCancelledError) {
        _purchaseError = _purchasesErrorMessage(e.code);
      }
      _isPurchasing = false;
      notifyListeners();
      return false;
    } catch (e) {
      final msg = e.toString();
      // Kullanıcı ödeme akışını iptal etti — hata gösterme
      if (msg.contains('PURCHASE_CANCELLED') || msg.contains('userCancelled')) {
        _isPurchasing = false;
        notifyListeners();
        return false;
      }
      if (msg.contains('product-not-found') || msg.contains('not-configured')) {
        _purchaseError = 'Subscription products could not be loaded. Please check your connection and try again.';
      } else {
        _purchaseError = 'Something went wrong. Please try again.';
      }
      _isPurchasing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> restorePurchases(String userId) async {
    _isPurchasing = true;
    _purchaseError = null;
    notifyListeners();

    try {
      final customerInfo = await _purchaseService.restorePurchases();
      _isPro = _purchaseService.isProFromCustomerInfo(customerInfo);
      if (_isPro) {
        await _planRepository.updateUserPlan(userId, 'pro');
        _currentPlan = await _planRepository.getPlanById('pro');
      }
      _isPurchasing = false;
      notifyListeners();
      return _isPro;
    } on PurchasesError catch (e) {
      _purchaseError = _purchasesErrorMessage(e.code);
      _isPurchasing = false;
      notifyListeners();
      return false;
    } catch (e) {
      _purchaseError = 'Something went wrong. Please try again.';
      _isPurchasing = false;
      notifyListeners();
      return false;
    }
  }

  String _purchasesErrorMessage(PurchasesErrorCode code) {
    switch (code) {
      case PurchasesErrorCode.purchaseNotAllowedError:
        return 'Purchases are not allowed on this device.';
      case PurchasesErrorCode.purchaseInvalidError:
        return 'This purchase is invalid. Please try again.';
      case PurchasesErrorCode.productNotAvailableForPurchaseError:
        return 'This product is not available for purchase right now.';
      case PurchasesErrorCode.networkError:
        return 'No internet connection. Please check your network and try again.';
      case PurchasesErrorCode.receiptAlreadyInUseError:
        return 'This purchase is already linked to another account.';
      case PurchasesErrorCode.missingReceiptFileError:
        return 'Could not verify your purchase. Please try again.';
      case PurchasesErrorCode.paymentPendingError:
        return 'Your payment is pending. Please wait for it to complete.';
      default:
        return 'Something went wrong with the purchase. Please try again.';
    }
  }

  void clearPurchaseError() {
    _purchaseError = null;
    notifyListeners();
  }
}
