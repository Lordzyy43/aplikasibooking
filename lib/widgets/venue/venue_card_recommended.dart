import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';

class VenueCardRecommended extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback? onTap;

  const VenueCardRecommended({super.key, required this.venue, this.onTap});

  String _formatPrice(Object? value) {
    final raw = value.toString();

    final number = num.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), ''));

    if (number == null) return raw;

    final text = number.toStringAsFixed(0);

    return text.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }

  String _primarySport() {
    if (venue.sports.isEmpty) return 'Sport';
    return venue.sports.first;
  }

  IconData _sportIcon() {
    final sport = _primarySport().toLowerCase();

    if (sport.contains('futsal') || sport.contains('soccer')) {
      return Icons.sports_soccer_rounded;
    }

    if (sport.contains('badminton')) {
      return Icons.sports_tennis_rounded;
    }

    if (sport.contains('basket')) {
      return Icons.sports_basketball_rounded;
    }

    if (sport.contains('voli') || sport.contains('volley')) {
      return Icons.sports_volleyball_rounded;
    }

    if (sport.contains('tennis')) {
      return Icons.sports_tennis_rounded;
    }

    return Icons.sports_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 222.w,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: Container(
            margin: EdgeInsets.only(top: 4.h, bottom: 10.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: AppColors.divider.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.07),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildImageSection(theme), _buildContentSection(theme)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    return SizedBox(
      height: 136.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppRemoteImage(imageUrl: venue.imageUrl, height: 136.h, width: double.infinity),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.34), Colors.transparent],
                ),
              ),
            ),
          ),

          Positioned(top: 10.h, left: 10.w, child: _buildSportBadge(theme)),

          Positioned(top: 10.h, right: 10.w, child: _buildRatingBadge(theme)),

          Positioned(
            bottom: 10.h,
            left: 12.w,
            right: 12.w,
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: AppColors.accentGold, size: 15.sp),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    'Venue rekomendasi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.35,
            ),
          ),
          SizedBox(height: 7.h),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14.sp, color: AppColors.textMuted),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  venue.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.5.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Rp ${_formatPrice(venue.pricePerHour)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      TextSpan(
                        text: '/jam',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _buildArrowButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSportBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_sportIcon(), color: AppColors.primary, size: 13.sp),
          SizedBox(width: 4.w),
          Text(
            _primarySport(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14.sp, color: AppColors.accentGold),
          SizedBox(width: 3.w),
          Text(
            venue.rating.toString(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton() {
    return Container(
      height: 30.h,
      width: 30.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(Icons.arrow_forward_rounded, size: 15.sp, color: Colors.white),
    );
  }
}
