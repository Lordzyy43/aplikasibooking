import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:apkbooking/views/booking/payment_page.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  static const int _serviceFee = 2500;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final user = context.watch<AppDataProvider>().user;

    final subtotal = bookingProvider.selectedPrice;
    final fee = _serviceFee;
    final total = subtotal + fee;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckoutHero(context, total),
              SizedBox(height: 22.h),

              _buildSectionHeader(
                context,
                title: 'Ringkasan Pesanan',
                icon: FontAwesomeIcons.receipt,
              ),
              SizedBox(height: 12.h),
              _buildFinalSummaryCard(context, bookingProvider),

              SizedBox(height: 22.h),

              _buildSectionHeader(
                context,
                title: 'Detail Kontak',
                icon: FontAwesomeIcons.solidUser,
              ),
              SizedBox(height: 12.h),
              _buildUserInfoCard(
                context,
                name: user.name,
                phone: user.phone ?? '-',
                email: user.email,
              ),

              SizedBox(height: 22.h),

              _buildSectionHeader(
                context,
                title: 'Metode Pembayaran',
                icon: FontAwesomeIcons.wallet,
              ),
              SizedBox(height: 12.h),
              _buildPaymentMethodSelector(context),

              SizedBox(height: 22.h),

              _buildSectionHeader(
                context,
                title: 'Rincian Biaya',
                icon: FontAwesomeIcons.fileInvoiceDollar,
              ),
              SizedBox(height: 12.h),
              _buildPriceDetail(context, subtotal, fee, total),

              SizedBox(height: 112.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAction(context, total),
    );
  }

  Widget _buildCheckoutHero(BuildContext context, int total) {
    final theme = Theme.of(context);

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
            child: _buildGlowCircle(size: 122.h, color: Colors.white.withValues(alpha: 0.10)),
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
                      border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                    ),
                    child: Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Checkout',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Cek detail booking sebelum pembayaran',
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
                      label: 'Status',
                      value: 'Menunggu Bayar',
                      icon: Icons.pending_actions_rounded,
                      color: AppColors.accentGold,
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
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSummaryCard(BuildContext context, BookingProvider provider) {
    return _buildCard(
      child: Column(
        children: [
          _summaryItem(
            context,
            icon: FontAwesomeIcons.hospital,
            label: 'Venue',
            value: provider.selectedVenueName ?? '-',
          ),
          _cardDivider(),
          _summaryItem(
            context,
            icon: FontAwesomeIcons.tableTennisPaddleBall,
            label: 'Lapangan',
            value: provider.selectedField ?? '-',
          ),
          _cardDivider(),
          _summaryItem(
            context,
            icon: FontAwesomeIcons.clock,
            label: 'Jadwal Main',
            value:
                '${DateFormat('EEE, dd MMM yyyy').format(provider.selectedDate)} • ${provider.selectedTime ?? '-'}',
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    BuildContext context, {
    required FaIconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _iconBox(icon: icon, color: AppColors.primary),
        SizedBox(width: 13.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(
    BuildContext context, {
    required String name,
    required String phone,
    required String email,
  }) {
    return _buildCard(
      child: Column(
        children: [
          _infoRow(context, label: 'Nama Lengkap', value: name, icon: FontAwesomeIcons.user),
          SizedBox(height: 15.h),
          _infoRow(context, label: 'WhatsApp', value: phone, icon: FontAwesomeIcons.whatsapp),
          SizedBox(height: 15.h),
          _infoRow(context, label: 'Email', value: email, icon: FontAwesomeIcons.envelope),
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String value,
    required FaIconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _iconBox(icon: icon, color: AppColors.primary, muted: true),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: () {
          _showSnackBar(context, 'QRIS dipilih sebagai metode pembayaran.');
        },
        borderRadius: BorderRadius.circular(24.r),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.055),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 46.h,
                width: 46.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    'QR',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QRIS',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Bayar cepat via QRIS untuk simulasi pembayaran.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'Dipilih',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.success,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceDetail(BuildContext context, int subtotal, int fee, int total) {
    final theme = Theme.of(context);

    return _buildCard(
      child: Column(
        children: [
          _priceRow(context, label: 'Biaya Sewa (1 Sesi)', price: CurrencyFormatter.idr(subtotal)),
          SizedBox(height: 12.h),
          _priceRow(context, label: 'Pajak & Layanan', price: CurrencyFormatter.idr(fee)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: DottedLine(
              dashLength: 5.w,
              dashGapLength: 5.w,
              lineThickness: 1,
              dashColor: AppColors.divider,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Tagihan',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                CurrencyFormatter.idr(total),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  fontSize: 19.sp,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, {required String label, required String price}) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          price,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 12.5.sp,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required FaIconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: 22.h,
          width: 5.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        SizedBox(width: 9.w),
        FaIcon(icon, size: 13.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, int total) {
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 11.5.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    CurrencyFormatter.idr(total),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            SizedBox(
              height: 54.h,
              width: 166.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bayar',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.sp),
                    ),
                    SizedBox(width: 7.w),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
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
      child: child,
    );
  }

  Widget _cardDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Divider(height: 1, color: AppColors.divider.withValues(alpha: 0.35)),
    );
  }

  Widget _iconBox({required FaIconData icon, required Color color, bool muted = false}) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: muted ? AppColors.surfaceLow : color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: color.withValues(alpha: muted ? 0.06 : 0.10)),
      ),
      child: Center(
        child: FaIcon(icon, size: 14.sp, color: color),
      ),
    );
  }

  Widget _buildGlowCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
      );
  }
}
