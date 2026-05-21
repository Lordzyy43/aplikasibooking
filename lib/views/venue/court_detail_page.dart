import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/services/supabase_booking_service.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:apkbooking/widgets/common/media_gallery_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:apkbooking/views/booking/checkout_page.dart';

class CourtDetailPage extends StatefulWidget {
  const CourtDetailPage({super.key, required this.venue, required this.court});

  final VenueModel venue;
  final VenueCourtModel court;

  @override
  State<CourtDetailPage> createState() => _CourtDetailPageState();
}

class _CourtDetailPageState extends State<CourtDetailPage> {
  final SupabaseBookingService _bookingService = SupabaseBookingService();
  List<CourtAvailabilitySlot> _availabilitySlots = const [];
  List<VenueReviewModel> _reviews = const [];
  bool _isLoadingAvailability = false;
  bool _isLoadingReviews = false;
  String? _availabilityError;
  int _availabilityRequestId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<BookingProvider>();
      _loadAvailability(provider.selectedDate);
      _loadReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 132.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(),
                  SizedBox(height: 24.h),

                  _sectionTitle('Galeri Lapangan'),
                  SizedBox(height: 12.h),
                  MediaGalleryCarousel(
                    images: widget.court.galleryUrls,
                    height: 210.h,
                    borderRadius: BorderRadius.circular(22.r),
                  ),

                  SizedBox(height: 24.h),

                  _sectionTitle('Fasilitas & Spesifikasi'),
                  SizedBox(height: 12.h),
                  _buildSpecs(),

                  SizedBox(height: 30.h),

                  _sectionTitle('Ulasan Lapangan'),
                  SizedBox(height: 12.h),
                  _buildReviews(),

                  SizedBox(height: 30.h),

                  _sectionTitle('Pilih Tanggal'),
                  SizedBox(height: 12.h),
                  _buildHorizontalDatePicker(provider),

                  SizedBox(height: 30.h),

