import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/booking_model.dart';

class RecentBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;
  final VoidCallback? onTicketTap;

  const RecentBookingCard({super.key, required this.booking, this.onTap, this.onTicketTap});

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatTime(String time) {
    if (time.isEmpty) return '--:--';

    final parts = time.split(':');
    return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : time;
  }

  String _relativeDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDate = DateTime(date.year, date.month, date.day);

    final difference = bookingDate.difference(today).inDays;

    if (difference == 0) return 'Hari ini';
    if (difference == 1) return 'Besok';
    if (difference > 1 && difference <= 7) return '$difference hari lagi';

    return _formatDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26.r),
        splashColor: Colors.white.withValues(alpha: 0.12),
        highlightColor: Colors.white.withValues(alpha: 0.06),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.r),
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.26),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26.r),
            child: Stack(
              children: [
                Positioned(
                  right: -44.w,
                  top: -44.h,
                  child: _buildGlowCircle(size: 132.h, color: Colors.white.withValues(alpha: 0.10)),
                ),
                Positioned(
                  left: -36.w,
                  bottom: -46.h,
                  child: _buildGlowCircle(
                    size: 120.h,
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                  ),
                ),
                Positioned(
                  right: 12.w,
                  bottom: -20.h,
                  child: Icon(
                    Icons.confirmation_number_rounded,
                    size: 118.sp,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopRow(theme),
                      SizedBox(height: 18.h),
                      _buildVenueInfo(theme),
                      SizedBox(height: 16.h),
                      _buildScheduleInfo(theme),
                      SizedBox(height: 14.h),
                      Divider(color: Colors.white.withValues(alpha: 0.14), thickness: 1, height: 1),
                      SizedBox(height: 14.h),
                      _buildBottomRow(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flash_on_rounded, color: AppColors.accentGold, size: 14.sp),
              SizedBox(width: 5.w),
              Text(
                'UPCOMING MATCH',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          height: 34.h,
          width: 34.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Icon(Icons.more_horiz_rounded, color: Colors.white, size: 20.sp),
        ),
      ],
    );
  }

  Widget _buildVenueInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          booking.venueName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(
              Icons.sports_tennis_rounded,
              color: Colors.white.withValues(alpha: 0.78),
              size: 16.sp,
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Text(
                'Jadwal booking lapangan kamu sudah siap',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleInfo(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoPill(
            icon: Icons.calendar_month_rounded,
            title: _relativeDateLabel(booking.date),
            subtitle: _formatDate(booking.date),
            theme: theme,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildInfoPill(
            icon: Icons.access_time_filled_rounded,
            title: _formatTime(booking.startTime),
            subtitle: 'Waktu mulai',
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPill({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            height: 34.h,
            width: 34.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(icon, color: Colors.white, size: 18.sp),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(ThemeData theme) {
    return Row(
      children: [
        Container(
          height: 34.h,
          width: 34.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.13),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Icon(Icons.qr_code_2_rounded, size: 17.sp, color: Colors.white),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kode Booking',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '#${booking.id}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          child: InkWell(
            onTap: onTicketTap ?? onTap,
            borderRadius: BorderRadius.circular(15.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat Tiket',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 15.sp),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlowCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
