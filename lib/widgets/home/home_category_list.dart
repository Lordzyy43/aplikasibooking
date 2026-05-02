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
    // Sekarang hanya menggunakan list yang dipassing dari parent (HomePage)
    return SizedBox(
      height: 95.h,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.name;

          return Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => onCategorySelected(category.name),
              child: Column(
                children: [
                  _buildIcon(category, isSelected),
                  SizedBox(height: 8.h),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(CategoryModel category, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surfaceLow,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: AppColors.primary.withOpacity(0.2), width: 4) : null,
      ),
      child: Center(
        child: Icon(
          category.icon,
          color: isSelected ? Colors.white : AppColors.primary,
          size: 24.sp,
        ),
      ),
    );
  }
}
