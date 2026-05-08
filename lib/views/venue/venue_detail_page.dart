import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:apkbooking/widgets/common/media_gallery_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/views/venue/court_detail_page.dart';

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

  int _startingPrice(VenueModel venue) {
    if (venue.courts.isEmpty) {
      return venue.pricePerHour;
    }

    final prices = venue.courts.map((court) => court.pricePerHour).toList();
    prices.sort();

    return prices.first;
  }

  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, venue),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 132.h),
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
                          'Tersedia ${venue.courts.length} lapangan',
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
      bottomNavigationBar: _buildBottomAction(context, venue),
    );
  }

  void _scrollToCourts() {
    final context = _courtsKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  Widget _buildSliverAppBar(BuildContext context, VenueModel venue) {
    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leadingWidth: 64.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 14.w),
        child: Center(
          child: Material(
            color: AppColors.surfaceLowest.withValues(alpha: 0.92),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
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
                    AppColors.primary.withValues(alpha: 0.78),
                    Colors.black.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: 24.h,
              child: Row(
                children: [
                  _heroBadge(
                    icon: Icons.star_rounded,
                    label: venue.rating.toStringAsFixed(1),
                    color: AppColors.accentGold,
                  ),
                  SizedBox(width: 10.w),
                  _heroBadge(
                    icon: Icons.location_on_rounded,
                    label: '${venue.distanceKm.toStringAsFixed(1)} km',
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

  Widget _heroBadge({required IconData icon, required String label, required Color color}) {
    return Container(
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
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w900),
          ),
        ],
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
                  letterSpacing: -0.6,
                  height: 1.15,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _buildEliteBadge(),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          venue.description,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.58),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16.sp),
            ),
            SizedBox(width: 9.w),
            Expanded(
              child: Text(
                venue.location,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryContainer.withValues(alpha: 0.45),
            AppColors.infoContainer.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          _infoItem(Icons.star_rounded, '${venue.rating} (${venue.reviewCount}+)', 'Rating'),
          _verticalDivider(),
          _infoItem(Icons.access_time_filled_rounded, '08:00 - 22:00', 'Jam Buka'),
          _verticalDivider(),
          _infoItem(
            Icons.directions_walk_rounded,
            '${venue.distanceKm.toStringAsFixed(1)} km',
            'Jarak',
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 42.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: AppColors.primary.withValues(alpha: 0.10),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 32.h,
            width: 32.h,
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 17.sp, color: AppColors.accent),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12.5.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: AppColors.primary, size: 13.sp),
          SizedBox(width: 5.w),
          Text(
            'Terverifikasi',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 10.5.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? subtitle) {
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
        if (subtitle != null)
          Flexible(
            child: Text(
              subtitle,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCourtSelectionList(VenueModel venue) {
    return Column(
      children: venue.courts.map((court) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22.r),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourtDetailPage(venue: venue, court: court),
                ),
              );
            },
            borderRadius: BorderRadius.circular(22.r),
            splashColor: AppColors.primary.withValues(alpha: 0.08),
            highlightColor: AppColors.primary.withValues(alpha: 0.04),
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.w),
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
              child: Row(
                children: [
                  AppRemoteImage(
                    imageUrl: court.imageUrl,
                    width: 92.w,
                    height: 92.w,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          court.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.5.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          '${court.surface} • ${court.environment}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: CurrencyFormatter.idr(court.pricePerHour),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  fontSize: 14.sp,
                                ),
                              ),
                              TextSpan(
                                text: '/jam',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    height: 36.h,
                    width: 36.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_rounded, size: 18.sp, color: Colors.white),
                  ),
                ],
              ),
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
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
            ),
            child: Column(
              children: [
                Icon(icons[amenity] ?? Icons.check_circle, size: 19.sp, color: AppColors.primary),
                SizedBox(height: 8.h),
                Text(
                  amenity,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
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
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.26)),
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentRose],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                venue.rating.toStringAsFixed(1),
                style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w900),
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
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '${venue.reviewCount} ulasan dengan banyak feedback positif soal kebersihan, cahaya, dan kenyamanan venue.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
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
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: AppRemoteImage.imageProvider(review.avatarUrl),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.author,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      review.timeLabel,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
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
                        fontWeight: FontWeight.w900,
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
              fontWeight: FontWeight.w500,
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
                    fontWeight: FontWeight.w800,
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

  Widget _buildRuleCard(FaIconData icon, String title, String desc) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Container(
            height: 42.h,
            width: 42.h,
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.10)),
            ),
            child: Center(
              child: FaIcon(icon, color: AppColors.error, size: 16.sp),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textMuted,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, VenueModel venue) {
    final startingPrice = _startingPrice(venue);

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
                    'Mulai dari',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: CurrencyFormatter.idr(startingPrice),
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        TextSpan(
                          text: '/jam',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${venue.courts.length} lapangan tersedia',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
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
                onPressed: _scrollToCourts,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_tennis_rounded, color: Colors.white, size: 18.sp),
                    SizedBox(width: 7.w),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Lihat Lapangan',
                          maxLines: 1,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
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
}
