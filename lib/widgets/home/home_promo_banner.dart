import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/venue/venue_list_page.dart';

class HomePromoBanner extends StatefulWidget {
  final VoidCallback? onTap;

  const HomePromoBanner({super.key, this.onTap});

  @override
  State<HomePromoBanner> createState() => _HomePromoBannerState();
}

class _HomePromoBannerState extends State<HomePromoBanner> {
  final PageController _pageController = PageController(viewportFraction: 0.90);

  int _currentPage = 0;
  Timer? _timer;

  static const List<_PromoItem> _promos = [
    _PromoItem(
      title: 'Diskon Member Baru!',
      subtitle: 'Potongan hingga 50% untuk booking pertama kamu.',
      tag: 'LIMITED TIME',
      cta: 'Booking Sekarang',
      icon: Icons.local_fire_department_rounded,
      sportIcon: Icons.sports_soccer_rounded,
      gradient: [AppColors.primary, AppColors.primaryContainer],
      accentColor: AppColors.accentGold,
    ),
    _PromoItem(
      title: 'Main Bareng Teman',
      subtitle: 'Cashback 20rb untuk booking grup minimal 10 orang.',
      tag: 'GROUP DEAL',
      cta: 'Ajak Tim Kamu',
      icon: Icons.groups_rounded,
      sportIcon: Icons.sports_handball_rounded,
      gradient: [AppColors.accentTeal, Color(0xFF0B6B73)],
      accentColor: AppColors.primaryLight,
    ),
    _PromoItem(
      title: 'Weekend Seru',
      subtitle: 'Bonus air mineral & sewa sepatu gratis setiap weekend.',
      tag: 'WEEKEND SPECIAL',
      cta: 'Lihat Promo',
      icon: Icons.celebration_rounded,
      sportIcon: Icons.sports_tennis_rounded,
      gradient: [Color(0xFF172033), AppColors.primary],
      accentColor: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage = _currentPage == _promos.length - 1 ? 0 : _currentPage + 1;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _handleTap(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueListPage()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220.h,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: _promos.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double scale = 1;

                  if (_pageController.position.haveDimensions) {
                    final page = _pageController.page ?? _currentPage.toDouble();
                    scale = (1 - ((page - index).abs() * 0.06)).clamp(0.94, 1.0);
                  }

                  return Transform.scale(scale: scale, child: child);
                },
                child: _buildPromoCard(context: context, promo: _promos[index]),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildPromoCard({required BuildContext context, required _PromoItem promo}) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: promo.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: promo.gradient.first.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleTap(context),
            splashColor: Colors.white.withValues(alpha: 0.12),
            highlightColor: Colors.white.withValues(alpha: 0.06),
            child: Stack(
              children: [
                Positioned(
                  right: -44.w,
                  top: -42.h,
                  child: _buildGlowCircle(size: 136.h, color: Colors.white.withValues(alpha: 0.12)),
                ),
                Positioned(
                  left: -32.w,
                  bottom: -42.h,
                  child: _buildGlowCircle(
                    size: 118.h,
                    color: promo.accentColor.withValues(alpha: 0.18),
                  ),
                ),
                Positioned(
                  right: 12.w,
                  bottom: -16.h,
                  child: Icon(
                    promo.sportIcon,
                    size: 132.sp,
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                Positioned(right: 20.w, bottom: 22.h, child: _buildSportBubble(promo)),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildTag(promo, theme),
                          const Spacer(),
                          _buildArrowButton(promo),
                        ],
                      ),

                      const Spacer(),

                      SizedBox(
                        width: 220.w,
                        child: Text(
                          promo.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 19.sp,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      SizedBox(
                        width: 220.w,
                        child: Text(
                          promo.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildCta(promo, theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(_PromoItem promo, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(promo.icon, color: promo.accentColor, size: 13.sp),
          SizedBox(width: 6.w),
          Text(
            promo.tag,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 9.5.sp,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(_PromoItem promo) {
    return Container(
      height: 34.h,
      width: 34.h,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(Icons.arrow_forward_rounded, color: promo.gradient.first, size: 17.sp),
    );
  }

  Widget _buildCta(_PromoItem promo, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            promo.cta,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.flash_on_rounded, color: promo.accentColor, size: 15.sp),
        ],
      ),
    );
  }

  Widget _buildSportBubble(_PromoItem promo) {
    return Container(
      height: 58.h,
      width: 58.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Center(
        child: Icon(promo.sportIcon, color: Colors.white.withValues(alpha: 0.92), size: 28.sp),
      ),
    );
  }

  Widget _buildGlowCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promos.length, (index) {
        final isActive = _currentPage == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          height: 7.h,
          width: isActive ? 22.w : 7.w,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999.r),
          ),
        );
      }),
    );
  }
}

class _PromoItem {
  final String title;
  final String subtitle;
  final String tag;
  final String cta;
  final IconData icon;
  final IconData sportIcon;
  final List<Color> gradient;
  final Color accentColor;

  const _PromoItem({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.cta,
    required this.icon,
    required this.sportIcon,
    required this.gradient,
    required this.accentColor,
  });
}
