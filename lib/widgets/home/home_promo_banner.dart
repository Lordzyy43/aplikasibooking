import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/venue/venue_list_page.dart';

class HomePromoBanner extends StatefulWidget {
  final VoidCallback? onTap;

  const HomePromoBanner({super.key, this.onTap});

  @override
  State<HomePromoBanner> createState() => _HomePromoBannerState();
}

class _HomePromoBannerState extends State<HomePromoBanner> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;
  Timer? _timer;

  // Data promo dummy (Bisa Sensei pindahkan ke Model nantinya)
  final List<Map<String, dynamic>> _promos = [
    {
      "title": "Diskon Member Baru!",
      "subtitle": "Potongan harga hingga 50% untuk booking pertama kamu.",
      "tag": "LIMITED TIME",
      "color": AppColors.primary,
      "icon": Icons.local_fire_department_rounded,
    },
    {
      "title": "Main Bareng Teman",
      "subtitle": "Dapatkan cashback 20rb untuk booking grup minimal 10 orang.",
      "tag": "GROUP DEAL",
      "color": const Color(0xFF1E3A8A),
      "icon": Icons.groups_rounded,
    },
    {
      "title": "Weekend Seru",
      "subtitle": "Bonus air mineral & sewa sepatu gratis setiap Sabtu & Minggu.",
      "tag": "WEEKEND SPECIAL",
      "color": const Color(0xFF0F172A),
      "icon": Icons.celebration_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _promos.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170.h, // Tinggi dikunci agar tidak memakan tempat berlebih
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _promos.length,
            itemBuilder: (context, index) {
              final promo = _promos[index];
              return _buildPromoCard(context, promo);
            },
          ),
        ),
        SizedBox(height: 12.h),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildPromoCard(BuildContext context, Map<String, dynamic> promo) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [promo['color'], promo['color'].withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: promo['color'].withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                widget.onTap ??
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VenueListPage()),
                ),
            child: Stack(
              children: [
                // Ornamen Latar Belakang (Ikon Besar)
                Positioned(
                  right: -10.w,
                  bottom: -15.h,
                  child: Icon(promo['icon'], size: 140.sp, color: Colors.white.withOpacity(0.1)),
                ),

                // Konten Teks
                Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Tag
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Text(
                          promo['tag'],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        promo['title'],
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 220.w,
                        child: Text(
                          promo['subtitle'],
                          maxLines: 2,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // CTA Button (Mini version)
                Positioned(
                  right: 18.w,
                  top: 18.h,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.arrow_forward_rounded, color: promo['color'], size: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promos.length, (index) {
        bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          height: 6.h,
          width: isActive ? 18.w : 6.w,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
        );
      }),
    );
  }
}
