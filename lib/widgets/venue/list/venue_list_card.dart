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

  String _primarySport() {
    if (venue.sports.isEmpty) return 'Sport';
    return venue.sports.first;
  }

  IconData _sportIcon(String sportName) {
    final sport = sportName.toLowerCase();

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

  String _formatDistance(num distance) {
    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    }

    return '${distance.toStringAsFixed(distance % 1 == 0 ? 0 : 1)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(26.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26.r),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(26.r),
              border: Border.all(color: AppColors.divider.withValues(alpha: 0.26)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.065),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildImageSection(context), _buildInfoSection(context)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final theme = Theme.of(context);
    final primarySport = _primarySport();

    return SizedBox(
      height: 176.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppRemoteImage(imageUrl: venue.imageUrl, width: double.infinity, height: 176.h),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.48),
                    Colors.black.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(top: 14.h, left: 14.w, child: _buildStatusBadge(context)),

          Positioned(top: 14.h, right: 14.w, child: _buildRatingBadge(context)),

          Positioned(
            left: 14.w,
            right: 14.w,
            bottom: 14.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _buildImageTitle(theme, primarySport)),
                SizedBox(width: 10.w),
                _buildPriceTag(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTitle(ThemeData theme, String primarySport) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 150.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_sportIcon(primarySport), color: Colors.white, size: 14.sp),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  primarySport,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.successContainer.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 13.sp),
          SizedBox(width: 5.w),
          Text(
            venue.statusLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
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
          Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14.sp),
          SizedBox(width: 3.w),
          Text(
            venue.rating.toStringAsFixed(1),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTag(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: CurrencyFormatter.idr(venue.pricePerHour),
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: ' / jam',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 15.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          SizedBox(height: 8.h),
          _buildLocation(theme),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(child: _buildSportsTags(theme)),
              SizedBox(width: 10.w),
              _buildArrowButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Text(
      venue.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w900,
        fontSize: 17.sp,
        color: AppColors.textPrimary,
        letterSpacing: -0.35,
      ),
    );
  }

  Widget _buildLocation(ThemeData theme) {
    return Row(
      children: [
        Container(
          height: 30.h,
          width: 30.h,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16.sp),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: Text(
            '${venue.location} • ${_formatDistance(venue.distanceKm)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSportsTags(ThemeData theme) {
    final visibleSports = venue.sports.take(3).toList();
    final extraCount = venue.sports.length - visibleSports.length;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ...visibleSports.map((sport) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: AppColors.divider.withValues(alpha: 0.28)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_sportIcon(sport), color: AppColors.primary, size: 12.sp),
                SizedBox(width: 5.w),
                Text(
                  sport,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10.5.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          );
        }),
        if (extraCount > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              '+$extraCount',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10.5.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildArrowButton() {
    return Container(
      height: 34.h,
      width: 34.h,
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
      child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 17.sp),
    );
  }
}
