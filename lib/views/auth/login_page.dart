import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/main_screen.dart';
import 'package:apkbooking/views/auth/register_page.dart';
import 'package:apkbooking/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),

              Center(
                child: Column(
                  children: [
                    Container(
                      height: 80.h,
                      width: 80.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.sports_basketball_rounded,
                        color: Colors.white,
                        size: 45.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Aerobook",
                      style: textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              Text(
                "Selamat Datang!",
                style: textTheme.displayMedium?.copyWith(fontSize: 28.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                "Silahkan masuk untuk mulai booking lapangan.",
                style: textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),

              SizedBox(height: 32.h),

              // Form Section
              _buildLabel("Email"),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                decoration: _buildInputDecoration(
                  hint: "Masukkan email kamu",
                  prefixIcon: Icons.alternate_email_rounded,
                ),
              ),

              SizedBox(height: 20.h),

              _buildLabel("Password"),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                decoration: _buildInputDecoration(
                  hint: "Masukkan password",
                  prefixIcon: Icons.lock_person_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 22.sp,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      child: auth.isLoading
                          ? SizedBox(
                              height: 24.h,
                              width: 24.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              "MASUK KE AKUN",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  );
                },
              ),

              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColors.divider, thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Atau masuk dengan",
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.divider, thickness: 1),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              _buildSocialButton(
                label: "Masuk dengan Google",
                icon: Icons.g_mobiledata_rounded,
                onTap: () => _showFeatureSnackBar(
                  "Login Google akan tersedia pada versi backend.",
                ),
              ),

              SizedBox(height: 40.h),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                      children: [
                        const TextSpan(text: "Belum punya akun? "),
                        TextSpan(
                          text: "Daftar Sekarang",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // Handle Login Logic
  Future<void> _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(auth.errorMessage ?? "Email atau Password salah!"),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(20.w),
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Password"),
          content: const Text(
            "Link reset password akan dikirim ke email kamu saat fitur backend tersedia.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Mengerti"),
            ),
          ],
        );
      },
    );
  }

  void _showFeatureSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(20.w),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textMuted,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(prefixIcon, size: 22.sp, color: AppColors.textMuted),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surfaceLowest,
      contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: AppColors.divider, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppColors.divider.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.surfaceLowest,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 28.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
