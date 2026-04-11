import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/task_repository_impl.dart';
import 'data/repositories/blog_repository_impl.dart';
import 'data/repositories/business_repository_impl.dart';
import 'data/repositories/plan_repository_impl.dart';
import 'data/services/api_client.dart';
import 'data/services/notification_service.dart';
import 'data/services/purchase_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/dashboard_provider.dart';
import 'presentation/providers/business_provider.dart';
import 'presentation/providers/blog_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/providers/analytics_provider.dart';
import 'presentation/providers/notification_list_provider.dart';
import 'presentation/providers/privacy_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();
  await PurchaseService().initialize();

  runApp(const GrowApp());
}

class GrowApp extends StatefulWidget {
  const GrowApp({super.key});

  @override
  State<GrowApp> createState() => _GrowAppState();
}

class _GrowAppState extends State<GrowApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Uygulama background'dan foreground'a gelince splash'a yönlendir
    // Splash zaten auth kontrolü yapıp dashboard'a yönlendiriyor
    if (state == AppLifecycleState.resumed) {
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRouter.splash,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = LocaleProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => BusinessProvider(
            BusinessRepositoryImpl(),
            PlanRepositoryImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(TaskRepositoryImpl(), ApiClient()),
        ),
        ChangeNotifierProvider(
          create: (_) => BlogProvider(BlogRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnalyticsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PrivacyProvider(),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, lp, _) => MaterialApp(
          navigatorKey: _navigatorKey,
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: Locale(lp.locale),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.splash,
        ),
      ),
    );
  }
}
