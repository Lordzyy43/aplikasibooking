import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main_screen.dart';
import '../../core/app_colors.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Section dengan Shadow Glow
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 100.sp),
            ),
            SizedBox(height: 25.h),
            Text(
              "Booking Berhasil!",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Pembayaran telah dikonfirmasi. Siapkan fisikmu untuk pertandingan nanti!",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp, height: 1.5),
            ),

            SizedBox(height: 40.h),

            // DUMMY TICKET CARD
            _buildMiniReceipt(),

            SizedBox(height: 50.h),

            _buildActionButton(
              context,
              label: "Lihat Tiket Saya",
              isPrimary: true,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
            ),
            SizedBox(height: 15.h),

            _buildActionButton(
              context,
              label: "Kembali ke Beranda",
              isPrimary: false,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniReceipt() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pakai Icon standar atau FA, di bawah kita buat fleksibel
          _receiptRow(FontAwesomeIcons.circleCheck, "Stadium Atelier"),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _receiptSubItem("Tanggal", "28 Apr 2026"),
              _receiptSubItem("Jam", "19:00 WIB"),
              _receiptSubItem("Lapangan", "Court 01"),
            ],
          ),
        ],
      ),
    );
  }

  // FIX: Menggunakan IconData dan widget FaIcon dengan cast yang benar
  Widget _receiptRow(FaIconData icon, String title) {
    return Row(
      children: [
        // Gunakan FaIcon dan pastikan tipenya dipaksa menjadi FaIconData jika dari FontAwesome
        FaIcon(icon, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _receiptSubItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          side: isPrimary ? BorderSide.none : BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),
        ),
      ),
    );
  }
}
