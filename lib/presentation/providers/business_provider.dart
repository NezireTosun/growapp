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

    try {
      _currentPlan = await _planRepository.getPlanById(planId);
      final allBusinesses = await _businessRepository.getUserBusinesses(userId);
      // Duplicate id'leri filtrele (aynı işletme birden fazla kaydedilmiş olabilir)
      final seen = <String>{};
      final unique = allBusinesses.where((b) => seen.add(b.id)).toList();

      // Plan limitine göre kes
      final maxAllowed = _currentPlan?.maxBusinesses ?? 1;
      _businesses = unique.length > maxAllowed ? unique.sublist(0, maxAllowed) : unique;

      if (_businesses.isNotEmpty) {
        _activeBusiness = _businesses.first;
      }
    } catch (e) {
      debugPrint('[BusinessProvider] initialize error: $e');
      _businesses = [];
    }

    // RevenueCat'e kullanıcıyı tanıt ve pro durumunu kontrol et
    try {
      await _purchaseService.login(userId);
      _isPro = await _purchaseService.checkProStatus();
    } catch (e) {
      debugPrint('[BusinessProvider] RevenueCat error (API key eksik olabilir): $e');
      _isPro = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  void switchBusiness(String businessId) {
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
    } on PurchasesErrorCode catch (e) {
      if (e != PurchasesErrorCode.purchaseCancelledError) {
        _purchaseError = e.toString();
      }
      _isPurchasing = false;
      notifyListeners();
      return false;
    } catch (e) {
      _purchaseError = e.toString();
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
    } catch (e) {
      _purchaseError = e.toString();
      _isPurchasing = false;
      notifyListeners();
      return false;
    }
  }

  void clearPurchaseError() {
    _purchaseError = null;
    notifyListeners();
  }
}
