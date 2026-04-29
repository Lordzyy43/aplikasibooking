import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'payment_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final user = context.watch<AppDataProvider>().user;
    final subtotal = bookingProvider.selectedPrice;
    final fee = 2500;
    final total = subtotal + fee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Ringkasan Pesanan', FontAwesomeIcons.receipt),
            SizedBox(height: 12.h),
            _buildFinalSummaryCard(bookingProvider),
            SizedBox(height: 25.h),
            _buildSectionLabel('Detail Kontak', FontAwesomeIcons.solidUser),
            SizedBox(height: 12.h),
            _buildUserInfoCard(user.name, user.phone ?? '-', user.email),
            SizedBox(height: 25.h),
            _buildSectionLabel('Metode Pembayaran', FontAwesomeIcons.wallet),
            SizedBox(height: 12.h),
            _buildPaymentMethodSelector(),
            SizedBox(height: 25.h),
            _buildSectionLabel('Rincian Biaya', FontAwesomeIcons.fileInvoiceDollar),
            SizedBox(height: 12.h),
            _buildPriceDetail(subtotal, fee, total),
            SizedBox(height: 120.h),
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(context, total),
    );
  }

  Widget _buildFinalSummaryCard(BookingProvider provider) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _summaryItem(FontAwesomeIcons.hospital, 'Venue', provider.selectedVenueName ?? '-'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: Colors.grey.shade100, thickness: 1),
          ),
          _summaryItem(
            FontAwesomeIcons.tableTennisPaddleBall,
            'Lapangan',
            provider.selectedField ?? '-',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: Colors.grey.shade100, thickness: 1),
          ),
          _summaryItem(
            FontAwesomeIcons.clock,
            'Jadwal Main',
            "${DateFormat('EEE, dd MMM').format(provider.selectedDate)} • ${provider.selectedTime ?? '-'}",
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(dynamic icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(icon, size: 13.sp, color: AppColors.primary),
          ),
        ),
        SizedBox(width: 15.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(String name, String phone, String email) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow('Nama Lengkap', name, FontAwesomeIcons.user),
          SizedBox(height: 16.h),
          _infoRow('WhatsApp', phone, FontAwesomeIcons.whatsapp),
          SizedBox(height: 16.h),
          _infoRow('Email', email, FontAwesomeIcons.envelope),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, FaIconData icon) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(child: FaIcon(icon, color: AppColors.primary, size: 14.sp)),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted)),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'QRIS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Text(
            'Bayar Cepat via QRIS',
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 12.sp, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPriceDetail(int subtotal, int fee, int total) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow('Biaya Sewa (1 Sesi)', CurrencyFormatter.idr(subtotal)),
          _priceRow('Pajak & Layanan', CurrencyFormatter.idr(fee)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: DottedLine(
              dashLength: 5.w,
              dashGapLength: 5.w,
              lineThickness: 1,
              dashColor: Colors.grey.shade300,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Tagihan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              Text(
                CurrencyFormatter.idr(total),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String price) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, dynamic iconData) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Row(
        children: [
          FaIcon(iconData, size: 12.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, int total) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 35.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                CurrencyFormatter.idr(total),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 160.w,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 0,
              ),
              child: Text(
                'Bayar Sekarang',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
