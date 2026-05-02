import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final total = bookingProvider.selectedPrice + 2500;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressHeader(),
            SizedBox(height: 22.h),
            _buildQrisCard(bookingProvider.selectedVenueName ?? 'ArenaFlow Venue'),
            SizedBox(height: 20.h),
            _buildInstructionCard(),
            SizedBox(height: 20.h),
            _buildTotalInfo(total),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context, bookingProvider, total),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: const Icon(Icons.timer_outlined, color: AppColors.error),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selesaikan dalam 14:59',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Pembayaran akan otomatis dibatalkan jika melewati batas waktu.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrisCard(String venueName) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              'QRIS Pembayaran',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg',
            height: 210.w,
            width: 210.w,
          ),
          SizedBox(height: 14.h),
          Text(
            venueName,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            'NMID 123456789',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
    final steps = [
      'Buka aplikasi e-wallet atau mobile banking.',
      'Scan kode QRIS di atas.',
      'Pastikan nominal dan nama venue sudah sesuai.',
      'Kembali ke aplikasi setelah pembayaran selesai.',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Langkah Pembayaran',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          ...List.generate(steps.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22.w,
                    height: 22.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalInfo(int total) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Tagihan', style: TextStyle(fontWeight: FontWeight.w600)),
          Text(
            CurrencyFormatter.idr(total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, BookingProvider provider, int total) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
        child: SizedBox(
          height: 54.h,
          child: ElevatedButton(
            onPressed: () {
              final booking = BookingModel(
                id: 'BK-${DateTime.now().millisecondsSinceEpoch}',
                venueName: provider.selectedVenueName ?? '-',
                venueLocation: provider.selectedVenueLocation ?? '-',
                venueImageUrl: provider.selectedVenueImageUrl ?? '',
                courtName: provider.selectedField ?? '-',
                sport: provider.selectedSport ?? '-',
                date: provider.selectedDate,
                startTime: provider.selectedTime ?? '-',
                endTime: _endTimeFor(provider.selectedTime),
                totalPrice: total,
                status: BookingStatus.upcoming,
              );

              context.read<AppDataProvider>().confirmBooking(booking);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PaymentSuccessPage(booking: booking)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            ),
            child: const Text('Saya Sudah Bayar'),
          ),
        ),
      ),
    );
  }

  String _endTimeFor(String? time) {
    if (time == null) {
      return '-';
    }

    final parts = time.split(':');
    final hour = int.parse(parts.first);
    final nextHour = (hour + 1).toString().padLeft(2, '0');
    return '$nextHour:${parts.last}';
  }
}
