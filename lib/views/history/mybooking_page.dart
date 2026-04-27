import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';

class MyBookingPage extends StatelessWidget {
  const MyBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: false,
          title: Text(
            "My Bookings",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingList(status: "Active"),
            _buildBookingList(status: "History"),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList({required String status}) {
    // Simulasi data kosong jika tidak ada booking active
    bool isEmpty = status == "Active" ? false : false; // Ubah true untuk testing empty state

    if (isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      physics: const BouncingScrollPhysics(),
      itemCount: status == "Active" ? 1 : 5,
      itemBuilder: (context, index) {
        return _buildBookingCard(status, index);
      },
    );
  }

  Widget _buildBookingCard(String status, int index) {
    bool isActive = status == "Active";

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                // Venue Image dengan Badge Jenis Olahraga
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: CachedNetworkImage(
                        imageUrl: "https://picsum.photos/seed/${index + 200}/200",
                        width: 90.w,
                        height: 90.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15.w),
                // Info Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusBadge(isActive),
                          Text(
                            "#BK-9921${index}", // Dummy ID Booking
                            style: TextStyle(fontSize: 10.sp, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Stadium Atelier",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      Text(
                        "Badminton • Court A",
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14.sp, color: AppColors.primary),
                          SizedBox(width: 5.w),
                          Text(
                            "08:00 - 10:00 WIB",
                            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Payment",
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textMuted),
                    ),
                    Text(
                      "Rp 120.000",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                isActive
                    ? _buildActionButton(
                        "E-Ticket",
                        AppColors.primary,
                        Icons.confirmation_number_outlined,
                      )
                    : _buildActionButton("Rebook", Colors.black87, Icons.refresh_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        isActive ? "UPCOMING" : "COMPLETED",
        style: TextStyle(
          color: isActive ? Colors.orange.shade800 : Colors.green.shade700,
          fontSize: 9.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (color == AppColors.primary)
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 80.sp, color: Colors.grey.shade300),
          SizedBox(height: 20.h),
          Text(
            "No Bookings Found",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "You haven't made any bookings yet.",
            style: TextStyle(fontSize: 13.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
