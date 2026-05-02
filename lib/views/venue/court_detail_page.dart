import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:apkbooking/widgets/common/media_gallery_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:apkbooking/views/booking/checkout_page.dart';

class CourtDetailPage extends StatelessWidget {
  const CourtDetailPage({
    super.key,
    required this.venue,
    required this.court,
  });

  final VenueModel venue;
  final VenueCourtModel court;

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
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(),
                  SizedBox(height: 24.h),
                  _sectionTitle('Galeri Lapangan'),
                  SizedBox(height: 12.h),
                  MediaGalleryCarousel(
                    images: court.galleryUrls,
                    height: 210.h,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  SizedBox(height: 24.h),
                  _sectionTitle('Fasilitas & Spesifikasi'),
                  SizedBox(height: 12.h),
                  _buildSpecs(),
                  SizedBox(height: 30.h),
                  _sectionTitle('Pilih Tanggal'),
                  SizedBox(height: 12.h),
                  _buildHorizontalDatePicker(provider),
                  SizedBox(height: 30.h),
                  _sectionTitle('Jam Tersedia'),
                  Text(
                    'Durasi sesi 60 menit',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
                  ),
                  SizedBox(height: 15.h),
                  _buildTimeGrid(provider),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context, provider),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18.sp),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(court.imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                court.name,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.infoContainer],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${CurrencyFormatter.idr(court.pricePerHour)}/Jam',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.accent, size: 20),
            Text(
              ' ${venue.rating} ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            Text(
              '(${venue.reviewCount} ulasan) • ',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
            ),
            Text(
              court.environment,
              style: TextStyle(
                color: AppColors.accentTeal,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecs() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: court.specs.entries.map((entry) {
          final isLast = entry.key == court.specs.keys.last;
          return Column(
            children: [
              _specRow(entry.key, entry.value),
              if (!isLast) const Divider(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _specRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget _buildHorizontalDatePicker(BookingProvider provider) {
    return SizedBox(
      height: 85.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected =
              DateFormat('dd-MM').format(date) == DateFormat('dd-MM').format(provider.selectedDate);

          return GestureDetector(
            onTap: () => provider.setDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 65.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(colors: [AppColors.primary, AppColors.accentTeal])
                    : null,
                color: isSelected ? null : AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 2.1,
      ),
      itemCount: court.availableTimes.length,
      itemBuilder: (context, index) {
        final time = court.availableTimes[index];
        final isSelected = provider.selectedTime == time;
        final isBooked = court.bookedTimes.contains(time);

        return GestureDetector(
          onTap: isBooked ? null : () => provider.setTime(time),
          child: Container(
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(colors: [AppColors.primary, AppColors.accentRose])
                  : null,
              color: isSelected
                  ? null
                  : (isBooked ? Colors.grey.shade100 : AppColors.surfaceLowest),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isBooked ? Colors.transparent : Colors.grey.shade200),
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isBooked ? Colors.grey.shade400 : AppColors.textPrimary),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  decoration: isBooked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction(BuildContext context, BookingProvider provider) {
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
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesi Terpilih',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  provider.selectedTime != null
                      ? '${DateFormat('dd MMM').format(provider.selectedDate)} • ${provider.selectedTime}'
                      : 'Pilih Jadwal',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150.w,
            height: 52.h,
            child: ElevatedButton(
              onPressed: provider.selectedTime == null
                  ? null
                  : () {
                      provider.setVenueSelection(
                        venueId: venue.id,
                        venueName: venue.name,
                        venueLocation: venue.location,
                        venueImageUrl: venue.imageUrl,
                        sport: venue.sports.first,
                        fieldName: court.name,
                        price: court.pricePerHour,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutPage()),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 0,
              ),
              child: Text(
                'Lanjut',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
