import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String? location;

  const HomeHeader({
    super.key,
    this.location = "Surakarta, Indonesia",
    required String userName, // Tetap ada di constructor jika nanti ingin menyapa user
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Lokasi Section (Kiri)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Lokasi Kamu",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () {
                    // Logic ganti lokasi
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16.sp),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Brand Identity / Nama APK (Kanan)
          _buildBrandLogo(theme),
        ],
      ),
    );
  }

  Widget _buildBrandLogo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(
                text: "Aero",
                style: TextStyle(color: AppColors.textPrimary),
              ),
              TextSpan(
                text: "Book",
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        // Garis dekoratif kecil di bawah nama APK agar terlihat "Designed"
        Container(
          margin: EdgeInsets.only(top: 2.h),
          height: 3.h,
          width: 24.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}
