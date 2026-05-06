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
    if (sports.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 12.h),
      child: SizedBox(
        height: 48.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          itemCount: sports.length,
          separatorBuilder: (_, _) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            final sportName = sports[index];

            return _FilterItem(
              label: sportName,
              icon: _iconForSport(sportName),
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

  IconData _iconForSport(String name) {
    final lowerName = name.toLowerCase();

    if (lowerName == 'all' || lowerName.contains('semua')) {
      return Icons.apps_rounded;
    }

    if (lowerName.contains('futsal') || lowerName.contains('soccer')) {
      return Icons.sports_soccer_rounded;
    }

    if (lowerName.contains('badminton')) {
      return Icons.sports_tennis_rounded;
    }

    if (lowerName.contains('basket')) {
      return Icons.sports_basketball_rounded;
    }

    if (lowerName.contains('voli') || lowerName.contains('volley')) {
      return Icons.sports_volleyball_rounded;
    }

    if (lowerName.contains('tennis')) {
      return Icons.sports_tennis_rounded;
    }

    return Icons.sports_rounded;
  }
}

class _FilterItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayLabel = label.toLowerCase() == 'all' ? 'Semua' : label;

    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      scale: isSelected ? 1.02 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999.r),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: isSelected ? null : AppColors.surfaceLowest,
              gradient: isSelected
                  ? const LinearGradient(
                      colors: AppColors.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.divider.withValues(alpha: 0.38),
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.20)
                      : AppColors.primary.withValues(alpha: 0.04),
                  blurRadius: isSelected ? 14 : 10,
                  offset: Offset(0, isSelected ? 7 : 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  height: 28.h,
                  width: 28.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.18)
                        : AppColors.primaryLight.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.22)
                          : AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 15.sp,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  displayLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    fontSize: 12.5.sp,
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(width: 7.w),
                  Container(
                    height: 7.h,
                    width: 7.h,
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
