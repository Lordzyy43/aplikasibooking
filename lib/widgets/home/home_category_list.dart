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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        SizedBox(
          height: 105.h, // Sedikit lebih tinggi untuk menampung shadow
          child: ListView.builder(
            padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category.name;

              return Padding(
                padding: EdgeInsets.only(right: 18.w),
                child: GestureDetector(
                  onTap: () => onCategorySelected(category.name),
                  child: Column(
                    children: [
                      _buildIcon(category, isSelected),
                      SizedBox(height: 10.h),
                      Text(
                        category.name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(CategoryModel category, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surfaceLow,
        shape: BoxShape.circle,
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          width: 4,
        ),
      ),
      child: Center(
        child: Icon(
          category.icon,
          color: isSelected ? Colors.white : AppColors.primary,
          size: 26.sp,
        ),
      ),
    );
  }
}
