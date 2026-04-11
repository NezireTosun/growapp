import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../presentation/providers/blog_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/blog_post.dart';
import '../../../l10n/app_localizations.dart';

class BlogDetailPage extends StatelessWidget {
  final BlogPost post;

  const BlogDetailPage({super.key, required this.post});

  Color get _categoryColor {
    return switch (post.category) {
      BlogCategory.general => AppColors.primary,
      BlogCategory.instagram => const Color(0xFFE1306C),
      BlogCategory.whatsapp => const Color(0xFF25D366),
    };
  }

  IconData get _categoryIcon {
    return switch (post.category) {
      BlogCategory.general => Icons.campaign_rounded,
      BlogCategory.instagram => Icons.camera_alt_rounded,
      BlogCategory.whatsapp => Icons.chat_rounded,
    };
  }

  String _getCategoryLabel(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return switch (post.category) {
      BlogCategory.general => l.campaignLabel,
      BlogCategory.instagram => l.instagramLabel,
      BlogCategory.whatsapp => l.whatsappLabel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final color = _categoryColor;
    final categoryLabel = _getCategoryLabel(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          l.blogDetail,
          style: AppTypography.cardTitle.copyWith(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Kategori badge — task detail'deki dailyTaskCounter ile aynı konum
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_categoryIcon, size: 11, color: color),
                        const SizedBox(width: 4),
                        Text(
                          categoryLabel,
                          style: AppTypography.badge.copyWith(
                            color: color,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Başlık — task detail ile aynı hero stili
                  Text(
                    post.title,
                    style: AppTypography.hero.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // İçerik
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: post.content
                          .split('\n\n')
                          .where((p) => p.trim().isNotEmpty)
                          .map((paragraph) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  paragraph.trim(),
                                  style: AppTypography.body.copyWith(
                                    fontSize: 13,
                                    height: 1.7,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // İpuçları
                  if (post.tips.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      l.howToDoIt,
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(post.tips.length, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _StepCard(stepNumber: index + 1, text: post.tips[index]),
                    )),
                  ],

                  // Şablon kopyala
                  if (post.template != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      l.readyMadeTemplate,
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TemplateCard(template: post.template!, l: l),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom bar: Like + Share — ortalı
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    // Like
                    Expanded(
                      child: Builder(builder: (ctx) {
                        final blogProvider = ctx.watch<BlogProvider>();
                        final liked = blogProvider.isLiked(post.id);
                        return GestureDetector(
                          onTap: () => blogProvider.toggleLike(post.id),
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: liked
                                  ? AppColors.danger.withValues(alpha: 0.06)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: liked
                                    ? AppColors.danger.withValues(alpha: 0.3)
                                    : AppColors.border,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  size: 18,
                                  color: liked ? AppColors.danger : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l.like,
                                  style: AppTypography.button.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: liked ? AppColors.danger : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 10),
                    // Share
                    Expanded(
                      child: GestureDetector(
                        onTap: () => SharePlus.instance.share(
                          ShareParams(text: '${post.title}\n\n${post.summary}'),
                        ),
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.primaryBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.share_rounded, size: 18, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                l.shareButton,
                                style: AppTypography.button.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          _buildBottomNav(context),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, l.navHome, false, onTap: () => Navigator.pushReplacementNamed(context, AppRouter.dashboard)),
              _navItem(Icons.bar_chart_rounded, l.navAnalytics, false),
              _navItem(Icons.article_rounded, l.navBlog, true, onTap: () => Navigator.pop(context)),
              _navItem(Icons.person_outline_rounded, l.navProfile, false, onTap: () => Navigator.pushReplacementNamed(context, AppRouter.profile)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    final color = isActive ? AppColors.primary : AppColors.iconInactive;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.caption.copyWith(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: color,
            )),
          ],
        ),
      ),
    );
  }
}



// ─── Step Card — task detail'deki _StepCard ile aynı ───
class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String text;

  const _StepCard({required this.stepNumber, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: AppTypography.badge.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body.copyWith(
                fontSize: 13,
                height: 1.55,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Template Card ───
class _TemplateCard extends StatelessWidget {
  final String template;
  final AppLocalizations l;

  const _TemplateCard({required this.template, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template,
            style: AppTypography.body.copyWith(
              fontSize: 13,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: template));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.copied),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: Text(l.copyTemplate),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 11),
                textStyle: AppTypography.button.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
