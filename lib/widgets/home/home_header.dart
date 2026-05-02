import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/notification/notification_page.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? profileImageUrl; // Tambahan untuk kesan lebih profesional

  const HomeHeader({super.key, required this.userName, this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        children: [
          // 1. Profile Avatar (Meningkatkan User Experience)
          _buildProfileAvatar(),

          SizedBox(width: 12.w),

          // 2. Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getGreetingMessage(),
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp, letterSpacing: 0.5),
                ),
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18.sp, // Ukuran lebih proporsional
                    fontWeight: FontWeight.w900, // Lebih bold untuk nama
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // 3. Action Buttons
          _buildNotificationButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
      ),
      child: CircleAvatar(
        radius: 22.r,
        backgroundColor: AppColors.surfaceLowest,
        backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
        child: profileImageUrl == null
            ? Icon(Icons.person_rounded, color: AppColors.primary, size: 24.sp)
            : null,
      ),
    );
  }

  // Dinamis greeting membuat app terasa lebih "hidup"
  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r), // Kotak melengkung lebih modern
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage())),
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.surfaceLow, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.bell, // Gunakan regular bell untuk kesan clean
                size: 20.sp,
                color: AppColors.textPrimary,
              ),
              Positioned(
                right: 12.w,
                top: 12.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
