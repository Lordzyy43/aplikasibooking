import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import 'login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image - Pakai foto aksi yang dramatis
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1515037028865-0a2a82603f7c?q=80&w=1000", // Foto court yang lebih epic
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Multi-Layer Gradient agar teks terbaca jelas & mewah
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),

          // 3. Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge kecil untuk kesan pro
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    "🔥 #1 Sports App in Solo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),

                // Headline yang lebih punchy
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      fontFamily: 'Montserrat', // Pastikan font ini ada atau ganti default
                    ),
                    children: [
                      const TextSpan(text: "Elevate Your\n"),
                      TextSpan(
                        text: "Game",
                        style: TextStyle(color: AppColors.primary),
                      ),
                      const TextSpan(text: " Experience"),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                // Sub-headline yang informatif
                Text(
                  "Dapatkan akses instan ke ribuan lapangan favoritmu. Booking tanpa ribet, main tanpa nunggu lama.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 40.h),

                // Main Button dengan Shadow
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Container(
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Mulai Sekarang",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Footer / Version
                Center(
                  child: Text(
                    "Versi 1.0.0",
                    style: TextStyle(color: Colors.white24, fontSize: 10.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
