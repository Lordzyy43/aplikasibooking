import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'court_detail_page.dart'; // Import halaman baru

class VenueDetailPage extends StatefulWidget {
  const VenueDetailPage({super.key});

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  int selectedDateIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  SizedBox(height: 25.h),

                  // 1. DATE SELECTION (Konteks Global Venue)
                  _buildSectionHeader("Pilih Tanggal Main", "October 2025"),
                  SizedBox(height: 15.h),
                  _buildHorizontalDatePicker(),

                  SizedBox(height: 30.h),

                  // 2. COURT LIST (Konteks Navigasi ke Detail)
                  _buildSectionHeader("Lapangan Tersedia", null),
                  SizedBox(height: 15.h),
                  _buildCourtSelectionList(),

                  SizedBox(height: 30.h),

                  // 3. HIGHLIGHTS & INFO
                  Text(
                    "Highlight Venue",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.h),
                  _buildFasilitasRow(),

                  SizedBox(height: 20.h),
                  _buildHighlightCard(
                    FontAwesomeIcons.shieldHalved,
                    "Jaminan Keamanan",
                    "Sanitasi harian dan pengecekan keamanan rutin oleh staf profesional.",
                  ),

                  SizedBox(height: 50.h), // Padding bawah agar tidak mepet
                ],
              ),
            ),
          ),
        ],
      ),
      // BottomAction dihapus karena flow-nya pindah ke CourtDetail
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: "https://picsum.photos/id/101/800/600",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Stadium Atelier",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            _buildEliteBadge(),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Icon(Icons.location_on, color: AppColors.primary, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              "Olympic Sports Complex, Section B",
              style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEliteBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        "ELITE VENUE",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10.sp),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalDatePicker() {
    final days = ["MON", "TUE", "WED", "THU", "FRI", "SAT"];
    final dates = ["14", "15", "16", "17", "18", "19"];

    return SizedBox(
      height: 85.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedDateIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = index),
            child: Container(
              width: 65.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : AppColors.textMuted,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    dates[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
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

  Widget _buildCourtSelectionList() {
    return Column(
      children: List.generate(2, (index) {
        return GestureDetector(
          onTap: () {
            // EVOLUTION: Navigasi ke CourtDetailPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourtDetailPage(
                  courtName: "Grand Court 0${index + 1}",
                  courtImage: "https://picsum.photos/seed/court$index/800/600",
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildCourtImage(index),
                SizedBox(width: 15.w),
                Expanded(child: _buildCourtInfo(index)),
                Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCourtImage(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: CachedNetworkImage(
        imageUrl: "https://picsum.photos/seed/court$index/200/200",
        width: 80.w,
        height: 80.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCourtInfo(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Grand Court 0${index + 1}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          "Professional Hardcourt",
          style: TextStyle(fontSize: 11.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildStatusBadge("4 Slots Left", Colors.orange),
            SizedBox(width: 8.w),
            Text(
              "Rp 50rb/jam",
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 9.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHighlightCard(dynamic icon, String title, String desc) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, color: AppColors.primary, size: 20),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  desc,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFasilitasRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _iconFasilitas(FontAwesomeIcons.wifi, "WiFi"),
          _iconFasilitas(FontAwesomeIcons.shower, "Shower"),
          _iconFasilitas(FontAwesomeIcons.plug, "Socket"),
          _iconFasilitas(FontAwesomeIcons.bottleWater, "Water"),
          _iconFasilitas(FontAwesomeIcons.p, "Parkir"),
        ],
      ),
    );
  }

  Widget _iconFasilitas(dynamic icon, String label) {
    return Container(
      margin: EdgeInsets.only(right: 20.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: FaIcon(icon, size: 16.sp, color: AppColors.textPrimary),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
