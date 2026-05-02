import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house, size: 18),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18),
                label: 'EXPLORE',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.calendarCheck, size: 18),
                label: 'BOOKINGS',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bell, size: 18),
                label: 'ALERTS',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user, size: 18),
                label: 'PROFILE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
