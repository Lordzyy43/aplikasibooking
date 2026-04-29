import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/booking_model.dart';
import '../../models/venue_model.dart';
import '../../providers/app_data_provider.dart';
import '../venue/venue_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppDataProvider>();
    final user = appData.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user.name),
              _buildSearchBar(),
              _buildPromoBanner(
                title: appData.promo.title,
                subtitle: appData.promo.subtitle,
                ctaLabel: appData.promo.ctaLabel,
              ),
              _buildCategorySection(appData.sportsCategories),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    _buildSectionHeader('Recently Booked', 'History'),
                    SizedBox(height: 16.h),
                    _buildRecentBookingCard(appData.upcomingBookings.isNotEmpty
                        ? appData.upcomingBookings.first
                        : appData.completedBookings.first),
                    SizedBox(height: 24.h),
                    _buildSectionHeader('Recommended Venues', 'View All'),
                    SizedBox(height: 16.h),
                    _buildRecommendedList(context, appData.recommendedVenues),
                    SizedBox(height: 30.h),
                    _buildSectionHeader('Nearby Locations', null),
                    SizedBox(height: 16.h),
                    _buildNearbyList(context, appData.nearbyVenues),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              ),
              Text(
                userName,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(11.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const FaIcon(
                  FontAwesomeIcons.solidBell,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                right: 3,
                top: 3,
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner({
    required String title,
    required String subtitle,
    required String ctaLabel,
  }) {
    return Container(
      height: 150.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24.w,
            bottom: -24.h,
            child: Icon(
              Icons.sports_tennis,
              size: 160.sp,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLowest.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    ctaLabel,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
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

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 16,
            color: AppColors.textMuted,
          ),
          SizedBox(width: 12.w),
          Text(
            'Search your favorite court...',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
          ),
          const Spacer(),
          const FaIcon(
            FontAwesomeIcons.sliders,
            size: 16,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(List<String> categories) {
    final displayCategories = categories.take(5).toList();
    final icons = <String, FaIconData>{
      'Tennis': FontAwesomeIcons.tableTennisPaddleBall,
      'Soccer': FontAwesomeIcons.futbol,
      'Basketball': FontAwesomeIcons.basketball,
      'Volleyball': FontAwesomeIcons.volleyball,
      'Badminton': FontAwesomeIcons.tableTennisPaddleBall,
      'All': FontAwesomeIcons.layerGroup,
    };

    return SizedBox(
      height: 122.h,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.w, top: 16.h),
        scrollDirection: Axis.horizontal,
        itemCount: displayCategories.length,
        itemBuilder: (context, index) {
          final category = displayCategories[index];
          final iconData = icons[category] ?? FontAwesomeIcons.layerGroup;
          return Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: FaIcon(iconData, color: AppColors.primary, size: 20),
                ),
                SizedBox(height: 8.h),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentBookingCard(BookingModel booking) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(11.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: const FaIcon(
              FontAwesomeIcons.medal,
              color: AppColors.accent,
              size: 18,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.venueName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${booking.sport} • ${booking.courtName}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999.r)),
            ),
            child: Text(
              'REBOOK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        if (action != null)
          Text(
            action,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendedList(BuildContext context, List<VenueModel> venues) {
    return SizedBox(
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)),
            ),
            child: Container(
              width: 260.w,
              margin: EdgeInsets.only(right: 18.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                        child: CachedNetworkImage(
                          imageUrl: venue.imageUrl,
                          height: 140.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLowest.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            venue.sports.first,
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.locationDot,
                              size: 10,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                venue.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              CurrencyFormatter.idr(venue.pricePerHour),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '/hr',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildNearbyList(BuildContext context, List<VenueModel> venues) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: venues.length,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)),
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: CachedNetworkImage(
                    width: 70.w,
                    height: 70.w,
                    imageUrl: venue.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${venue.sports.join(' • ')} • ${venue.distanceKm.toStringAsFixed(1)} km away',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '⭐ ${venue.rating} (${venue.reviewCount} reviews)',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
