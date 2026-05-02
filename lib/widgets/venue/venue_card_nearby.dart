import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/venue_model.dart';

class VenueCardNearby extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback? onTap; // Tambahkan parameter callback

  const VenueCardNearby({
    super.key, 
    required this.venue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        // Menggunakan shadow halus daripada border agar terlihat lebih modern/clean
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Material & InkWell digunakan agar efek klik (ripple) mengikuti radius container
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // Thumbnail dengan Placeholder & Error State
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    venue.imageUrl,
                    width: 85.w,
                    height: 85.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 85.w,
                      height: 85.w,
                      color: Colors.grey[100],
                      child: Icon(Icons.broken_image_outlined, color: Colors.grey[400], size: 20.sp),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                
                // Info Area
                Expanded(
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
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Rating kecil di pojok kanan atas
                          Row(
                            children: [
                              Icon(Icons.star_rounded, size: 14.sp, color: Colors.orange),
                              Text(
                                ' ${venue.rating}',
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      
                      // Alamat
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 12.sp, color: AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              venue.location,
                              style: TextStyle(
                                fontSize: 11.sp, 
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      // Footer: Kategori & Jarak
                      Row(
                        children: [
                          // Badge Olahraga
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              venue.sports.first.toUpperCase(), // Uppercase untuk style badge
                              style: TextStyle(
                                fontSize: 9.sp, 
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Info Jarak
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.directions_walk_rounded, size: 10.sp, color: Colors.grey[600]),
                                SizedBox(width: 2.w),
                                Text(
                                  '${venue.distanceKm} km',
                                  style: TextStyle(
                                    fontSize: 11.sp, 
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}