import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:intl/intl.dart';

class RecentBookingCard extends StatelessWidget {
  final BookingModel booking;

  const RecentBookingCard({super.key, required this.booking});

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatTime(String time) {
    if (time.isEmpty) return '--:--';
    final parts = time.split(':');
    return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : time;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r), // Lebih round agar modern
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // Stack digunakan untuk membuat pola dekoratif tanpa gambar asset
      child: Stack(
        children: [
          // Pola Dekoratif Lingkaran di Pojok Kanan Atas
          Positioned(
            right: -20.w,
            top: -20.h,
            child: CircleAvatar(radius: 60.r, backgroundColor: Colors.white.withOpacity(0.05)),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.amber, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'UPCOMING MATCH',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_horiz, color: Colors.white, size: 22.sp),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  booking.venueName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, color: Colors.white70, size: 16.sp),
                    SizedBox(width: 8.w),
                    Text(
                      '${_formatDate(booking.date)}  •  ${_formatTime(booking.startTime)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.confirmation_number_outlined,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'ID: #${booking.id}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Navigasi detail
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text(
                        'Lihat Tiket',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
