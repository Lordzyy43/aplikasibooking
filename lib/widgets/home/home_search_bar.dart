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
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Row(
        children: [
          Expanded(child: _buildSearchField(context)),
          SizedBox(width: 12.w),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.38)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          final hasText = value.text.trim().isNotEmpty;

          return TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Cari lapangan, venue, atau olahraga...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Icon(Icons.search_rounded, color: AppColors.primary, size: 23.sp),
              ),
              suffixIcon: hasText
                  ? IconButton(
                      onPressed: onClear,
                      splashRadius: 20.r,
                      icon: Icon(Icons.cancel_rounded, color: AppColors.textMuted, size: 20.sp),
                    )
                  : null,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19.r),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.85),
                  width: 1.4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Container(
      height: 56.h,
      width: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(19.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(19.r),
          splashColor: Colors.white.withValues(alpha: 0.16),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: Stack(
            children: [
              Center(
                child: Icon(Icons.tune_rounded, color: Colors.white, size: 23.sp),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  height: 7.h,
                  width: 7.h,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
