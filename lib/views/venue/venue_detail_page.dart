import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'court_detail_page.dart';

class VenueDetailPage extends StatefulWidget {
  const VenueDetailPage({super.key});

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Ultra light gray agar card terlihat stand out
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

                  // INFO ROW (Jarak, Rating, Jam Buka)
                  _buildQuickInfoRow(),
                  SizedBox(height: 30.h),

                  // FASILITAS SECTION
                  Text(
                    "Fasilitas Venue",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.h),
                  _buildFasilitasRow(),

                  SizedBox(height: 30.h),

                  // COURT SELECTION (Core Action)
                  _buildSectionHeader("Pilih Lapangan", "Tersedia 3 Lapangan"),
                  SizedBox(height: 15.h),
                  _buildCourtSelectionList(),

                  SizedBox(height: 30.h),

                  // PERATURAN SECTION (Biar makin Pro)
                  _buildSectionHeader("Peraturan GOR", null),
                  SizedBox(height: 15.h),
                  _buildRuleCard(
                    FontAwesomeIcons.shirt,
                    "Pakaian Olahraga",
                    "Wajib menggunakan sepatu olahraga indoor.",
                  ),
                  SizedBox(height: 10.h),
                  _buildRuleCard(
                    FontAwesomeIcons.banSmoking,
                    "Dilarang Merokok",
                    "Area bebas asap rokok demi kenyamanan bersama.",
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

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
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
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            _buildEliteBadge(),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16.sp),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                "Olympic Sports Complex, Solo Baru, Sukoharjo",
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

  Widget _buildQuickInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoItem(Icons.star_rounded, "4.8 (120+)", "Rating"),
        _infoItem(Icons.access_time_filled_rounded, "08:00 - 22:00", "Buka"),
        _infoItem(Icons.directions_walk_rounded, "1.2 km", "Jarak"),
      ],
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14.sp, color: Colors.orange),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
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
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, color: AppColors.primary, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            "VERIFIED",
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
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
          ),
      ],
    );
  }

  Widget _buildCourtSelectionList() {
    return Column(
      children: List.generate(3, (index) {
        return GestureDetector(
          onTap: () {
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
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/seed/court$index/200/200",
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
                        "Grand Court 0${index + 1}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Lantai Interlock - Indoor",
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            "Rp 50.000",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            "/jam",
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward_rounded, size: 18.sp, color: AppColors.primary),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFasilitasRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _iconFasilitas(FontAwesomeIcons.wifi, "WiFi"),
          _iconFasilitas(FontAwesomeIcons.shower, "Shower"),
          _iconFasilitas(FontAwesomeIcons.plug, "Socket"),
          _iconFasilitas(FontAwesomeIcons.bottleWater, "Mineral"),
          _iconFasilitas(FontAwesomeIcons.p, "Parkir"),
        ],
      ),
    );
  }

  // 1. Update fungsi _iconFasilitas
  // Gunakan dynamic agar bisa menerima FontAwesomeIcons maupun Icons biasa
  Widget _iconFasilitas(dynamic icon, String label) {
    return Container(
      margin: EdgeInsets.only(right: 20.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            // Jika icon adalah FaIconData, gunakan FaIcon. Jika tidak, gunakan Icon biasa.
            child: icon is IconData
                ? Icon(icon, size: 18.sp, color: AppColors.textPrimary)
                : FaIcon(icon, size: 18.sp, color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Lakukan hal yang sama untuk _buildRuleCard jika masih error
  Widget _buildRuleCard(dynamic icon, String title, String desc) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), shape: BoxShape.circle),
            child: icon is IconData
                ? Icon(icon, color: Colors.redAccent, size: 16.sp)
                : FaIcon(icon, color: Colors.redAccent, size: 16.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
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
