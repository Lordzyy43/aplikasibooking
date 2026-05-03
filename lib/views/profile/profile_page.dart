import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppDataProvider>().user;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9), // Warna background lebih 'clean'
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(user.name, user.email, user.avatarUrl),
            SizedBox(height: 55.h),
            _buildStatSection(user.walletBalance, user.points),
            SizedBox(height: 28.h),
            _buildSectionTitle("Aktivitas Saya"),
            _buildQuickActions(),
            SizedBox(height: 28.h),
            _buildSectionTitle("Pengaturan Akun"),
            _buildMenuCard(context),
            SizedBox(height: 40.h),
            _buildLogoutButton(),
            SizedBox(height: 20.h),
            Text(
              'Versi 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String email, String? avatarUrl) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Premium Mesh Gradient Header
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.9),
                const Color(0xFF4A90E2), // Aksen warna biru modern
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Profil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
        // Profile Image with Glow effect
        Positioned(
          bottom: -45.h,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: AppRemoteImage(
                    imageUrl:
                        avatarUrl ?? 'https://ui-avatars.com/api/?name=$name&background=random',
                    width: 100.w,
                    height: 100.w,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                name,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3436),
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatSection(int balance, int points) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE0E5EC).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            "Saldo Anda",
            CurrencyFormatter.idr(balance),
            FontAwesomeIcons.wallet,
            Colors.indigo,
          ),
          Container(width: 1.5, height: 40.h, color: Colors.grey.shade100),
          _buildStatItem(
            "Poin Member",
            points.toString(),
            FontAwesomeIcons.crown,
            Colors.amber.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, dynamic icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: FaIcon(icon, size: 14.sp, color: color),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionButton(Icons.history_rounded, "Riwayat", Colors.orange),
          _actionButton(Icons.favorite_outline_rounded, "Favorit", Colors.pink),
          _actionButton(Icons.confirmation_number_outlined, "Promo", Colors.teal),
          _actionButton(Icons.star_outline_rounded, "Ulasan", Colors.purple),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF636E72),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
      child: Column(
        children: [
          _menuItem(FontAwesomeIcons.userPen, "Informasi Pribadi", Colors.blue),
          _menuDivider(),
          _menuItem(FontAwesomeIcons.shield, "Keamanan Akun", Colors.green),
          _menuDivider(),
          _menuItem(FontAwesomeIcons.circleQuestion, "Pusat Bantuan", Colors.orange),
        ],
      ),
    );
  }

  Widget _menuItem(dynamic icon, String title, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: FaIcon(icon, size: 16.sp, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3436),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.grey.shade400),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: Colors.red.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        label: Text(
          "Keluar dari Aplikasi",
          style: TextStyle(color: Colors.redAccent, fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, bottom: 12.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2D3436),
          ),
        ),
      ),
    );
  }

  Widget _menuDivider() =>
      Divider(height: 1, indent: 70.w, endIndent: 20.w, color: Colors.grey.shade50);
}
