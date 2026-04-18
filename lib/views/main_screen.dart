import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/home/home_page.dart';
import 'package:apkbooking/views/profile/profile_page.dart';
import 'package:apkbooking/views/gor/gor_list_page.dart'; // Import halaman list GOR baru

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Evolusi: BookingPage dihapus dari sini karena dipanggil via Navigator dari Detail GOR
  final List<Widget> _pages = [
    const HomePage(),
    const GorListPage(), // Tab 2: Sekarang berisi daftar eksplorasi GOR
    _buildPlaceholder("Riwayat Booking"), // Tab 3: Riwayat transaksi user
    const ProfilePage(), // Tab 4: Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Menggunakan IndexedStack agar state halaman tidak hilang saat pindah tab
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
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
            unselectedItemColor: AppColors.textMuted,
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
                label: "Eksplor", // Ganti label agar lebih intuitif
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: 20,
                ), // Icon riwayat lebih cocok
                label: "Riwayat",
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

  static Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.boxOpen, size: 50, color: AppColors.textMuted.withOpacity(0.3)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
