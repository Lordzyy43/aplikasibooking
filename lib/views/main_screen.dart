import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/history/mybooking_page.dart';
import 'package:apkbooking/views/home/home_page.dart';
import 'package:apkbooking/views/notification/notification_page.dart';
import 'package:apkbooking/views/profile/profile_page.dart';
import 'package:apkbooking/views/venue/venue_list_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    VenueListPage(),
    MyBookingPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  final List<_BottomNavItem> _navItems = const [
    _BottomNavItem(icon: FontAwesomeIcons.house, label: 'Home'),
    _BottomNavItem(icon: FontAwesomeIcons.magnifyingGlass, label: 'Explore'),
    _BottomNavItem(icon: FontAwesomeIcons.calendarCheck, label: 'Bookings'),
    _BottomNavItem(icon: FontAwesomeIcons.bell, label: 'Alerts'),
    _BottomNavItem(icon: FontAwesomeIcons.user, label: 'Profile'),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // Membuat bottom nav terasa floating di atas body.
      extendBody: true,

      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 10.h),
        child: Container(
          height: 82.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest.withValues(alpha: 0.98),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.45)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = _selectedIndex == index;

              return Expanded(
                child: _NavButton(
                  icon: item.icon,
                  label: item.label,
                  isActive: isActive,
                  onTap: () => _onItemTapped(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final FaIconData icon;
  final String label;

  const _BottomNavItem({required this.icon, required this.label});
}

class _NavButton extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                height: 28.h,
                width: isActive ? 42.w : 34.w,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    size: 15.sp,
                    color: isActive ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                    color: isActive ? AppColors.primary : AppColors.textMuted,
                    letterSpacing: isActive ? 0.1 : 0,
                    height: 1.0,
                  ),
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
