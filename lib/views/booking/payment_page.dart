import 'dart:async';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:apkbooking/views/booking/payment_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const int _serviceFee = 2500;
  static const int _initialCountdownSeconds = 15 * 60;

  late int _remainingSeconds;
  Timer? _timer;

  bool get _isExpired => _remainingSeconds <= 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _initialCountdownSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _countdownText() {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final total = bookingProvider.selectedPrice + _serviceFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 116.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentHero(context, total),
              SizedBox(height: 22.h),
              _buildQrisCard(
                context,
                bookingProvider.selectedVenueName ?? 'Aerobook Venue',
              ),
              SizedBox(height: 22.h),
              _buildInstructionCard(context),
              SizedBox(height: 22.h),
              _buildTotalInfo(context, total),
              SizedBox(height: 16.h),
              _buildSecurityNote(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context, bookingProvider, total),
    );
  }

  Widget _buildPaymentHero(BuildContext context, int total) {
    final theme = Theme.of(context);
    final bookingCode = context.watch<BookingProvider>().remoteBookingCode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -38.w,
            top: -38.h,
            child: _buildGlowCircle(
              size: 122.h,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            left: -42.w,
            bottom: -44.h,
            child: _buildGlowCircle(
              size: 112.h,
              color: AppColors.accentGold.withValues(alpha: 0.16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        height: 42.h,
                        width: 42.h,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 17.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    height: 46.h,
                    width: 46.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Icon(
                      Icons.qr_code_2_rounded,
                      color: Colors.white,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pembayaran',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          bookingCode == null
                              ? 'Scan QRIS dan konfirmasi pembayaranmu'
                              : 'Kode booking #$bookingCode menunggu pembayaran',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: _buildHeroPill(
                      context,
                      label: _isExpired ? 'Status' : 'Sisa Waktu',
                      value: _isExpired ? 'Kadaluarsa' : _countdownText(),
                      icon: _isExpired
                          ? Icons.timer_off_rounded
                          : Icons.timer_outlined,
                      color: _isExpired
                          ? AppColors.errorContainer
                          : AppColors.accentGold,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildHeroPill(
                      context,
                      label: 'Total',
                      value: CurrencyFormatter.idr(total),
                      icon: Icons.payments_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPill(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    value,
                    key: ValueKey(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
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

  Widget _buildQrisCard(BuildContext context, String venueName) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.055),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 11.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'QRIS Pembayaran',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26.r),
              border: Border.all(
                color: AppColors.divider.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Image.asset(
              'assets/Avatar/QR2.png',
              height: 205.w,
              width: 205.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            venueName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              'NMID 123456789 • Demo Payment',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10.8.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(BuildContext context) {
    final theme = Theme.of(context);

    final steps = [
      'Buka aplikasi e-wallet atau mobile banking.',
      'Pilih menu scan QRIS lalu arahkan kamera ke kode QR.',
      'Pastikan nominal dan nama venue sudah sesuai.',
      'Tekan tombol “Saya Sudah Bayar” setelah pembayaran selesai.',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            context,
            icon: Icons.list_alt_rounded,
            title: 'Langkah Pembayaran',
          ),
          SizedBox(height: 14.h),
          ...List.generate(steps.length, (index) {
            final isLast = index == steps.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 13.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26.w,
                    height: 26.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 11.w),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.3.sp,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTotalInfo(BuildContext context, int total) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            height: 42.h,
            width: 42.h,
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
              size: 21.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Total Tagihan',
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            CurrencyFormatter.idr(total),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              fontSize: 18.sp,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNote(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.successContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: AppColors.success,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Ini adalah simulasi pembayaran untuk demo aplikasi. Setelah tombol konfirmasi ditekan, booking akan masuk ke daftar aktif.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: 32.h,
          width: 32.h,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    BookingProvider provider,
    int total,
  ) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SizedBox(
          height: 54.h,
          child: ElevatedButton(
            onPressed: _isExpired
                ? null
                : () {
                    final booking = BookingModel(
                      id:
                          provider.remoteBookingCode ??
                          'BK-${DateTime.now().millisecondsSinceEpoch}',
                      remoteId: provider.remoteBookingId,
                      courtId: provider.selectedCourtId,
                      venueName: provider.selectedVenueName ?? '-',
                      venueLocation: provider.selectedVenueLocation ?? '-',
                      venueImageUrl: provider.selectedVenueImageUrl ?? '',
                      courtName: provider.selectedField ?? '-',
                      sport: provider.selectedSport ?? '-',
                      date: provider.selectedDate,
                      startTime: provider.selectedTime ?? '-',
                      endTime: _endTimeFor(provider.selectedTime),
                      totalPrice: provider.remoteBookingTotal ?? total,
                      status: BookingStatus.upcoming,
                      rawStatus: provider.remoteBookingId == null
                          ? 'confirmed'
                          : 'pending_payment',
                      paymentStatus: provider.remoteBookingId == null
                          ? 'paid'
                          : 'pending',
                      paymentMethod: 'qris',
                    );

                    context.read<AppDataProvider>().confirmBooking(booking);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentSuccessPage(booking: booking),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: AppColors.divider,
              disabledForegroundColor: AppColors.textMuted,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isExpired
                      ? Icons.timer_off_rounded
                      : Icons.check_circle_outline_rounded,
                  color: _isExpired ? AppColors.textMuted : Colors.white,
                  size: 19.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  _isExpired ? 'Waktu Pembayaran Habis' : 'Saya Sudah Bayar',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: _isExpired ? AppColors.textMuted : Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _endTimeFor(String? time) {
    if (time == null || time.trim().isEmpty || !time.contains(':')) {
      return '-';
    }

    final parts = time.split(':');
    final hour = int.tryParse(parts.first);

    if (hour == null || parts.length < 2) {
      return '-';
    }

    final nextHour = (hour + 1) % 24;
    return '${nextHour.toString().padLeft(2, '0')}:${parts[1]}';
  }

  Widget _buildGlowCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
