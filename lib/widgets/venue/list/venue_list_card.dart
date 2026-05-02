import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';

class VenueListCard extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback? onTap;

  const VenueListCard({super.key, required this.venue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 18.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImageSection(), _buildInfoSection()],
        ),
      ),
    );
  }

  // 🔥 IMAGE + OVERLAY
  Widget _buildImageSection() {
    return Stack(
      children: [
        AppRemoteImage(
          imageUrl: venue.imageUrl,
          width: double.infinity,
          height: 168.h,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        _buildStatusBadge(),
        _buildPriceTag(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Positioned(
      top: 15,
      left: 15,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.successContainer,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          venue.statusLabel,
          style: TextStyle(color: AppColors.success, fontSize: 10.sp, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildPriceTag() {
    return Positioned(
      bottom: 15,
      right: 15,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          '${CurrencyFormatter.idr(venue.pricePerHour)} / jam',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12.sp),
        ),
      ),
    );
  }

  // 🔥 INFO SECTION
  Widget _buildInfoSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 6.h),
          _buildLocation(),
          SizedBox(height: 12.h),
          _buildSportsTags(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            venue.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _buildRating(),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: AppColors.accent, size: 16),
        SizedBox(width: 3.w),
        Text(
          venue.rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Text(
      '${venue.location} • ${venue.distanceKm.toStringAsFixed(1)} km',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted, height: 1.4),
    );
  }

  Widget _buildSportsTags() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: venue.sports.map((sport) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            sport,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }
}
