import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/venue/venue_list_page.dart';

class HomePromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaLabel;
  // Tambahkan field onTap agar error "isn't an instance field" hilang
  final VoidCallback? onTap;

  const HomePromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    this.onTap, // Sekarang ini sudah valid
  });

  @override
  Widget build(BuildContext context) {
    // Membungkus seluruh Container dengan InkWell/GestureDetector
    // agar seluruh area banner bisa diklik menggunakan parameter onTap
    return InkWell(
      onTap:
          onTap ??
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueListPage())),
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        constraints: BoxConstraints(minHeight: 170.h),
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
                color: Colors.white.withOpacity(0.1), // Sesuaikan jika .withValues error
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBadge(),
                  SizedBox(height: 12.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildSubtitle(),
                  SizedBox(height: 12.h),
                  _buildCTA(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        'Promo minggu ini',
        style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildSubtitle() {
    return SizedBox(
      width: 210.w,
      child: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 13.sp),
      ),
    );
  }

  Widget _buildCTA(BuildContext context) {
    // Tombol CTA tetap ada secara visual, tapi navigasi utama
    // ditangani oleh InkWell di root build method
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest.withOpacity(0.92),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ctaLabel,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.arrow_forward_rounded, size: 14.sp, color: AppColors.primary),
        ],
      ),
    );
  }
}
