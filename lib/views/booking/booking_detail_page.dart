import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/services/supabase_booking_service.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final SupabaseBookingService _bookingService = SupabaseBookingService();
  bool _isSubmittingReview = false;
  bool _reviewSubmitted = false;
  int _rating = 5;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('E-Ticket Booking'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.accentTeal],
                ),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      booking.statusLabel.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    booking.venueName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    booking.venueLocation,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      _headerMeta('Kode', booking.id),
                      SizedBox(width: 16.w),
                      _headerMeta('Lapangan', booking.courtName),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  AppRemoteImage(
                    imageUrl: booking.venueImageUrl,
                    width: double.infinity,
                    height: 180.h,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Column(
                      children: [
                        _detailRow(
                          'Tanggal',
                          DateFormat('EEEE, dd MMM yyyy').format(booking.date),
                        ),
                        _detailRow(
                          'Jam Main',
                          '${booking.startTime} - ${booking.endTime}',
                        ),
                        _detailRow('Olahraga', booking.sport),
                        _detailRow('Lapangan', booking.courtName),
                        _detailRow('Status', booking.statusLabel),
                        _detailRow('Payment', booking.paymentLabel),
                        _detailRow(
                          'Total Bayar',
                          CurrencyFormatter.idr(booking.totalPrice),
                          emphasize: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 120.sp,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    booking.isPendingPayment
                        ? 'Booking sudah dibuat. Selesaikan pembayaran agar admin dapat mengonfirmasi jadwalmu.'
                        : 'Tunjukkan e-ticket ini saat check-in venue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            _buildReviewAction(context, booking),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewAction(BuildContext context, BookingModel booking) {
    if (!booking.isFinished) {
      return _infoBox(
        icon: Icons.rate_review_outlined,
        message: 'Ulasan bisa dikirim setelah booking selesai.',
      );
    }

    if (booking.hasReview || _reviewSubmitted) {
      return _infoBox(
        icon: Icons.check_circle_outline_rounded,
        message: 'Terima kasih, ulasan untuk booking ini sudah tersimpan.',
      );
    }

    final canSubmit =
        (booking.remoteId ?? '').isNotEmpty &&
        (booking.courtId ?? '').isNotEmpty;

    if (!canSubmit) {
      return _infoBox(
        icon: Icons.info_outline_rounded,
        message:
            'Ulasan hanya tersedia untuk booking yang tersimpan di Supabase.',
      );
    }

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
            'Beri Ulasan',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              return IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: _isSubmittingReview
                    ? null
                    : () => setState(() => _rating = value),
                icon: Icon(
                  value <= _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: AppColors.accentGold,
                  size: 28.sp,
                ),
              );
            }),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _reviewController,
            enabled: !_isSubmittingReview,
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Ceritakan pengalaman bermainmu...',
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmittingReview
                  ? null
                  : () => _submitReview(context, booking),
              child: _isSubmittingReview
                  ? SizedBox(
                      height: 18.w,
                      width: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Kirim Ulasan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.infoContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview(BuildContext context, BookingModel booking) async {
    setState(() => _isSubmittingReview = true);

    try {
      await _bookingService.submitReview(
        bookingId: booking.remoteId!,
        courtId: booking.courtId!,
        rating: _rating,
        comment: _reviewController.text,
      );

      if (!context.mounted) return;
      setState(() {
        _reviewSubmitted = true;
        _isSubmittingReview = false;
      });
      _showSnackBar(context, 'Ulasan berhasil dikirim.');
    } catch (_) {
      if (!context.mounted) return;
      setState(() => _isSubmittingReview = false);
      _showSnackBar(context, 'Ulasan belum bisa dikirim.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          margin: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );
  }

  Widget _headerMeta(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92.w,
            child: Text(
              label,
              style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: emphasize ? AppColors.primary : AppColors.textPrimary,
                fontSize: 13.sp,
                fontWeight: emphasize ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
