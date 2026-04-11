import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../data/services/firestore_seeder.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/notification_list_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _fadeAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _checkAuth();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // 'cafe' → 1, 'rest' → 2, bilinmeyenler → 1 (en yaygın)
  int _sectorToTypeId(String sector) {
    return switch (sector.toLowerCase()) {
      'cafe' => 1,
      'rest' || 'restaurant' => 2,
      _ => 1,
    };
  }

  Future<void> _checkAuth() async {
    if (!mounted) return;

    try {
      final authProvider = context.read<AuthProvider>();
      debugPrint('[Splash] checkCurrentUser...');
      await authProvider.checkCurrentUser();
      debugPrint('[Splash] isAuthenticated=${authProvider.isAuthenticated}');

      if (!mounted) return;

      if (authProvider.isAuthenticated) {
        final user = authProvider.user!;

        // Seeder'lar sadece debug modda çalışır — production'da veri zaten mevcut
        if (kDebugMode) {
          FirestoreSeeder.seedAll().catchError((e) {
            debugPrint('[Splash] Seeder error: $e');
          });
          FirestoreSeeder.seedPrivacyPolicy().catchError((e) {
            debugPrint('[Splash] seedPrivacyPolicy error: $e');
          });
          FirestoreSeeder.seedBlogPosts().catchError((e) {
            debugPrint('[Splash] seedBlogPosts error: $e');
          });
        }

        if (!user.emailVerified) {
          Navigator.pushReplacementNamed(context, AppRouter.emailVerification);
          return;
        }

        final businessProvider = context.read<BusinessProvider>();
        debugPrint('[Splash] businessProvider.initialize...');
        await businessProvider.initialize(user.id, user.planId);
        debugPrint('[Splash] businesses=${businessProvider.businesses.length}');

        if (!mounted) return;

        context.read<NotificationProvider>().load(user.id);
        context.read<NotificationListProvider>().load(user.id);

        if (businessProvider.businesses.isEmpty) {
          Navigator.pushReplacementNamed(context, AppRouter.onboarding);
        } else {
          final active = businessProvider.activeBusiness;
          if (active == null) {
            Navigator.pushReplacementNamed(context, AppRouter.onboarding);
            return;
          }

          // api_answers yoksa survey tekrar doldurulmalı
          if (active.apiAnswers.isEmpty) {
            Navigator.pushReplacementNamed(context, AppRouter.onboarding);
            return;
          }
          // sector '1'/'2' (numeric) veya 'cafe'/'rest' (string) olabilir
          final sectorStr = active.sector ?? '';
          final typeId = int.tryParse(sectorStr) ?? _sectorToTypeId(sectorStr);

          final dashboard = context.read<DashboardProvider>();
          dashboard.setBusinessName(active.name);
          dashboard.setUserAndBusiness(user.id, active.id);
          dashboard.setBusinessType(typeId);
          dashboard.setApiParams(
            industry: active.sector ?? 'rest',
            answers: active.apiAnswers,
          );
          final locale = context.read<LocaleProvider>().locale;
          await dashboard.loadTasks(locale: locale, businessType: typeId);
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.register);
      }
    } catch (e, st) {
      debugPrint('[Splash] _checkAuth error: $e\n$st');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.register);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: Opacity(
                opacity: _fadeAnim.value,
                child: child,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
