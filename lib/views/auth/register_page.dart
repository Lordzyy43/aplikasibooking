import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/providers/auth_provider.dart';
import 'package:apkbooking/views/main_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 64.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Material(
            color: AppColors.surfaceLowest,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Daftar Akun',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          top: false,
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
                          SizedBox(height: 18.h),

                          _buildHeader(textTheme),

                          SizedBox(height: 28.h),

                          _buildLabel('Nama Lengkap'),
                          _buildTextField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            nextFocusNode: _emailFocusNode,
                            hint: 'Contoh: Yogi Eka Saputra',
                            icon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            validator: _validateName,
                          ),

                          SizedBox(height: 18.h),

                          _buildLabel('Alamat Email'),
                          _buildTextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            nextFocusNode: _phoneFocusNode,
                            hint: 'yogi@example.com',
                            icon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            validator: _validateEmail,
                          ),

                          SizedBox(height: 18.h),

                          _buildLabel('Nomor WhatsApp'),
                          _buildTextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            nextFocusNode: _passwordFocusNode,
                            hint: '0812xxxx',
                            icon: Icons.phone_android_rounded,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.telephoneNumber],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(15),
                            ],
                            validator: _validatePhone,
                          ),

                          SizedBox(height: 18.h),

                          _buildLabel('Password'),
                          _buildTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            nextFocusNode: _confirmPasswordFocusNode,
                            hint: 'Buat password kuat',
                            icon: Icons.lock_person_outlined,
                            obscureText: !_isPasswordVisible,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            validator: _validatePassword,
                            onChanged: (_) => setState(() {}),
                            suffix: IconButton(
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

                          SizedBox(height: 10.h),

                          _buildPasswordHint(),

                          SizedBox(height: 18.h),

                          _buildLabel('Konfirmasi Password'),
                          _buildTextField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            hint: 'Ulangi password',
                            icon: Icons.verified_user_outlined,
                            obscureText: !_isConfirmPasswordVisible,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            validator: _validateConfirmPassword,
                            onFieldSubmitted: (_) => _handleRegister(),
                            suffix: IconButton(
                              splashRadius: 22.r,
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 22.sp,
                                color: AppColors.textMuted,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),

                          SizedBox(height: 18.h),

                          _buildInfoCard(),

                          SizedBox(height: 28.h),

                          Consumer<AuthProvider>(
                            builder: (context, auth, child) {
                              return SizedBox(
                                width: double.infinity,
                                height: 56.h,
                                child: ElevatedButton(
                                  onPressed: auth.isLoading ? null : _handleRegister,
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
                                            'BUAT AKUN SEKARANG',
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

                          SizedBox(height: 20.h),

                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () => Navigator.pop(context),
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
                                      const TextSpan(text: 'Sudah punya akun? '),
                                      TextSpan(
                                        text: 'Masuk Disini',
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

                          SizedBox(height: 28.h),
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

  Widget _buildHeader(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58.h,
            width: 58.h,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Image.asset('assets/logos/logo.png', fit: BoxFit.contain),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bergabung Bersama Kami',
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Buat akun untuk mulai booking lapangan favorit dengan lebih mudah.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 12.5.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordHint() {
    final password = _passwordController.text;
    final isEnough = password.length >= 6;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isEnough
            ? AppColors.successContainer
            : AppColors.warningContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isEnough
              ? AppColors.success.withValues(alpha: 0.25)
              : AppColors.warning.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isEnough ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
            size: 18.sp,
            color: isEnough ? AppColors.success : AppColors.warning,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              isEnough
                  ? 'Password sudah memenuhi minimal karakter.'
                  : 'Gunakan minimal 6 karakter untuk password.',
              style: TextStyle(
                color: isEnough ? AppColors.success : AppColors.warning,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.infoContainer,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Data ini digunakan untuk simulasi akun Aerobook. Fitur backend dan penyimpanan akun asli dapat ditambahkan pada versi berikutnya.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    TextInput.finishAutofillContext();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      _showSnackBar(
        icon: Icons.check_circle_outline_rounded,
        message: 'Akun demo berhasil dibuat. Selamat datang!',
        backgroundColor: AppColors.success,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else {
      _showSnackBar(
        icon: Icons.error_outline_rounded,
        message: auth.errorMessage ?? 'Gagal membuat akun.',
        backgroundColor: AppColors.error,
      );
    }
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }

    if (name.length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
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

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Nomor WhatsApp tidak boleh kosong';
    }

    if (phone.length < 10) {
      return 'Nomor WhatsApp terlalu pendek';
    }

    if (phone.length > 15) {
      return 'Nomor WhatsApp terlalu panjang';
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

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (confirmPassword != _passwordController.text) {
      return 'Konfirmasi password belum sama';
    }

    return null;
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

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    FocusNode? nextFocusNode,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    List<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted:
          onFieldSubmitted ??
          (_) {
            if (nextFocusNode != null) {
              nextFocusNode.requestFocus();
            }
          },
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      decoration: _buildInputDecoration(hint: hint, icon: icon, suffix: suffix),
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
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, size: 22.sp, color: AppColors.textMuted),
      suffixIcon: suffix,
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
}
