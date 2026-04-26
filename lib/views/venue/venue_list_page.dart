import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'venue_detail_page.dart';

class VenueListPage extends StatefulWidget {
  const VenueListPage({super.key});

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  int selectedCategory = 0;
  final List<String> sports = ["All", "Futsal", "Badminton", "Basketball", "Tennis"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Explore Venues",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.sliders, color: AppColors.primary, size: 18),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildGorCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Filter Olahraga
  Widget _buildFilterTabs() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  sports[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textMuted,
                    fontWeight: FontWeight.bold,
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

  Widget _buildGorCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const VenueDetailPage()));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  child: Image.network(
                    "https://picsum.photos/seed/${index + 50}/400/200",
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "OPEN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "IDR 50k / hr",
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
                      Text(
                        "Elite Sport Center $index",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            " 4.9",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
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
                      Text(
                        "Pekanbaru • 2.4 km",
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                      ),
                      const Spacer(),
                      Text(
                        "Futsal & Basket",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
  }
}
