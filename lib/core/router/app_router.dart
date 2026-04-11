import 'package:flutter/material.dart';
import '../../presentation/features/auth/login_page.dart';
import '../../presentation/features/auth/register_page.dart';
import '../../presentation/features/auth/email_verification_page.dart';
import '../../presentation/features/auth/forgot_password_page.dart';
import '../../presentation/features/onboarding/onboarding_flow.dart';
import '../../presentation/features/dashboard/dashboard_page.dart';
import '../../presentation/features/blog/blog_page.dart';
import '../../presentation/features/profile/profile_page.dart';
import '../../presentation/features/analytics/analytics_page.dart';
import '../../presentation/features/subscription/subscription_page.dart';
import '../../presentation/features/splash/splash_page.dart';
import '../../presentation/features/notifications/notifications_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String emailVerification = '/email-verification';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String blog = '/blog';
  static const String subscription = '/subscription';
  static const String notifications = '/notifications';

  /// Route adı → builder. Yeni route eklemek için sadece bu map'e satır eklenir;
  /// generateRoute değişmez (OCP).
  static final Map<String, WidgetBuilder> _routes = {
    splash: (_) => const SplashPage(),
    register: (_) => const RegisterPage(),
    emailVerification: (_) => const EmailVerificationPage(),
    login: (_) => const LoginPage(),
    forgotPassword: (_) => const ForgotPasswordPage(),
    onboarding: (_) => const OnboardingFlow(),
    dashboard: (_) => const DashboardPage(),
    blog: (_) => const BlogPage(),
    analytics: (_) => const AnalyticsPage(),
    subscription: (_) => const SubscriptionPage(),
    profile: (_) => const ProfilePage(),
    notifications: (_) => const NotificationsPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = _routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}
