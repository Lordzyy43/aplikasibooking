import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/booking_provider.dart';
import '../booking/checkout_page.dart';

class CourtDetailPage extends StatefulWidget {
  final String courtName;
  final String courtImage;

  const CourtDetailPage({super.key, required this.courtName, required this.courtImage});

  @override
  State<CourtDetailPage> createState() => _CourtDetailPageState();
}

class _CourtDetailPageState extends State<CourtDetailPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(),
                  SizedBox(height: 25.h),

                  _sectionTitle("Fasilitas & Spesifikasi"),
                  SizedBox(height: 12.h),
                  _buildSpecs(),

                  SizedBox(height: 30.h),
                  _sectionTitle("Pilih Tanggal"),
                  SizedBox(height: 12.h),
                  _buildHorizontalDatePicker(provider),

                  SizedBox(height: 30.h),
                  _sectionTitle("Jam Tersedia"),
                  Text(
                    "Durasi sesi 60 menit",
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
                  ),
                  SizedBox(height: 15.h),
                  _buildTimeGrid(provider),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(provider),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18.sp),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(imageUrl: widget.courtImage, fit: BoxFit.cover),
            // Gradient Overlay agar teks/icon lebih terlihat
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.courtName,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                "Rp 50.000/Jam",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            Text(
              " 4.9 ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            Text(
              "(120 Ulasan) • ",
              style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
            ),
            Text(
              "Indoor",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecs() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _specRow(FontAwesomeIcons.layerGroup, "Lantai", "Vinyl Premium"),
          const Divider(height: 20),
          _specRow(FontAwesomeIcons.lightbulb, "Lampu", "LED High-Bay"),
          const Divider(height: 20),
          _specRow(FontAwesomeIcons.wind, "Ventilasi", "Exhaust Fan Pro"),
        ],
      ),
    );
  }

  Widget _specRow(dynamic icon, String label, String value) {
    return Row(
      children: [
        FaIcon(icon, size: 14.sp, color: Colors.grey),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget _buildHorizontalDatePicker(BookingProvider provider) {
    return SizedBox(
      height: 85.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 14, // Tampilkan 2 minggu
        itemBuilder: (context, index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          bool isSelected =
              DateFormat('dd-MM').format(date) == DateFormat('dd-MM').format(provider.selectedDate);

          return GestureDetector(
            onTap: () => provider.setDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 65.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
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

  Widget _buildTimeGrid(BookingProvider provider) {
    final times = [
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "13:00",
      "14:00",
      "15:00",
      "16:00",
      "19:00",
      "20:00",
      "21:00",
      "22:00",
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 2.1,
      ),
      itemCount: times.length,
      itemBuilder: (context, index) {
        String time = times[index];
        bool isSelected = provider.selectedTime == time;
        // Simulasi jam sibuk (booked)
        bool isBooked = index == 2 || index == 5;

        return GestureDetector(
          onTap: isBooked ? null : () => provider.setTime(time),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isBooked ? Colors.grey.shade100 : Colors.white),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isBooked ? Colors.transparent : Colors.grey.shade200),
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isBooked ? Colors.grey.shade400 : AppColors.textPrimary),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  decoration: isBooked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction(BookingProvider provider) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 35.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sesi Terpilih",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  provider.selectedTime != null
                      ? "${DateFormat('dd MMM').format(provider.selectedDate)} • ${provider.selectedTime}"
                      : "Pilih Jadwal",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150.w,
            height: 52.h,
            child: ElevatedButton(
              onPressed: provider.selectedTime == null
                  ? null
                  : () {
                      // Set data tambahan ke provider jika perlu
                      provider.setSelectedField(widget.courtName);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutPage()),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 0,
              ),
              child: Text(
                "Lanjut",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
