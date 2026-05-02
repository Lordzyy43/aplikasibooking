import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/venue_model.dart';

class VenueCardRecommended extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback? onTap;

  const VenueCardRecommended({
    super.key, 
    required this.venue, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220.w,
        margin: EdgeInsets.only(right: 16.w, bottom: 8.h, top: 4.h), // Memberi ruang untuk shadow
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r), // Lebih rounded agar modern
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Perbaikan posisi properti
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Venue dengan Aspect Ratio yang konsisten
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  child: Image.network(
                    venue.imageUrl,
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 130.h,
                        color: Colors.grey[100],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 130.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image_outlined, color: Colors.grey[400]),
                    ),
                  ),
                ),
                // Badge Rating di atas gambar (Opsional untuk estetika)
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14.sp, color: Colors.orange),
                        SizedBox(width: 2.w),
                        Text(
                          venue.rating.toString(),
                          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800, // Lebih tebal sesuai tren UI terbaru
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  
                  // Lokasi
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 13.sp, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          venue.location,
                          style: TextStyle(
                            fontSize: 11.sp, 
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // Harga dan Info Sesi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Rp ${venue.pricePerHour}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text: '/jam',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ikon indikator ketersediaan atau panah detail
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 10.sp, color: AppColors.primary),
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