import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String location;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.location = 'Surakarta, Indonesia',
    this.onLocationTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = userName.trim().isEmpty ? 'User' : userName.trim();

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.07),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -34.h,
              right: -28.w,
              child: Container(
                height: 96.h,
                width: 96.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLight.withValues(alpha: 0.55),
                ),
              ),
            ),
            Positioned(
              bottom: -46.h,
              left: -42.w,
              child: Container(
                height: 104.h,
                width: 104.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.08),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildLogoMark(),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildGreetingText(theme, displayName)),
                    SizedBox(width: 10.w),
                    _buildNotificationButton(context),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _buildLocationChip(context, theme)),
                    SizedBox(width: 10.w),
                    _buildBrandBadge(theme),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoMark() {
    return Container(
      height: 48.h,
      width: 48.h,
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(17.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13.r)),
        child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildGreetingText(ThemeData theme, String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textMuted,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Halo, $displayName 👋',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 21.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Mau main dimana hari ini?',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationChip(BuildContext context, ThemeData theme) {
    return Material(
      color: AppColors.primaryLight.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap:
            onLocationTap ??
            () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Fitur ganti lokasi akan tersedia nanti.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    margin: EdgeInsets.all(20.w),
                  ),
                );
            },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_rounded, color: AppColors.primary, size: 17.sp),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.45)),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
          children: const [
            TextSpan(
              text: 'Aero',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            TextSpan(
              text: 'book',
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Material(
      color: AppColors.surfaceLow,
      shape: const CircleBorder(),
      child: InkWell(
        onTap:
            onNotificationTap ??
            () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Belum ada notifikasi baru.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    margin: EdgeInsets.all(20.w),
                  ),
                );
            },
        customBorder: const CircleBorder(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 42.h,
              width: 42.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 22.sp,
              ),
            ),
            Positioned(
              top: 9.h,
              right: 10.w,
              child: Container(
                height: 8.h,
                width: 8.h,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfaceLowest, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Selamat pagi';
    }

    if (hour >= 11 && hour < 15) {
      return 'Selamat siang';
    }

    if (hour >= 15 && hour < 18) {
      return 'Selamat sore';
    }

    return 'Selamat malam';
  }
}
