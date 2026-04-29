import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'venue_detail_page.dart';

class VenueListPage extends StatefulWidget {
  const VenueListPage({super.key});

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppDataProvider>();
    final sports = appData.sportsCategories;
    final selectedSport = sports[selectedCategory];
    final venues = _filterVenues(appData.venues, selectedSport);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Explore Venues',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(
              FontAwesomeIcons.sliders,
              color: AppColors.primary,
              size: 18,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(sports),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: venues.length,
              itemBuilder: (context, index) => _buildGorCard(context, venues[index]),
            ),
          ),
        ],
      ),
    );
  }

  List<VenueModel> _filterVenues(List<VenueModel> venues, String selectedSport) {
    if (selectedSport == 'All') {
      return venues;
    }
    return venues.where((venue) => venue.sports.contains(selectedSport)).toList();
  }

  Widget _buildFilterTabs(List<String> sports) {
    return SizedBox(
      height: 52.h,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.w, top: 6.h, bottom: 6.h),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.secondaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Center(
                child: Text(
                  sports[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGorCard(BuildContext context, VenueModel venue) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VenueDetailPage(venue: venue)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 18.h),
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
                  child: Image.network(
                    venue.imageUrl,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.successContainer,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      venue.statusLabel,
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      '${CurrencyFormatter.idr(venue.pricePerHour)} / hr',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          venue.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.accent, size: 16),
                          Text(
                            ' ${venue.rating}',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${venue.location} • ${venue.distanceKm.toStringAsFixed(1)} km',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: venue.sports.map((sport) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLow,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          sport,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
