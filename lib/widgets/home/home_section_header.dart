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
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 22.h,
            width: 5.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(99.r),
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 18.sp,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          if (actionLabel != null) ...[
            SizedBox(width: 10.w),
            Material(
              color: AppColors.primaryLight.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(999.r),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(999.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel!,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Icon(
                        actionLabel!.toLowerCase().contains('reset')
                            ? Icons.refresh_rounded
                            : Icons.arrow_forward_ios_rounded,
                        color: AppColors.primary,
                        size: 11.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
