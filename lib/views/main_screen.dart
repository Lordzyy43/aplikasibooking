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

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted.withOpacity(0.6),
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
              items: [
                _buildNavItem(FontAwesomeIcons.house, 'Home', 0),
                _buildNavItem(FontAwesomeIcons.magnifyingGlass, 'Explore', 1),
                _buildNavItem(FontAwesomeIcons.calendarCheck, 'Bookings', 2),
                _buildNavItem(FontAwesomeIcons.bell, 'Alerts', 3),
                _buildNavItem(FontAwesomeIcons.user, 'Profile', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(dynamic iconData, String label, int index) {
    bool isActive = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: FaIcon(
          iconData, // Menggunakan FaIcon agar support FontAwesomeIcons
          size: 18.sp,
          color: isActive ? AppColors.primary : AppColors.textMuted,
        ),
      ),
      label: label,
    );
  }
}
