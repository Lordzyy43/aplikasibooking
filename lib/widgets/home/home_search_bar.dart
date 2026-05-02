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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Cari lapangan atau lokasi...',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: onFilterTap,
      child: Container(
        padding: EdgeInsets.all(13.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}
