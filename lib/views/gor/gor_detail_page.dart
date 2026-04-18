import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import '../booking/booking_page.dart';

class GorDetailPage extends StatelessWidget {
  const GorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network("https://picsum.photos/400/300", fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GOR Serbaguna Utama",
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                            Text(
                              " 4.8",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Fasilitas lengkap dengan standar internasional. Cocok untuk Badminton, Futsal, dan Basket. Lokasi strategis dan parkir luas.",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Fasilitas GOR",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.h),
                  _buildFasilitasRow(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildFasilitasRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconFasilitas(FontAwesomeIcons.wifi, "Free WiFi"),
        // Mengganti squareP ke p (lebih umum di FontAwesome)
        _iconFasilitas(FontAwesomeIcons.p, "Parkir Luas"),
        _iconFasilitas(FontAwesomeIcons.shower, "Shower"),
        _iconFasilitas(FontAwesomeIcons.shop, "Kantin"),
      ],
    );
  }

  // --- KUNCI PERBAIKAN: Gunakan dynamic dan FaIcon ---
  Widget _iconFasilitas(dynamic icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: FaIcon(icon, size: 20.sp, color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mulai dari", style: TextStyle(fontSize: 12.sp)),
                Text(
                  "Rp 50.000/Jam",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
              ),
              child: const Text("Booking Sekarang"),
            ),
          ],
        ),
      ),
    );
  }
}
