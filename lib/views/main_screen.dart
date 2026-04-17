import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/home/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List halaman dengan placeholder yang konsisten
  final List<Widget> _pages = [
    const HomePage(),
    _buildPlaceholder("Daftar GOR"),
    _buildPlaceholder("Riwayat Booking"),
    _buildPlaceholder("Profil Pengguna"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface, // Warna surface yang bersih
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted, // Menggunakan palet baru
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house, size: 20),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.mapLocationDot, size: 20),
                label: "Gor",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.calendarCheck, size: 20),
                label: "Booking",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user, size: 20),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper placeholder yang elegan
  static Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w500),
      ),
    );
  }
}
