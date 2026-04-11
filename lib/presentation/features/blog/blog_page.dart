import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/skeleton_loading.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/blog_post.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/blog_provider.dart';
import 'blog_detail_page.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = Localizations.localeOf(context).languageCode;
      final userId = context.read<AuthProvider>().user?.id;
      context.read<BlogProvider>().loadPosts(locale: locale, userId: userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final provider = context.watch<BlogProvider>();

    if (provider.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final msg = provider.error == 'network_error'
            ? l.errorNetwork
            : l.errorGeneric;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
        );
        provider.clearError();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l.blog,
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const BlogSkeleton()
          : Column(
              children: [
                // Filter chips
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: Row(
                    children: [
                      _categoryChip(context, l.general, null, provider),
                      const SizedBox(width: 8),
                      _categoryChip(context, l.categoryInstagram, BlogCategory.instagram, provider),
                      const SizedBox(width: 8),
                      _categoryChip(context, l.categoryWhatsapp, BlogCategory.whatsapp, provider),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    itemCount: provider.filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = provider.filteredPosts[index];
                      return _BlogCard(
                        post: post,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => BlogDetailPage(post: post)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _categoryChip(BuildContext context, String label, BlogCategory? category, BlogProvider provider) {
    final isSelected = provider.selectedCategory == category;
    return GestureDetector(
      onTap: () => provider.setCategory(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return const AppBottomNav(activeTab: BottomNavTab.blog);
  }
}

// ─── Blog Card — task kartıyla aynı yapı ───
class _BlogCard extends StatelessWidget {
  final BlogPost post;
  final VoidCallback onTap;

  const _BlogCard({required this.post, required this.onTap});

  Color get _categoryColor {
    return switch (post.category) {
      BlogCategory.general => AppColors.success,
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge row with icon on right
                  Row(
                    children: [
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
                      const Spacer(),
                      Builder(builder: (ctx) {
                        final blogProvider = ctx.watch<BlogProvider>();
                        final liked = blogProvider.isLiked(post.id);
                        return GestureDetector(
                          onTap: () => blogProvider.toggleLike(post.id),
                          child: Icon(
                            liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 20,
                            color: liked ? AppColors.danger : AppColors.textMuted,
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => SharePlus.instance.share(
                          ShareParams(text: '${post.title}\n\n${post.summary}'),
                        ),
                        child: const Icon(Icons.share_outlined, size: 18, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.title,
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.summary,
                    style: AppTypography.body.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l.blogDetail,
                            style: AppTypography.button.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(builder: (ctx) {
                        final blogProvider = ctx.watch<BlogProvider>();
                        final liked = blogProvider.isLiked(post.id);
                        return GestureDetector(
                          onTap: () => blogProvider.toggleLike(post.id),
                          child: Row(
                            children: [
                              Icon(
                                liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                size: 18,
                                color: liked ? AppColors.danger : AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l.like,
                                style: AppTypography.caption.copyWith(
                                  fontSize: 12,
                                  color: liked ? AppColors.danger : AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => SharePlus.instance.share(
                          ShareParams(text: '${post.title}\n\n${post.summary}'),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.share_outlined, size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              l.share,
                              style: AppTypography.caption.copyWith(
                                fontSize: 12,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
