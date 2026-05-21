import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/views/booking/booking_detail_page.dart';
import 'package:apkbooking/views/venue/venue_list_page.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:apkbooking/widgets/common/empty_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppDataProvider>().refreshBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(
                context,
                activeCount: provider.upcomingBookings.length,
                historyCount: provider.completedBookings.length,
              ),
              SizedBox(height: 14.h),
              _buildTabBar(context),
              SizedBox(height: 8.h),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildBookingList(
                      context,
                      provider.upcomingBookings,
                      isHistory: false,
                    ),
                    _buildBookingList(
                      context,
                      provider.completedBookings,
                      isHistory: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required int activeCount,
    required int historyCount,
  }) {
    final theme = Theme.of(context);
    final totalCount = activeCount + historyCount;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
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
              right: -34.w,
              top: -34.h,
              child: _buildGlowCircle(
                size: 112.h,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              left: -40.w,
              bottom: -42.h,
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
                        Icons.confirmation_number_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Saya',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Kelola tiket dan riwayat booking lapanganmu',
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
                      child: _buildStatPill(
                        context,
                        label: 'Aktif',
                        value: activeCount.toString(),
                        icon: Icons.flash_on_rounded,
                        color: AppColors.accentGold,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildStatPill(
                        context,
                        label: 'Total',
                        value: totalCount.toString(),
                        icon: Icons.history_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(
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
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.32)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.045),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TabBar(
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900),
          unselectedLabelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(
    BuildContext context,
    List<BookingModel> bookings, {
    required bool isHistory,
  }) {
    if (bookings.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 128.h),
        child: EmptyStateView(
          icon: isHistory
              ? Icons.history_rounded
              : Icons.calendar_today_outlined,
          title: isHistory ? 'Belum ada riwayat' : 'Belum ada booking aktif',
          message: isHistory
              ? 'Riwayat booking yang sudah selesai akan muncul di sini.'
              : 'Setelah kamu melakukan booking, e-ticket akan muncul di sini.',
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 128.h),
      physics: const BouncingScrollPhysics(),
      itemCount: bookings.length,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        return _BookingCard(booking: bookings[index], isHistory: isHistory);
      },
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

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isHistory;

  const _BookingCard({required this.booking, required this.isHistory});

  bool get isActive => booking.status == BookingStatus.upcoming;

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatTime(String time) {
    if (time.isEmpty) return '--:--';

    final parts = time.split(':');
    return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : time;
  }

  String _statusLabel() {
    return booking.shortStatusLabel;
  }

  Color _statusColor() {
    if (booking.isPendingPayment) return AppColors.warning;
    if (booking.isCancelled || booking.isExpired) return AppColors.error;
    if (booking.isFinished) return AppColors.success;
    return AppColors.primary;
  }

  IconData _statusIcon() {
    if (booking.isPendingPayment) return Icons.schedule_rounded;
    if (booking.isCancelled || booking.isExpired) return Icons.cancel_rounded;
    if (booking.isFinished) return Icons.check_circle_rounded;
    return Icons.flash_on_rounded;
  }

  void _handleAction(BuildContext context) {
    if (isActive) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookingDetailPage(booking: booking)),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VenueListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = isActive ? AppColors.primary : AppColors.accentRose;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: () => _handleAction(context),
        borderRadius: BorderRadius.circular(24.r),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.divider.withValues(alpha: 0.28),
            ),
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
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    _buildImage(),
                    SizedBox(width: 13.w),
                    Expanded(child: _buildInfo(context, theme)),
                  ],
                ),
              ),
              _buildFooter(context, theme, actionColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: 94.w,
      height: 102.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppRemoteImage(
              imageUrl: booking.venueImageUrl,
              width: 94.w,
              height: 102.h,
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 8.w,
            bottom: 8.h,
            child: Container(
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.sports_tennis_rounded,
                color: AppColors.primary,
                size: 17.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusBadge(theme),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                '#${booking.id}',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10.5.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 9.h),
        Text(
          booking.venueName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.35,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          '${booking.sport} • ${booking.courtName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 14.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                '${_formatDate(booking.date)} • ${_formatTime(booking.startTime)} - ${_formatTime(booking.endTime)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    ThemeData theme,
    Color actionColor,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withValues(alpha: 0.75),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.22)),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 34.h,
            width: 34.h,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              Icons.payments_rounded,
              color: AppColors.primary,
              size: 17.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pembayaran',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10.5.sp,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  CurrencyFormatter.idr(booking.totalPrice),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Material(
            color: actionColor,
            borderRadius: BorderRadius.circular(15.r),
            child: InkWell(
              onTap: () => _handleAction(context),
              borderRadius: BorderRadius.circular(15.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive
                          ? Icons.confirmation_number_outlined
                          : Icons.refresh_rounded,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isActive
                          ? (booking.isPendingPayment ? 'Detail' : 'E-Ticket')
                          : 'Booking Lagi',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final color = _statusColor();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(), color: color, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            _statusLabel(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
