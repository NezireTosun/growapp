import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../l10n/app_localizations.dart';
import '../../../domain/entities/business.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import 'notification_settings_page.dart';
import 'edit_profile_page.dart';
import 'contact_page.dart';
import 'about_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String get _userName {
    return context.read<AuthProvider>().user?.name ?? '';
  }

  String get _email {
    return context.read<AuthProvider>().user?.email ?? '';
  }

  String get _phone {
    return context.read<AuthProvider>().user?.phone ?? '';
  }

  String get _businessName {
    return context.read<BusinessProvider>().activeBusiness?.name ?? '';
  }

  String get _businessCity {
    return context.read<BusinessProvider>().activeBusiness?.city ?? '';
  }

  String get _businessInstagram {
    return context.read<BusinessProvider>().activeBusiness?.instagram ?? '';
  }

  String get _initials {
    final name = _businessName.isNotEmpty ? _businessName : _userName;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          userName: _userName,
          businessName: _businessName,
          phone: _phone,
          instagram: _businessInstagram,
          city: _businessCity,
        ),
      ),
    );
    if (result != null && mounted) {
      final bp = context.read<BusinessProvider>();
      final active = bp.activeBusiness;
      if (active != null) {
        final updated = Business(
          id: active.id,
          name: result['businessName'] ?? active.name,
          ownerId: active.ownerId,
          sector: active.sector,
          city: result['city'] ?? active.city,
          instagram: result['instagram'] ?? active.instagram,
          status: active.status,
          isActive: active.isActive,
          createdAt: active.createdAt,
        );
        await bp.updateBusiness(updated);
      }
      // Update user name if changed
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      final newName = result['userName'] ?? '';
      if (newName.isNotEmpty && newName != _userName) {
        await authProvider.updateName(newName);
      }
      // Update phone in user doc if changed
      final newPhone = result['phone'] ?? '';
      if (newPhone != _phone) {
        await authProvider.updatePhone(newPhone);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Profile header card
              Builder(builder: (context) {
                final bp = context.watch<BusinessProvider>();
                final isPremium = bp.isPremium;
                final planName = bp.currentPlan?.name ?? l.freePlan;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2.5),
                        ),
                        child: Center(
                          child: Text(
                            _initials,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 30,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _userName,
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 22,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_businessName.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.store_rounded, size: 13, color: AppColors.textSecondary),
                                  const SizedBox(width: 5),
                                  Text(
                                    _businessName,
                                    style: AppTypography.badge.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: isPremium
                                  ? AppColors.warning.withValues(alpha: 0.1)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isPremium
                                    ? AppColors.warning.withValues(alpha: 0.5)
                                    : AppColors.border,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPremium ? Icons.workspace_premium_rounded : Icons.workspace_premium_outlined,
                                  size: 13,
                                  color: isPremium ? AppColors.warning : AppColors.textMuted,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  planName,
                                  style: AppTypography.badge.copyWith(
                                    color: isPremium ? AppColors.warning : AppColors.textMuted,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Personal Info
              _sectionCard(
                title: l.personalInfo,
                children: [
                  _infoRow(l.name, _userName),
                  _infoRow(l.email, _email),
                  _infoRow(l.phone, _phone.isEmpty ? '-' : _phone),
                ],
              ),
              const SizedBox(height: 16),

              // Business Info
              _sectionCard(
                title: l.businessInfo,
                children: [
                  _infoRow(l.name, _businessName.isEmpty ? '-' : _businessName),
                  _infoRow(l.city, _businessCity.isEmpty ? '-' : _businessCity),
                  _infoRow(l.instagram, _businessInstagram.isEmpty ? '-' : _businessInstagram),
                ],
                action: GestureDetector(
                  onTap: _openEditProfile,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        l.updateInfo,
                        style: AppTypography.badge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Settings
              Text(
                l.settings,
                style: AppTypography.badge.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              _settingsItem(
                Icons.notifications_outlined,
                l.notifications,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationSettingsPage()),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final bp = context.watch<BusinessProvider>();
                  final planName = bp.currentPlan?.name ?? l.freePlan;
                  return _settingsItem(
                    Icons.workspace_premium_outlined,
                    l.subscriptionPlan,
                    trailing: Text(
                      planName,
                      style: AppTypography.caption.copyWith(
                        color: bp.isPremium ? AppColors.warning : AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: bp.isPremium ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.subscription);
                    },
                  );
                },
              ),
              _settingsItem(Icons.info_outline_rounded, l.aboutUs, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
              }),
              _settingsItem(Icons.chat_bubble_outline_rounded, l.contact, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactPage()));
              }),
              _settingsItem(
                Icons.delete_outline_rounded,
                l.deleteAccount,
                color: AppColors.danger,
                onTap: () => _showDeleteAccountDialog(context),
              ),
              const SizedBox(height: 16),

              // Sign Out
              Center(
                child: TextButton.icon(
                  onPressed: () => _showSignOutDialog(context),
                  icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.danger),
                  label: Text(
                    l.signOut,
                    style: AppTypography.body.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.badge.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              ?action,
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsItem(
    IconData icon,
    String label, {
    Color? color,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color ?? AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(
                  color: color ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: color ?? AppColors.textMuted,
                ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.dangerLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded, color: AppColors.danger, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                l.deleteAccount,
                style: AppTypography.cardTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                l.deleteAccountMessage,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<AuthProvider>().deactivateAccount();
                    if (!context.mounted) return;
                    Navigator.pop(ctx);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.login,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(l.deleteAccount),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  l.cancel,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.dangerLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded, color: AppColors.danger, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                l.signOut,
                style: AppTypography.cardTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                l.signOutMessage,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<AuthProvider>().signOut();
                    if (!context.mounted) return;
                    Navigator.pop(ctx);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.login,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(l.signOut),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  l.cancel,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return const AppBottomNav(activeTab: BottomNavTab.profile);
  }
}
