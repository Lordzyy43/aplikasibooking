import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, venue),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(venue),
                  SizedBox(height: 24.h),
                  _buildQuickInfoRow(venue),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('Fasilitas Venue', null),
                  SizedBox(height: 14.h),
                  _buildFasilitasRow(venue.amenities),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('Pilih Lapangan', 'Tersedia ${venue.courts.length} Lapangan'),
                  SizedBox(height: 14.h),
                  _buildCourtSelectionList(venue),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('Peraturan GOR', null),
                  SizedBox(height: 14.h),
                  _buildRuleCard(
                    FontAwesomeIcons.shirt,
                    'Pakaian Olahraga',
                    'Wajib menggunakan sepatu olahraga indoor.',
                  ),
                  SizedBox(height: 10.h),
                  _buildRuleCard(
                    FontAwesomeIcons.banSmoking,
                    'Dilarang Merokok',
                    'Area bebas asap rokok demi kenyamanan bersama.',
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, VenueModel venue) {
    return SliverAppBar(
      expandedHeight: 300.h,
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
            CachedNetworkImage(
              imageUrl: venue.imageUrl,
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.62),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            _buildEliteBadge(),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          venue.description,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp, height: 1.4),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16.sp),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                venue.location,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
                maxLines: 1,
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
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoItem(Icons.star_rounded, '${venue.rating} (${venue.reviewCount}+)', 'Rating'),
          _infoItem(Icons.access_time_filled_rounded, '08:00 - 22:00', 'Buka'),
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
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14.sp, color: AppColors.accent),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: AppColors.textMuted, fontSize: 11.sp),
        ),
      ],
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
        children: [
          Icon(Icons.verified_rounded, color: AppColors.primary, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            'VERIFIED',
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: CachedNetworkImage(
                    imageUrl: court.imageUrl,
                    width: 90.w,
                    height: 90.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        court.name,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${court.surface} - ${court.environment}',
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
                    color: AppColors.surfaceLow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18.sp,
                    color: AppColors.primary,
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
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              children: [
                Icon(icons[amenity] ?? Icons.check_circle, size: 18.sp, color: AppColors.textPrimary),
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
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
