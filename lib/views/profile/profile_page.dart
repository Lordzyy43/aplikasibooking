import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildProfileHeader(),
            SizedBox(height: 25.h),
            _buildStatCards(),
            SizedBox(height: 25.h),
            _buildMenuSection(context),
            SizedBox(height: 30.h),
            Text(
              "Versi 1.0.0",
              style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: const NetworkImage("https://picsum.photos/200"),
            ),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.edit, color: Colors.white, size: 16.sp),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Text(
          "lorem ipsum",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        Text(
          "lorem.ipsum@example.com",
          style: TextStyle(fontSize: 14.sp, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSingleStat("Saldo", "Rp 0", FontAwesomeIcons.wallet),
            Container(width: 1, height: 40, color: AppColors.divider),
            _buildSingleStat("Poin", "0", FontAwesomeIcons.medal),
          ],
        ),
      ),
    );
  }

  // ✅ FIX: pakai FaIconData
  Widget _buildSingleStat(String label, String value, FaIconData icon) {
    return Column(
      children: [
        Row(
          children: [
            FaIcon(icon, size: 14.sp, color: AppColors.secondary),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textLight),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildMenuItem(FontAwesomeIcons.userLarge, "Edit Profil", () {}),
          _buildMenuItem(FontAwesomeIcons.shieldHalved, "Keamanan Akun", () {}),
          _buildMenuItem(FontAwesomeIcons.circleQuestion, "Pusat Bantuan", () {}),
          _buildMenuItem(FontAwesomeIcons.rightFromBracket, "Keluar", () {}, isDanger: true),
        ],
      ),
    );
  }

  // ✅ FIX: pakai FaIconData
  Widget _buildMenuItem(
    FaIconData icon,
    String title,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDanger ? AppColors.error.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: FaIcon(icon, size: 18.sp, color: isDanger ? AppColors.error : AppColors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isDanger ? AppColors.error : AppColors.textDark,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20.sp),
    );
  }
}
