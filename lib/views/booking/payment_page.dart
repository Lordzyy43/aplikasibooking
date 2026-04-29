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
        padding: EdgeInsets.all(25.w),
        child: Column(
          children: [
            Text(
              'Selesaikan Pembayaran Dalam',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            Text(
              '14:59',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg',
                    height: 200.w,
                    width: 200.w,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    bookingProvider.selectedVenueName ?? 'ArenaFlow Venue',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'NMKID: 123456789',
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            _buildTotalInfo(total),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context, bookingProvider, total),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 30.h),
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
          minimumSize: Size(double.infinity, 52.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
        child: const Text(
          'Saya Sudah Bayar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
