import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';

class VenueCardNearby extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback? onTap;

  const VenueCardNearby({super.key, required this.venue, this.onTap});

  String _formatPrice(Object? value) {
    final raw = value.toString();

    final number = num.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), ''));

    if (number == null) return raw;

    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(number);
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

  String _formatDistance(Object? value) {
    final distance = num.tryParse(value.toString());

    if (distance == null) return '${value ?? '-'} km';

    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    }

    return '${distance.toStringAsFixed(distance % 1 == 0 ? 0 : 1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.28)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.055),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(11.w),
            child: Row(
              children: [
                _buildImageSection(),
                SizedBox(width: 13.w),
                Expanded(child: _buildContentSection(theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      width: 96.w,
      height: 104.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: AppRemoteImage(imageUrl: venue.imageUrl, width: 96.w, height: 104.h),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.28), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            left: 8.w,
            bottom: 8.h,
            child: Container(
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(_sportIcon(), color: AppColors.primary, size: 17.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
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
            ),
            SizedBox(width: 8.w),
            _buildRatingBadge(theme),
          ],
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
        SizedBox(height: 9.h),
        Row(
          children: [
            Expanded(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _formatPrice(venue.pricePerHour),
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    TextSpan(
                      text: ' / jam',
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
            _buildArrowButton(),
          ],
        ),
        SizedBox(height: 10.h),
        Row(children: [_buildSportChip(theme), const Spacer(), _buildDistanceChip(theme)]),
      ],
    );
  }

  Widget _buildRatingBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13.sp, color: AppColors.accentGold),
          SizedBox(width: 2.w),
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

  Widget _buildSportChip(ThemeData theme) {
    return Container(
      constraints: BoxConstraints(maxWidth: 92.w),
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_sportIcon(), size: 12.sp, color: AppColors.primary),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              _primarySport(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceChip(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.near_me_rounded, size: 12.sp, color: AppColors.accentTeal),
          SizedBox(width: 4.w),
          Text(
            _formatDistance(venue.distanceKm),
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton() {
    return Container(
      height: 28.h,
      width: 28.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 9,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(Icons.arrow_forward_rounded, size: 14.sp, color: Colors.white),
    );
  }
}
