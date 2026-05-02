import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';

class VenueCard extends StatelessWidget {
  final VenueModel venue;
  final bool horizontal;

  const VenueCard({super.key, required this.venue, this.horizontal = true});

  @override
  Widget build(BuildContext context) {
    return horizontal ? _buildHorizontalCard() : _buildVerticalCard();
  }

  // Desain kartu untuk horizontal list (Rekomendasi)
  Widget _buildHorizontalCard() {
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(right: 18.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppRemoteImage(
                imageUrl: venue.imageUrl,
                height: 140.h,
                width: 260.w,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              _buildCategoryBadge(),
            ],
          ),
          _buildInfoSection(),
        ],
      ),
    );
  }

  // Desain kartu untuk vertical list (Terdekat) - Sesuai _buildNearbyList di kode asli
  Widget _buildVerticalCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          AppRemoteImage(
            width: 76.w,
            height: 76.w,
            imageUrl: venue.imageUrl,
            borderRadius: BorderRadius.circular(14.r),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _nameStyle(14),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${venue.sports.join(' • ')} • ${venue.distanceKm.toStringAsFixed(1)} km',
                  maxLines: 1,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                ),
                SizedBox(height: 6.h),
                _buildRating(),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          venue.sports.first,
          style: TextStyle(color: AppColors.accent, fontSize: 10.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(venue.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: _nameStyle(15)),
          SizedBox(height: 6.h),
          Text(
            venue.location,
            maxLines: 2,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _buildDistanceTag(),
              const Spacer(),
              Text(
                CurrencyFormatter.idr(venue.pricePerHour),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                '/jam',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        '${venue.distanceKm.toStringAsFixed(1)} km',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 14.sp, color: AppColors.accent),
        SizedBox(width: 4.w),
        Text(
          '${venue.rating} (${venue.reviewCount} ulasan)',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  TextStyle _nameStyle(double size) =>
      TextStyle(fontWeight: FontWeight.w800, fontSize: size.sp, color: AppColors.textPrimary);
}
