import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),

              // NEW: PROMO BANNER
              _buildPromoBanner(),

              _buildCategorySection(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // NEW: RECENTLY BOOKED
                    _buildSectionHeader("Recently Booked", "History"),
                    SizedBox(height: 16.h),
                    _buildRecentBookingCard(),

                    SizedBox(height: 24.h),
                    _buildSectionHeader("Recommended Venues", "View All"),
                    SizedBox(height: 16.h),
                    _buildRecommendedList(),

                    SizedBox(height: 30.h),
                    _buildSectionHeader("Nearby Locations", null),
                    SizedBox(height: 16.h),
                    _buildNearbyList(),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning,",
                style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              ),
              Text(
                "Yogi Eka Saputra",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: const FaIcon(FontAwesomeIcons.solidBell, size: 20, color: AppColors.primary),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 140.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -10,
            child: Icon(Icons.sports_tennis, size: 150, color: Colors.white.withOpacity(0.1)),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Get 30% OFF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "On all indoor arenas this week",
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.sp),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    "Claim Now",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
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
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16, color: AppColors.textMuted),
          SizedBox(width: 12.w),
          Text(
            "Search your favorite court...",
            style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
          ),
          const Spacer(),
          const FaIcon(FontAwesomeIcons.sliders, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      {'name': 'Tennis', 'icon': FontAwesomeIcons.tableTennisPaddleBall},
      {'name': 'Soccer', 'icon': FontAwesomeIcons.futbol},
      {'name': 'Basket', 'icon': FontAwesomeIcons.basketball},
      {'name': 'Volleyball', 'icon': FontAwesomeIcons.volleyball},
      {'name': 'Badminton', 'icon': FontAwesomeIcons.tableTennisPaddleBall},
    ];

    return SizedBox(
      height: 125.h, // FIXED: Tinggi ditambah agar tidak overflow
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final iconData = categories[index]['icon'] as FaIconData;
          return Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: FaIcon(iconData, color: AppColors.primary, size: 22),
                ),
                SizedBox(height: 8.h),
                Text(
                  categories[index]['name'] as String,
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

  Widget _buildRecentBookingCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(18.r)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const FaIcon(FontAwesomeIcons.medal, color: Colors.amber, size: 20),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "The Smash Club",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  "Booked 2 days ago • Badminton",
                  style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text(
              "REBOOK",
              style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
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
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendedList() {
    return SizedBox(
      height: 260.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 260.w,
            margin: EdgeInsets.only(right: 18.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                      child: CachedNetworkImage(
                        imageUrl: "https://picsum.photos/seed/${index + 40}/500/300",
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "NEW",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
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
                        "Stadium Atelier",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
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
                          Text(
                            "Olympic Complex",
                            style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                          ),
                          const Spacer(),
                          Text(
                            "\$120",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            "/hr",
                            style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  width: 70.w,
                  height: 70.w,
                  imageUrl: "https://picsum.photos/seed/${index + 10}/200",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Grand Slam Arena",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                    Text(
                      "Tennis • 1.2 km away",
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "⭐ 4.8 (120 reviews)",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
            ],
          ),
        );
      },
    );
  }
}
