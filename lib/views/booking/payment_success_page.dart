import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../history/mybooking_page.dart';
import '../main_screen.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().resetBooking();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 100.sp),
            ),
            SizedBox(height: 25.h),
            Text(
              'Booking Berhasil!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Pembayaran telah dikonfirmasi. Siapkan fisikmu untuk pertandingan nanti!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp, height: 1.5),
            ),
            SizedBox(height: 40.h),
            _buildMiniReceipt(),
            SizedBox(height: 50.h),
            _buildActionButton(
              context,
              label: 'Lihat Tiket Saya',
              isPrimary: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyBookingPage()),
                );
              },
            ),
            SizedBox(height: 15.h),
            _buildActionButton(
              context,
              label: 'Kembali ke Beranda',
              isPrimary: false,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniReceipt() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _receiptRow(booking.venueName),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _receiptSubItem('Tanggal', DateFormat('dd MMM yyyy').format(booking.date)),
              _receiptSubItem('Jam', booking.startTime),
              _receiptSubItem('Total', CurrencyFormatter.idr(booking.totalPrice)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(String title) {
    return Row(
      children: [
        Icon(Icons.check_circle_rounded, size: 16.sp, color: AppColors.primary),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _receiptSubItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          side: isPrimary ? BorderSide.none : BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),
        ),
      ),
    );
  }
}
