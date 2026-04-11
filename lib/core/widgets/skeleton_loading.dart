import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A shimmer-effect skeleton placeholder widget
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Animated shimmer wrapper using opacity pulse
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({super.key, required this.child});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

// ─── Dashboard Skeleton ───
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header row
            Row(
              children: [
                const SkeletonBox(width: 48, height: 48, borderRadius: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(width: 120, height: 14),
                    SizedBox(height: 6),
                    SkeletonBox(width: 180, height: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Progress card
            const SkeletonBox(height: 80, borderRadius: 16),
            const SizedBox(height: 20),
            // Task cards
            const SkeletonBox(height: 120, borderRadius: 16),
            const SizedBox(height: 12),
            const SkeletonBox(height: 120, borderRadius: 16),
            const SizedBox(height: 12),
            const SkeletonBox(height: 120, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Analytics Skeleton ───
class AnalyticsSkeleton extends StatelessWidget {
  const AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Streak card
            const SkeletonBox(height: 180, borderRadius: 20),
            const SizedBox(height: 24),
            // Weekly performance header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonBox(width: 160, height: 18),
                SkeletonBox(width: 80, height: 14),
              ],
            ),
            const SizedBox(height: 16),
            // Weekly chart card
            const SkeletonBox(height: 220, borderRadius: 20),
            const SizedBox(height: 24),
            // Category header
            const Align(
              alignment: Alignment.centerLeft,
              child: SkeletonBox(width: 180, height: 18),
            ),
            const SizedBox(height: 16),
            // Category items
            const SkeletonBox(height: 80, borderRadius: 16),
            const SizedBox(height: 12),
            const SkeletonBox(height: 80, borderRadius: 16),
            const SizedBox(height: 12),
            const SkeletonBox(height: 80, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Blog Skeleton ───
class BlogSkeleton extends StatelessWidget {
  const BlogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category tabs
            Row(
              children: const [
                SkeletonBox(width: 70, height: 32, borderRadius: 16),
                SizedBox(width: 8),
                SkeletonBox(width: 80, height: 32, borderRadius: 16),
                SizedBox(width: 8),
                SkeletonBox(width: 90, height: 32, borderRadius: 16),
              ],
            ),
            const SizedBox(height: 20),
            // Blog cards
            const SkeletonBox(height: 200, borderRadius: 16),
            const SizedBox(height: 16),
            const SkeletonBox(height: 200, borderRadius: 16),
            const SizedBox(height: 16),
            const SkeletonBox(height: 200, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Onboarding Skeleton ───
class OnboardingSkeleton extends StatelessWidget {
  const OnboardingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 60),
            SkeletonBox(width: 200, height: 24),
            SizedBox(height: 12),
            SkeletonBox(width: 280, height: 14),
            SizedBox(height: 40),
            SkeletonBox(height: 56, borderRadius: 16),
            SizedBox(height: 16),
            SkeletonBox(height: 56, borderRadius: 16),
            SizedBox(height: 16),
            SkeletonBox(height: 56, borderRadius: 16),
            Spacer(),
            SkeletonBox(height: 52, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Skeleton ───
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + name
            const SkeletonBox(width: 80, height: 80, borderRadius: 40),
            const SizedBox(height: 16),
            const SkeletonBox(width: 140, height: 18),
            const SizedBox(height: 8),
            const SkeletonBox(width: 100, height: 14),
            const SizedBox(height: 24),
            // Level progress
            const SkeletonBox(height: 60, borderRadius: 16),
            const SizedBox(height: 24),
            // Info rows
            const SkeletonBox(height: 50, borderRadius: 12),
            const SizedBox(height: 8),
            const SkeletonBox(height: 50, borderRadius: 12),
            const SizedBox(height: 8),
            const SkeletonBox(height: 50, borderRadius: 12),
            const SizedBox(height: 8),
            const SkeletonBox(height: 50, borderRadius: 12),
            const SizedBox(height: 24),
            // Settings rows
            const SkeletonBox(height: 50, borderRadius: 12),
            const SizedBox(height: 8),
            const SkeletonBox(height: 50, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