                  _sectionTitle('Jam Tersedia'),
                  SizedBox(height: 4.h),
                  Text(
                    'Durasi sesi 60 menit',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildTimeGrid(provider),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(context, provider),
    );
  }

  Widget _sectionTitle(String title) {
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
        Expanded(
          child: Text(
            title,
            style: TextStyle(
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

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: AppColors.primary,
      leadingWidth: 64.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 14.w),
        child: Center(
          child: Material(
            color: Colors.white.withValues(alpha: 0.92),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: const CircleBorder(),
              child: SizedBox(
                height: 42.h,
                width: 42.h,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: 17.sp,
                ),
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppRemoteImage(
              imageUrl: widget.court.imageUrl,
              width: double.infinity,
              height: double.infinity,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.46),
                    Colors.black.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: 22.h,
              child: Row(
                children: [
                  _buildHeroBadge(
                    icon: Icons.star_rounded,
                    label: widget.venue.rating.toStringAsFixed(1),
                    color: AppColors.accentGold,
                  ),
                  SizedBox(width: 10.w),
                  _buildHeroBadge(
                    icon: Icons.sports_tennis_rounded,
                    label: widget.court.environment,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: 155.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15.sp),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.court.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                  height: 1.18,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _buildPriceBadge(),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.star_rounded, color: AppColors.accentGold, size: 19.sp),
            SizedBox(width: 4.w),
            Text(
              widget.venue.rating.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                '(${widget.venue.reviewCount} ulasan) • ${widget.court.environment}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceBadge() {
    return Container(
      constraints: BoxConstraints(maxWidth: 145.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.infoContainer],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: CurrencyFormatter.idr(widget.court.pricePerHour),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            TextSpan(
              text: '/jam',
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecs() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.26)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: widget.court.specs.entries.map((entry) {
          final isLast = entry.key == widget.court.specs.keys.last;

          return Column(
            children: [
              _specRow(entry.key, entry.value),
              if (!isLast)
                Divider(
                  height: 22.h,
                  color: AppColors.divider.withValues(alpha: 0.35),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviews() {
    if (_isLoadingReviews) {
      return Container(
        height: 92.h,
        alignment: Alignment.center,
        child: SizedBox(
          height: 26.w,
          width: 26.w,
          child: const CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    final reviews = _reviews.isNotEmpty ? _reviews : widget.venue.reviews;

    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.26)),
        ),
        child: Text(
          'Belum ada ulasan untuk lapangan ini.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(children: reviews.take(3).map(_reviewCard).toList());
  }

  Widget _reviewCard(VenueReviewModel review) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.26)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: AppRemoteImage(
              imageUrl: review.avatarUrl,
              width: 40.w,
              height: 40.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.accentGold,
                      size: 15.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  review.timeLabel,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (review.comment.trim().isNotEmpty) ...[
                  SizedBox(height: 7.h),
                  Text(
                    review.comment,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalDatePicker(BookingProvider provider) {
    return SizedBox(
      height: 88.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected =
              DateFormat('dd-MM').format(date) ==
              DateFormat('dd-MM').format(provider.selectedDate);

          return GestureDetector(
            onTap: () => _selectDate(provider, date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 66.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.divider.withValues(alpha: 0.28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.22)
                        : AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: isSelected ? 14 : 10,
                    offset: Offset(0, isSelected ? 7 : 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    index == 0 ? 'Today' : DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : AppColors.textMuted,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 17.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid(BookingProvider provider) {
    if (_isLoadingAvailability) {
      return Container(
        height: 116.h,
        alignment: Alignment.center,
        child: SizedBox(
          height: 28.w,
          width: 28.w,
          child: const CircularProgressIndicator(strokeWidth: 2.6),
        ),
      );
    }

    if (_availabilitySlots.isNotEmpty) {
      return _buildRemoteTimeGrid(provider);
    }

    if (_availabilityError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _availabilityError!,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          _buildDummyTimeGrid(provider),
        ],
      );
    }

    return _buildDummyTimeGrid(provider);
  }

  Widget _buildRemoteTimeGrid(BookingProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 2.05,
      ),
      itemCount: _availabilitySlots.length,
      itemBuilder: (context, index) {
        final slot = _availabilitySlots[index];
        final time = slot.displayLabel;
        final isSelected = provider.selectedTime == time;
        final isBooked = !slot.isAvailable;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
          child: InkWell(
            onTap: () {
              if (isBooked) {
                _showSnackBar(context, _availabilityMessage(time, slot.reason));
                return;
              }

              provider.setTime(time, slotId: slot.id);
            },
            borderRadius: BorderRadius.circular(14.r),
            splashColor: AppColors.primary.withValues(alpha: 0.08),
            highlightColor: AppColors.primary.withValues(alpha: 0.04),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected
                    ? null
                    : (isBooked
                          ? Colors.grey.shade100
                          : AppColors.surfaceLowest),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isBooked
                            ? Colors.transparent
                            : AppColors.divider.withValues(alpha: 0.30)),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.20),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isBooked
                              ? Colors.grey.shade400
                              : AppColors.textPrimary),
                    fontWeight: FontWeight.w900,
                    fontSize: 12.sp,
                    decoration: isBooked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDummyTimeGrid(BookingProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 2.05,
      ),
      itemCount: widget.court.availableTimes.length,
      itemBuilder: (context, index) {
        final time = widget.court.availableTimes[index];
        final isSelected = provider.selectedTime == time;
        final isBooked = widget.court.bookedTimes.contains(time);

        return _buildTimeTile(
          time: time,
          isSelected: isSelected,
          isBooked: isBooked,
          onTap: () {
            if (isBooked) {
              _showSnackBar(
                context,
                'Jam $time sudah dibooking. Pilih jam lain.',
              );
              return;
            }

            provider.setTime(time);
          },
        );
      },
    );
  }

  Widget _buildTimeTile({
    required String time,
    required bool isSelected,
    required bool isBooked,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected
                ? null
                : (isBooked ? Colors.grey.shade100 : AppColors.surfaceLowest),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isBooked
                        ? Colors.transparent
                        : AppColors.divider.withValues(alpha: 0.30)),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              time,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isBooked ? Colors.grey.shade400 : AppColors.textPrimary),
                fontWeight: FontWeight.w900,
                fontSize: 12.sp,
                decoration: isBooked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, BookingProvider provider) {
    final hasSelectedTime = provider.selectedTime != null;

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
            Expanded(child: _buildSelectedSessionInfo(provider)),
            SizedBox(width: 14.w),
            SizedBox(
              width: 142.w,
              height: 54.h,
              child: ElevatedButton(
                onPressed: () {
                  if (!hasSelectedTime) {
                    _showSnackBar(
                      context,
                      'Pilih jam tersedia terlebih dahulu.',
                    );
                    return;
                  }

                  provider.setVenueSelection(
                    venueId: widget.venue.id,
                    courtId: widget.court.id,
                    venueName: widget.venue.name,
                    venueLocation: widget.venue.location,
                    venueImageUrl: widget.venue.imageUrl,
                    sport: widget.venue.sports.isNotEmpty
                        ? widget.venue.sports.first
                        : '-',
                    fieldName: widget.court.name,
                    price: widget.court.pricePerHour,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.divider,
                  disabledForegroundColor: AppColors.textMuted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 7.w),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Lanjut',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedSessionInfo(BookingProvider provider) {
    final selectedText = provider.selectedTime != null
        ? '${DateFormat('dd MMM').format(provider.selectedDate)} • ${provider.selectedTime}'
        : 'Pilih Jadwal';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sesi Terpilih',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          selectedText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2.h),
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: CurrencyFormatter.idr(widget.court.pricePerHour),
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: '/jam',
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectDate(BookingProvider provider, DateTime date) {
    provider.setDate(date);
    _loadAvailability(date);
  }

  Future<void> _loadAvailability(DateTime date) async {
    final requestId = ++_availabilityRequestId;

    if (!_isUuid(widget.court.id)) {
      setState(() {
        _availabilitySlots = const [];
        _availabilityError = null;
        _isLoadingAvailability = false;
      });
      return;
    }

    setState(() {
      _isLoadingAvailability = true;
      _availabilityError = null;
    });

    try {
      final slots = await _bookingService.getCourtAvailability(
        courtId: widget.court.id,
        date: date,
      );

      if (!mounted || requestId != _availabilityRequestId) return;

      setState(() {
        _availabilitySlots = slots;
        _availabilityError = slots.isEmpty
            ? 'Slot belum tersedia untuk tanggal ini.'
            : null;
        _isLoadingAvailability = false;
      });
    } catch (_) {
      if (!mounted || requestId != _availabilityRequestId) return;

      setState(() {
        _availabilitySlots = const [];
        _availabilityError =
            'Slot Supabase belum bisa dimuat, menampilkan jadwal lokal.';
        _isLoadingAvailability = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    if (!_isUuid(widget.court.id)) return;

    setState(() => _isLoadingReviews = true);

    try {
      final reviews = await _bookingService.getCourtReviews(widget.court.id);
      if (!mounted) return;

      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingReviews = false);
    }
  }

  bool _isUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  String _availabilityMessage(String time, String? reason) {
    return switch (reason) {
      'booked' => 'Jam $time sudah dibooking. Pilih jam lain.',
      'maintenance' => 'Jam $time sedang maintenance.',
      'past_time' => 'Jam $time sudah lewat.',
      'outside_operating_hours' => 'Jam $time di luar jam operasional.',
      _ => 'Jam $time belum tersedia.',
    };
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
}
