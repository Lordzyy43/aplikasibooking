import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;

  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r), // Tambahkan ini agar bayangan rapi
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ), // Bracket ini yang tadi bermasalah
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textAlignVertical: TextAlignVertical.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari lapangan favoritmu...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary, size: 22.sp),
                  fillColor: AppColors.surfaceLow,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: onClear,
                          icon: Icon(Icons.cancel_rounded, color: AppColors.textMuted, size: 20.sp),
                        )
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          _buildFilterButton(theme),
        ],
      ),
    );
  }

  Widget _buildFilterButton(ThemeData theme) {
    return Container(
      height: 52.h,
      width: 52.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Center(
            child: Icon(Icons.tune_rounded, color: Colors.white, size: 22.sp),
          ),
        ),
      ),
    );
  }
}
