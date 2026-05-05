import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/core/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.divider.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Daftar Akun",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Bergabung Bersama Kami",
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 26.sp,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Mulai langkahmu untuk booking lapangan favorit dengan lebih mudah dan cepat.",
                style: textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),

              SizedBox(height: 32.h),

              // Form Fields
              _buildLabel("Nama Lengkap"),
              _buildTextField(
                controller: _nameController,
                hint: "Contoh: Yogi Eka Saputra",
                icon: Icons.person_outline_rounded,
              ),

              SizedBox(height: 20.h),

              _buildLabel("Alamat Email"),
              _buildTextField(
                controller: _emailController,
                hint: "yogi@example.com",
                icon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 20.h),

              _buildLabel("Nomor WhatsApp"),
              _buildTextField(
                controller: _phoneController,
                hint: "0812xxxx",
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20.h),

              _buildLabel("Password"),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                decoration: _buildInputDecoration(
                  hint: "Buat password kuat",
                  icon: Icons.lock_person_outlined,
                  suffix: IconButton(
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

              SizedBox(height: 40.h),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    _handleRegister();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "BUAT AKUN SEKARANG",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Login Link
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                      children: [
                        const TextSpan(text: "Sudah punya akun? "),
                        TextSpan(
                          text: "Masuk Disini",
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
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      _showSnackBar(
        "Lengkapi semua data pendaftaran terlebih dahulu.",
        isError: true,
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar("Masukkan alamat email yang valid.", isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackBar("Password minimal 6 karakter.", isError: true);
      return;
    }

    _showSnackBar("Akun demo berhasil dibuat. Silakan masuk.");
    Navigator.pop(context);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error : AppColors.primary,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
      decoration: _buildInputDecoration(hint: hint, icon: icon),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textMuted,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(icon, size: 22.sp, color: AppColors.textMuted),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surfaceLowest,
      contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppColors.divider.withValues(alpha: 0.5),
          width: 1,
        ),
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
    );
  }
}
