import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/core/utils/currency_formatter.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/auth_provider.dart';
import 'package:apkbooking/views/auth/onboarding_page.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (user == null) {
      return _buildLoginRequired(context);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 128.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHero(
                context,
                name: user.name,
                email: user.email,
                avatarUrl: user.avatarUrl,
                balance: user.walletBalance,
                points: user.points,
              ),
              SizedBox(height: 22.h),
              _buildSectionHeader(context, 'Aktivitas Saya'),
              SizedBox(height: 12.h),
              _buildQuickActions(context),
              SizedBox(height: 22.h),
              _buildSectionHeader(context, 'Pengaturan Akun'),
              SizedBox(height: 12.h),
              _buildMenuCard(context),
              SizedBox(height: 22.h),
              _buildLogoutButton(context),
              SizedBox(height: 18.h),
              Center(
                child: Text(
                  'Aerobook • Versi 1.0.0',
                  style: TextStyle(
                    color: AppColors.textMuted.withValues(alpha: 0.65),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRequired(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: AppColors.divider.withValues(alpha: 0.28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.055),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 64.w,
                    width: 64.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primary,
                      size: 30.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Masuk untuk melihat profil',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      fontSize: 19.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Profil, booking, dan notifikasi akan tersinkron setelah login.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OnboardingPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('Masuk Sekarang'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHero(
    BuildContext context, {
    required String name,
    required String email,
    required String? avatarUrl,
    required int balance,
    required int points,
  }) {
    final theme = Theme.of(context);
    final safeAvatar = avatarUrl == null || avatarUrl.trim().isEmpty
        ? 'assets/Avatar/Avatar.png'
        : avatarUrl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -42.w,
            top: -42.h,
            child: _buildGlowCircle(
              size: 132.h,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            left: -44.w,
            bottom: -46.h,
            child: _buildGlowCircle(
              size: 124.h,
              color: AppColors.accentGold.withValues(alpha: 0.16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 46.h,
                    width: 46.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Profil Saya',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: AppColors.accentGold,
                          size: 14.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'Customer',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: AppRemoteImage(
                        imageUrl: safeAvatar,
                        width: 82.w,
                        height: 82.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.trim().isEmpty ? 'User Aerobook' : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          email.trim().isEmpty ? 'user@example.com' : email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Text(
                            'Member Aerobook',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatPill(
                      context,
                      label: 'Saldo',
                      value: CurrencyFormatter.idr(balance),
                      icon: FontAwesomeIcons.wallet,
                      color: AppColors.accentGold,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildStatPill(
                      context,
                      label: 'Poin',
                      value: points.toString(),
                      icon: FontAwesomeIcons.crown,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required String label,
    required String value,
    required FaIconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 17.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: 22.h,
          width: 5.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        SizedBox(width: 9.w),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.055),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              context,
              icon: Icons.history_rounded,
              label: 'Riwayat',
              color: AppColors.warning,
              onTap: () => _showInfoSheet(
                context,
                icon: Icons.history_rounded,
                color: AppColors.warning,
                title: 'Riwayat Aktivitas',
                message:
                    'Riwayat booking lengkap bisa dibuka dari tab Bookings.',
              ),
            ),
          ),
          Expanded(
            child: _actionButton(
              context,
              icon: Icons.favorite_outline_rounded,
              label: 'Favorit',
              color: AppColors.accentRose,
              onTap: () => _showSnackBar(
                context,
                'Venue favorit berhasil disinkronkan untuk demo.',
              ),
            ),
          ),
          Expanded(
            child: _actionButton(
              context,
              icon: Icons.confirmation_number_outlined,
              label: 'Promo',
              color: AppColors.accentTeal,
              onTap: () => _showInfoSheet(
                context,
                icon: Icons.confirmation_number_outlined,
                color: AppColors.accentTeal,
                title: 'Promo Tersedia',
                message: 'Gunakan kode ARENA30 untuk simulasi promo 30%.',
              ),
            ),
          ),
          Expanded(
            child: _actionButton(
              context,
              icon: Icons.star_outline_rounded,
              label: 'Ulasan',
              color: const Color(0xFF8B5CF6),
              onTap: () =>
                  _showSnackBar(context, 'Kamu belum memiliki ulasan aktif.'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Column(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17.r),
                  border: Border.all(color: color.withValues(alpha: 0.12)),
                ),
                child: Icon(icon, color: color, size: 23.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.055),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileMenuTile(
            icon: FontAwesomeIcons.userPen,
            title: 'Informasi Pribadi',
            subtitle: 'Nama, email, dan data akun demo',
            color: AppColors.primary,
            onTap: () => _showEditProfileSheet(context),
          ),
          _menuDivider(),
          _ProfileMenuTile(
            icon: FontAwesomeIcons.shield,
            title: 'Keamanan Akun',
            subtitle: 'PIN dan verifikasi akun',
            color: AppColors.success,
            onTap: () => _showInfoSheet(
              context,
              icon: Icons.shield_outlined,
              color: AppColors.success,
              title: 'Keamanan Akun',
              message:
                  'Email dan sesi login sudah tersambung ke Supabase Auth.',
            ),
          ),
          _menuDivider(),
          _ProfileMenuTile(
            icon: FontAwesomeIcons.circleQuestion,
            title: 'Pusat Bantuan',
            subtitle: 'Bantuan booking dan pembayaran',
            color: AppColors.warning,
            onTap: () => _showInfoSheet(
              context,
              icon: Icons.support_agent_rounded,
              color: AppColors.warning,
              title: 'Pusat Bantuan',
              message:
                  'Hubungi admin venue jika perlu bantuan booking atau pembayaran.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuDivider() {
    return Divider(
      height: 1,
      indent: 72.w,
      endIndent: 18.w,
      color: AppColors.divider.withValues(alpha: 0.25),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: () => _confirmLogout(context),
        borderRadius: BorderRadius.circular(20.r),
        splashColor: AppColors.error.withValues(alpha: 0.08),
        highlightColor: AppColors.error.withValues(alpha: 0.04),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: AppColors.error, size: 19.sp),
              SizedBox(width: 8.w),
              Text(
                'Keluar dari Aplikasi',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          margin: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );
  }

  void _showInfoSheet(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
                SizedBox(height: 22.h),
                Container(
                  height: 58.h,
                  width: 58.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(icon, color: color, size: 27.sp),
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) return;

    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4.h,
                        width: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Text(
                      'Edit Profil',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama lengkap',
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Nomor HP'),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final isValid =
                              formKey.currentState?.validate() ?? false;
                          if (!isValid) return;

                          final success = await auth.updateProfile(
                            name: nameController.text.trim(),
                            email: user.email,
                            phone: phoneController.text.trim(),
                          );

                          if (!context.mounted) return;
                          Navigator.pop(sheetContext);
                          _showSnackBar(
                            context,
                            success
                                ? 'Profil berhasil diperbarui.'
                                : auth.errorMessage ??
                                      'Profil belum bisa diperbarui.',
                          );
                        },
                        child: const Text('Simpan Profil'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      phoneController.dispose();
    });
  }

  void _confirmLogout(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
                SizedBox(height: 22.h),
                Container(
                  height: 58.h,
                  width: 58.h,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 27.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Keluar dari akun?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Kamu akan kembali ke halaman awal aplikasi.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Batal'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          shadowColor: AppColors.error.withValues(alpha: 0.28),
                        ),
                        onPressed: () async {
                          Navigator.pop(sheetContext);

                          await context.read<AuthProvider>().logout();
                          if (!context.mounted) return;
                          context.read<AppDataProvider>().clearSessionData();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OnboardingPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Keluar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final FaIconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          child: Row(
            children: [
              Container(
                height: 44.h,
                width: 44.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: color.withValues(alpha: 0.10)),
                ),
                child: Center(
                  child: FaIcon(icon, color: color, size: 16.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13.sp,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
