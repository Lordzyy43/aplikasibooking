import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  const HomeSectionHeader({super.key, required this.title, this.actionLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Mengambil referensi dari AppTheme yang sudah Sensei buat
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Padding(
      // Kita tambahkan padding horizontal di sini agar HomePage tidak perlu
      // membungkus setiap header secara manual
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            // Gunakan titleLarge dari theme (sudah Plus Jakarta Sans)
            style: textTheme.titleLarge?.copyWith(
              // Sedikit override untuk memastikan ketebalan premium
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
              color: AppColors.textPrimary,
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(
                actionLabel!,
                // Gunakan labelLarge dari theme (sudah Inter)
                style: textTheme.labelLarge?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
