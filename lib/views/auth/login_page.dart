import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/providers/auth_provider.dart';
import 'package:apkbooking/views/auth/register_page.dart';
import 'package:apkbooking/views/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 34.h),

                          Center(
                            child: Column(
                              children: [
                                _buildLogoCard(),
                                SizedBox(height: 18.h),
                                Text(
                                  'Aerobook',
                                  style: textTheme.headlineLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Booking lapangan jadi lebih mudah',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 36.h),

                          Text(
                            'Selamat Datang!',
                            style: textTheme.displayMedium?.copyWith(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Masuk untuk mulai mencari, memilih, dan booking lapangan favoritmu.',
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              height: 1.45,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          SizedBox(height: 28.h),

                          _buildLabel('Email'),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            decoration: _buildInputDecoration(
                              hint: 'Masukkan email kamu',
                              prefixIcon: Icons.alternate_email_rounded,
                            ),
                            validator: _validateEmail,
                            onFieldSubmitted: (_) {
                              _passwordFocusNode.requestFocus();
                            },
                          ),

                          SizedBox(height: 18.h),

                          _buildLabel('Password'),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: !_isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            decoration: _buildInputDecoration(
                              hint: 'Masukkan password',
                              prefixIcon: Icons.lock_person_outlined,
                              suffixIcon: IconButton(
                                splashRadius: 22.r,
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  size: 22.sp,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: _validatePassword,
                            onFieldSubmitted: (_) => _handleLogin(),
                          ),

                          SizedBox(height: 6.h),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _showForgotPasswordDialog,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Lupa Password?',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.sp),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

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
                                    disabledBackgroundColor: AppColors.primary.withValues(
                                      alpha: 0.55,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    elevation: auth.isLoading ? 0 : 10,
                                    shadowColor: AppColors.primary.withValues(alpha: 0.28),
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    child: auth.isLoading
                                        ? SizedBox(
                                            key: const ValueKey('loading'),
                                            height: 24.h,
                                            width: 24.h,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Text(
                                            key: const ValueKey('text'),
                                            'MASUK KE AKUN',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 26.h),

                          _buildDivider(),

                          SizedBox(height: 22.h),

                          _buildSocialButton(
                            label: 'Masuk dengan Google',
                            icon: Icons.g_mobiledata_rounded,
                            onTap: () => _showFeatureSnackBar(
                              'Login Google akan tersedia pada versi backend.',
                            ),
                          ),

                          const Spacer(),

                          SizedBox(height: 28.h),

                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Belum punya akun? '),
                                      TextSpan(
                                        text: 'Daftar Sekarang',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoCard() {
    return Container(
      height: 86.h,
      width: 86.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Container(
          height: 68.h,
          width: 68.h,
          padding: EdgeInsets.all(9.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.divider.withValues(alpha: 0.8), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Text(
            'Atau masuk dengan',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.divider.withValues(alpha: 0.8), thickness: 1)),
      ],
    );
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    TextInput.finishAutofillContext();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final success = await auth.login(_emailController.text.trim(), _passwordController.text);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      _showErrorSnackBar(auth.errorMessage ?? 'Gagal masuk ke akun.');
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final isValidEmail = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);

    if (!isValidEmail) {
      return 'Format email belum valid';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  void _showForgotPasswordDialog() {
    FocusScope.of(context).unfocus();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceLowest,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
          title: Text(
            'Reset Password',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            'Link reset password akan dikirim ke email kamu saat fitur backend tersedia.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp, height: 1.45),
          ),
          actionsPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Mengerti'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFeatureSnackBar(String message) {
    _showSnackBar(
      icon: Icons.info_outline_rounded,
      message: message,
      backgroundColor: AppColors.primary,
    );
  }

  void _showErrorSnackBar(String message) {
    _showSnackBar(
      icon: Icons.error_outline_rounded,
      message: message,
      backgroundColor: AppColors.error,
    );
  }

  void _showSnackBar({
    required IconData icon,
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
      );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w800,
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
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(prefixIcon, size: 22.sp, color: AppColors.textMuted),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surfaceLowest,
      contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.65), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.65), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surfaceLowest,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 30.sp),
              SizedBox(width: 10.w),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
