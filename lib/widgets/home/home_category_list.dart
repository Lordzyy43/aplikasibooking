import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/category_model.dart';

class HomeCategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const HomeCategoryList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 98.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.name;

          return _CategoryItem(
            category: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category.name),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({required this.category, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = _displayName(category.name);

    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      scale: isSelected ? 1.02 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22.r),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: 88.w,
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 9.h),
            decoration: BoxDecoration(
              color: isSelected ? null : AppColors.surfaceLowest,
              gradient: isSelected
                  ? const LinearGradient(
                      colors: AppColors.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.divider.withValues(alpha: 0.38),
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.22)
                      : AppColors.primary.withValues(alpha: 0.045),
                  blurRadius: isSelected ? 18 : 12,
                  offset: Offset(0, isSelected ? 9 : 6),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (isSelected) ...[
                  Positioned(
                    right: -18.w,
                    top: -20.h,
                    child: Container(
                      height: 52.h,
                      width: 52.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -14.w,
                    bottom: -18.h,
                    child: Container(
                      height: 44.h,
                      width: 44.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGold.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      height: 43.h,
                      width: 43.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.18)
                            : AppColors.primaryLight.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.22)
                              : AppColors.primary.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Icon(
                        category.icon,
                        color: isSelected ? Colors.white : AppColors.primary,
                        size: 23.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      style: theme.textTheme.labelMedium!.copyWith(
                        fontSize: 11.5.sp,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        height: 1,
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: Container(
                      height: 8.h,
                      width: 8.h,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _displayName(String name) {
    if (name.toLowerCase() == 'all') {
      return 'Semua';
    }

    return name;
  }
}
