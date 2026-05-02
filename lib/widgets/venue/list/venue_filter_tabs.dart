// lib/widgets/venue/venue_filter_tabs.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';

class VenueFilterTabs extends StatelessWidget {
  final List<String> sports;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const VenueFilterTabs({
    super.key,
    required this.sports,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background, // Biar pas sticky warnanya nutup belakang
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SizedBox(
        height: 38.h, // Lebih tipis agar tidak makan ruang
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          itemCount: sports.length,
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            final String sportName = sports[index];

            return _FilterItem(
              label: sportName,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(index);
              },
            );
          },
        ),
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}