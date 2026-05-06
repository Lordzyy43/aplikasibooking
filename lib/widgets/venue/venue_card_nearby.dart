import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:intl/intl.dart'; // Tambahkan intl di pubspec.yaml

class VenueCardNearby extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback? onTap;

  const VenueCardNearby({super.key, required this.venue, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Format harga ke Rupiah
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        // Memastikan ripple InkWell tidak tembus keluar corner
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(10.w), // Sedikit lebih rapat agar info lebih luas
              child: Row(
                children: [
                  // --- AREA GAMBAR ---
                  Hero(
                    // Tambahkan Hero animation agar transisi ke Detail smooth
                    tag: 'venue-${venue.id}',
                    child: AppRemoteImage(
                      imageUrl: venue.imageUrl,
                      width: 95.w,
                      height: 95.w,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // --- AREA INFO ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                venue.name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Rating Badge yang lebih "pills" style
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star_rounded, size: 14.sp, color: Colors.orange),
                                  Text(
                                    ' ${venue.rating}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // Lokasi
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 13.sp, color: Colors.grey),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                venue.location,
                                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        // Harga (Ditambahkan sebagai pemaksimal info)
                        Text(
                          "${currencyFormat.format(venue.pricePerHour)} / jam",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Footer: Badge Olahraga & Jarak
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              venue.sports.first,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.near_me_rounded, size: 12.sp, color: Colors.blue),
                                SizedBox(width: 4.w),
                                Text(
                                  '${venue.distanceKm} km',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
