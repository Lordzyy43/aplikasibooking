import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/auth/login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dasar hitam biar transisi smooth
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1515037028865-0a2a82603f7c?q=80&w=1000",
              fit: BoxFit.cover,
            ),
          ),

          // 2. Multi-Layer Gradient (Dipertebal di bagian bawah)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.7, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jarak agar teks terkumpul di area bawah layar (viewport)
                    // Menggunakan 0.45 dari tinggi layar agar dinamis
                    SizedBox(height: 0.42.sh),

                    // --- DETAIL 1: Indikator Slide (Simulasi) ---
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        _buildInactiveIndicator(),
                        SizedBox(width: 6.w),
                        _buildInactiveIndicator(),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars_rounded, color: AppColors.primary, size: 14.sp),
                          SizedBox(width: 6.w),
                          Text(
                            "Aplikasi Booking No. 1 di Solo",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Headline
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          const TextSpan(text: "Main Tanpa\nAntri, Booking\n"),
                          TextSpan(
                            text: "Sekarang!",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Sub-headline
                    Text(
                      "Temukan lapangan olahraga terbaik di sekitarmu dengan harga transparan dan jadwal real-time.",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // --- DETAIL 2: Stats Ringkas ---
                    Row(
                      children: [
                        _buildStatItem("50+", "Venues"),
                        _buildVerticalDivider(),
                        _buildStatItem("10k+", "Users"),
                        _buildVerticalDivider(),
                        _buildStatItem("4.9", "Rating"),
                      ],
                    ),

                    SizedBox(height: 40.h),

                    // Main Button
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      ),
                      child: Container(
                        height: 58.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Mulai Sekarang",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Footer
                    Center(
                      child: Text(
                        "ArenaFlow v1.0.0 • © 2026 ArenaFlow Inc.",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 10.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h), // Padding bawah tambahan
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Indikator
  Widget _buildInactiveIndicator() {
    return Container(
      width: 8.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  // Widget Helper untuk Statistik
  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11.sp),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 20.h,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
    );
  }
}
