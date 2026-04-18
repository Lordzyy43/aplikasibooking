import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'gor_detail_page.dart'; // Nanti kita buat ini

class GorListPage extends StatelessWidget {
  const GorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jelajahi GOR"), centerTitle: false),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildGorCard(context, index);
        },
      ),
    );
  }

  Widget _buildGorCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Detail GOR
        Navigator.push(context, MaterialPageRoute(builder: (context) => const GorDetailPage()));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Image.network(
                "https://picsum.photos/400/180?random=$index",
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GOR Serbaguna $index",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      Text(
                        "⭐ 4.8",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.locationDot, size: 12.sp, color: AppColors.textMuted),
                      SizedBox(width: 6.w),
                      Text(
                        "Kec. Sukajadi, Pekanbaru",
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
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
