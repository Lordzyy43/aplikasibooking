import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:apkbooking/widgets/common/media_gallery_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'court_detail_page.dart';

class VenueDetailPage extends StatefulWidget {
  const VenueDetailPage({super.key, required this.venue});

  final VenueModel venue;

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _courtsKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(context, venue),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(venue),
                  SizedBox(height: 24.h),
                  _buildQuickInfoRow(venue),
                  SizedBox(height: 24.h),
                  _buildSectionHeader('Galeri Venue', 'Swipe untuk lihat semua'),
                  SizedBox(height: 14.h),
                  MediaGalleryCarousel(
                    images: venue.galleryUrls,
                    height: 220.h,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('Fasilitas Venue', null),
                  SizedBox(height: 14.h),
                  _buildFasilitasRow(venue.amenities),
                  SizedBox(height: 28.h),
                  KeyedSubtree(
                    key: _courtsKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          'Pilih Lapangan',
                          'Tersedia ${venue.courts.length} Lapangan',
                        ),
                        SizedBox(height: 14.h),
                        _buildCourtSelectionList(venue),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('Review Pengguna', '${venue.reviewCount} ulasan'),
                  SizedBox(height: 14.h),
                  _buildReviewSummary(venue),
                  SizedBox(height: 14.h),
                  ...venue.reviews.map(_buildReviewCard),
                  SizedBox(height: 18.h),
                  _buildSectionHeader('Peraturan Venue', null),
                  SizedBox(height: 14.h),
                  _buildRuleCard(
                    FontAwesomeIcons.shirt,
                    'Pakaian olahraga',
                    'Gunakan sepatu indoor dan pakaian latihan yang nyaman.',
                  ),
                  SizedBox(height: 10.h),
                  _buildRuleCard(
                    FontAwesomeIcons.banSmoking,
                    'Bebas asap rokok',
                    'Area venue dijaga tetap nyaman dan bersih untuk semua pemain.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),
          child: SizedBox(
            height: 54.h,
            child: ElevatedButton(
              onPressed: _scrollToCourts,
              child: const Text('Lihat Lapangan Tersedia'),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToCourts() {
    final context = _courtsKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: 0.1,
    );
  }

  Widget _buildSliverAppBar(BuildContext context, VenueModel venue) {
    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: AppColors.surfaceLowest.withValues(alpha: 0.9),
          child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20.sp),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppRemoteImage(
              imageUrl: venue.imageUrl,
              width: double.infinity,
              height: double.infinity,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.68),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(VenueModel venue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                venue.name,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _buildEliteBadge(),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          venue.description,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp, height: 1.5),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16.sp),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                venue.location,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInfoRow(VenueModel venue) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryContainer.withValues(alpha: 0.45),
            AppColors.infoContainer.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoItem(Icons.star_rounded, '${venue.rating} (${venue.reviewCount}+)', 'Rating'),
          _infoItem(Icons.access_time_filled_rounded, '08:00 - 22:00', 'Jam Buka'),
          _infoItem(
            Icons.directions_walk_rounded,
            '${venue.distanceKm.toStringAsFixed(1)} km',
            'Jarak',
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14.sp, color: AppColors.accent),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(color: AppColors.textMuted, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: AppColors.primary, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            'Terverifikasi',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? subtitle) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
          ),
      ],
    );
  }

  Widget _buildCourtSelectionList(VenueModel venue) {
    return Column(
      children: venue.courts.map((court) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourtDetailPage(venue: venue, court: court),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                AppRemoteImage(
                  imageUrl: court.imageUrl,
                  width: 90.w,
                  height: 90.w,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        court.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${court.surface} • ${court.environment}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            CurrencyFormatter.idr(court.pricePerHour),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '/jam',
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accentTeal],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFasilitasRow(List<String> amenities) {
    final icons = <String, IconData>{
      'WiFi': Icons.wifi_rounded,
      'Shower': Icons.shower_rounded,
      'Socket': Icons.electrical_services_rounded,
      'Mineral': Icons.local_drink_rounded,
      'Parkir': Icons.local_parking_rounded,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: amenities.map((amenity) {
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.surfaceLow,
                  AppColors.secondaryContainer.withValues(alpha: 0.35),
                ],
              ),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              children: [
                Icon(
                  icons[amenity] ?? Icons.check_circle,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 8.h),
                Text(
                  amenity,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewSummary(VenueModel venue) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentRose],
              ),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Center(
              child: Text(
                venue.rating.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Disukai pemain reguler',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${venue.reviewCount} ulasan dengan banyak feedback positif soal kebersihan, cahaya, dan kenyamanan venue.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(VenueReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(review.avatarUrl),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.author,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      review.timeLabel,
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.warningContainer,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14.sp, color: AppColors.accent),
                    SizedBox(width: 4.w),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (review.hasPhoto) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.photo_library_outlined, size: 14.sp, color: AppColors.accentRose),
                SizedBox(width: 6.w),
                Text(
                  'Menyertakan foto venue',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentRose,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRuleCard(dynamic icon, String title, String desc) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: AppColors.errorContainer,
              shape: BoxShape.circle,
            ),
            child: icon is IconData
                ? Icon(icon, color: AppColors.error, size: 16.sp)
                : FaIcon(icon, color: AppColors.error, size: 16.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.sp),
                ),
                Text(
                  desc,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
