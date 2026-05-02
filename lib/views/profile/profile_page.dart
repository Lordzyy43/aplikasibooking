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
      appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildProfileHeader(user.name, user.email, user.avatarUrl),
            SizedBox(height: 25.h),
            _buildStatCards(user.walletBalance, user.points),
            SizedBox(height: 25.h),
            _buildQuickActions(),
            SizedBox(height: 20.h),
            _buildMenuSection(context),
            SizedBox(height: 24.h),
            Text(
              'Versi 1.0.0',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email, String? avatarUrl) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: AppRemoteImage(
                imageUrl: avatarUrl ?? 'https://ui-avatars.com/api/?name=User',
                width: 100.w,
                height: 100.w,
              ),
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
          name,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        Text(
          email,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildStatCards(int walletBalance, int points) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSingleStat('Saldo', CurrencyFormatter.idr(walletBalance), FontAwesomeIcons.wallet),
            Container(width: 1, height: 40, color: AppColors.divider),
            _buildSingleStat('Poin', '$points', FontAwesomeIcons.medal),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(child: _buildQuickActionCard(Icons.receipt_long_rounded, 'Transaksi')),
          SizedBox(width: 12.w),
          Expanded(child: _buildQuickActionCard(Icons.favorite_border_rounded, 'Favorit')),
          SizedBox(width: 12.w),
          Expanded(child: _buildQuickActionCard(Icons.support_agent_rounded, 'Bantuan')),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

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
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          child: Column(
            children: [
              _buildMenuItem(FontAwesomeIcons.user, 'Edit Profil', () {}),
              _buildMenuItem(FontAwesomeIcons.shieldHalved, 'Keamanan Akun', () {}),
              _buildMenuItem(FontAwesomeIcons.circleQuestion, 'Pusat Bantuan', () {}),
              _buildMenuItem(FontAwesomeIcons.rightFromBracket, 'Keluar', () {}, isDanger: true),
            ],
          ),
        ),
      ),
    );
  }

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
          color: isDanger ? AppColors.error.withValues(alpha: 0.1) : AppColors.background,
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
