import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/notification_model.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common/empty_state_view.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();
    final notifications = showUnreadOnly
        ? provider.notifications.where((item) => item.isUnread).toList()
        : provider.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Semua',
                  isSelected: !showUnreadOnly,
                  onTap: () => setState(() => showUnreadOnly = false),
                ),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  label: 'Belum Dibaca',
                  isSelected: showUnreadOnly,
                  onTap: () => setState(() => showUnreadOnly = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? const EmptyStateView(
                    icon: Icons.notifications_off_outlined,
                    title: 'Tidak ada notifikasi',
                    message: 'Semua update terbaru tentang booking dan promo akan muncul di sini.',
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 120.h),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final palette = _paletteFor(item.type);
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLowest,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: palette.background,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Center(
                                child: FaIcon(palette.icon, size: 16.sp, color: palette.color),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (item.isUnread)
                                        Container(
                                          width: 8.w,
                                          height: 8.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.accent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      height: 1.45,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              item.timeLabel,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemCount: notifications.length,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  _NotificationPalette _paletteFor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const _NotificationPalette(
          icon: FontAwesomeIcons.calendarCheck,
          color: AppColors.primary,
          background: AppColors.primaryLight,
        );
      case NotificationType.offer:
        return const _NotificationPalette(
          icon: FontAwesomeIcons.percent,
          color: AppColors.accent,
          background: AppColors.warningContainer,
        );
      case NotificationType.reminder:
        return const _NotificationPalette(
          icon: FontAwesomeIcons.bellConcierge,
          color: AppColors.secondary,
          background: AppColors.surfaceHigh,
        );
    }
  }
}

class _NotificationPalette {
  const _NotificationPalette({
    required this.icon,
    required this.color,
    required this.background,
  });

  final FaIconData icon;
  final Color color;
  final Color background;
}
