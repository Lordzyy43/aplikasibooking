import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import 'home/home_page.dart';
import 'venue/venue_list_page.dart';
// import 'notification/notification_page.dart';
import 'profile/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 5 Halaman sesuai urutan navigasi di mockup
  final List<Widget> _pages = [
    const HomePage(), // Index 0
    const VenueListPage(), // Index 1 (EXPLORE)
    _buildPlaceholder("My Bookings"), // Index 2 (BOOKINGS)
    _buildPlaceholder("Alerts"), // Index 3 (ALERTS)
    const ProfilePage(), // Index 4 (PROFILE)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
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
            type: BottomNavigationBarType.fixed, // Wajib fixed kalau 5 menu
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house, size: 18),
                label: "HOME",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18),
                label: "EXPLORE",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.calendarCheck, size: 18),
                label: "BOOKINGS",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bell, size: 18),
                label: "ALERTS",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user, size: 18),
                label: "PROFILE",
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold),
      ),
    );
  }
}
