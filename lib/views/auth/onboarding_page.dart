import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/auth/login_page.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const String _heroImageUrl = 'assets/images/onBoarding/OnBoarding.jpg';
  static const String _logoAsset = 'assets/logos/logo.png';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppRemoteImage(
              imageUrl: _heroImageUrl,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.34, 0.64, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.48),
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.72),
                    Colors.black.withValues(alpha: 0.96),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -54.h,
            right: -54.w,
            child: _buildGlowCircle(size: 170.h, color: AppColors.primary.withValues(alpha: 0.30)),
          ),

          Positioned(
            bottom: 140.h,
            left: -60.w,
            child: _buildGlowCircle(
              size: 150.h,
              color: AppColors.accentGold.withValues(alpha: 0.18),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 22.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBrand(theme),

                          SizedBox(height: 0.28.sh),

                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 650),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 22 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSlideIndicator(),
                                SizedBox(height: 22.h),
                                _buildBadge(theme),
                                SizedBox(height: 16.h),
                                _buildHeadline(theme),
                                SizedBox(height: 16.h),
                                _buildSubtitle(theme),
                                SizedBox(height: 28.h),
                                _buildStats(theme),
                                SizedBox(height: 34.h),
                                _buildMainButton(context, theme),
                                SizedBox(height: 18.h),
                                _buildSecondaryText(theme),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBrand(ThemeData theme) {
    return Row(
      children: [
        Container(
          height: 44.h,
          width: 44.h,
          padding: EdgeInsets.all(7.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Image.asset(_logoAsset, fit: BoxFit.contain),
        ),
        SizedBox(width: 10.w),
        RichText(
          text: TextSpan(
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 19.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Aero',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'book',
                style: TextStyle(color: AppColors.accentGold),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Text(
            'v1.0.0',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlideIndicator() {
    return Row(
      children: [
        Container(
          width: 34.w,
          height: 5.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        SizedBox(width: 7.w),
        _buildInactiveIndicator(),
        SizedBox(width: 7.w),
        _buildInactiveIndicator(),
      ],
    );
  }

  Widget _buildInactiveIndicator() {
    return Container(
      width: 9.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(999.r),
      ),
    );
  }

  Widget _buildBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: AppColors.accentGold, size: 15.sp),
          SizedBox(width: 7.w),
          Text(
            'Booking lapangan lebih cepat',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline(ThemeData theme) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.displayLarge?.copyWith(
          fontSize: 36.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.05,
          letterSpacing: -1.1,
        ),
        children: const [
          TextSpan(text: 'Main Tanpa\nAntri, Booking\n'),
          TextSpan(
            text: 'Sekarang!',
            style: TextStyle(color: AppColors.accentGold),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Text(
      'Temukan lapangan olahraga terbaik di sekitarmu dengan harga transparan, jadwal praktis, dan proses booking yang mudah.',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.white.withValues(alpha: 0.76),
        fontSize: 14.sp,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStats(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              theme,
              value: '50+',
              label: 'Venues',
              icon: Icons.stadium_rounded,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatItem(theme, value: '10k+', label: 'Users', icon: Icons.groups_rounded),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatItem(theme, value: '4.9', label: 'Rating', icon: Icons.star_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme, {
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.accentGold, size: 17.sp),
        SizedBox(width: 7.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.60),
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30.h,
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: Colors.white.withValues(alpha: 0.14),
    );
  }

  Widget _buildMainButton(BuildContext context, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
        },
        borderRadius: BorderRadius.circular(18.r),
        splashColor: Colors.white.withValues(alpha: 0.14),
        highlightColor: Colors.white.withValues(alpha: 0.06),
        child: Ink(
          height: 58.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 22,
                offset: const Offset(0, 11),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mulai Sekarang',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                height: 28.h,
                width: 28.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 17.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryText(ThemeData theme) {
    return Center(
      child: Text(
        'Aerobook • Booking venue olahraga jadi lebih mudah',
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.42),
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.25,
        ),
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
}
