import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'payment_success_page.dart';
import '../../core/app_colors.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pembayaran", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.w),
        child: Column(
          children: [
            Text(
              "Selesaikan Pembayaran Dalam",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            Text(
              "14:59", // Dummy Timer
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 30.h),

            // Dummy QRIS Container
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg",
                    height: 200.w,
                    width: 200.w,
                  ),
                  SizedBox(height: 10.h),
                  const Text("NAMA GOR ATELIER", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "NMKID: 123456789",
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),
            _buildTotalInfo(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildTotalInfo() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total Tagihan", style: TextStyle(fontWeight: FontWeight.w600)),
          Text(
            "Rp 102.500",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 30.h),
      child: ElevatedButton(
        onPressed: () {
          // Simulasi pindah ke halaman sukses
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaymentSuccessPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: Size(double.infinity, 52.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
        child: const Text(
          "Saya Sudah Bayar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
