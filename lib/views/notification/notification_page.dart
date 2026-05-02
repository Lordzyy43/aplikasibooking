import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/models/notification_model.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/widgets/common/empty_state_view.dart';

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

    // Filter notifikasi
    final notifications = showUnreadOnly
        ? provider.notifications.where((item) => item.isUnread).toList()
        : provider.notifications;

    final unreadCount = provider.notifications.where((n) => n.isUnread).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          // Tombol Mark All as Read jika ada yang unread
          if (unreadCount > 0)
            TextButton(
              onPressed: () => _markAllAsRead(context),
              child: Text(
                'Baca Semua',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips dengan Badge Count
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Semua',
                  isSelected: !showUnreadOnly,
                  onTap: () => setState(() => showUnreadOnly = false),
                ),
                SizedBox(width: 10.w),
                _buildFilterChip(
                  label: 'Belum Dibaca',
                  isSelected: showUnreadOnly,
                  count: unreadCount,
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
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final palette = _paletteFor(item.type);

                      return _NotificationCard(
                        item: item,
                        palette: palette,
                        onTap: () => _handleNotificationTap(context, item),
                      );
                    },
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
    int? count,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (count != null && count > 0) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.accent,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, NotificationModel item) {
    // Logic mark as read bisa ditaruh di AppDataProvider
    // context.read<AppDataProvider>().markAsRead(item.id);
  }

  void _markAllAsRead(BuildContext context) {
    // context.read<AppDataProvider>().markAllNotificationsAsRead();
  }

  _NotificationPalette _paletteFor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const _NotificationPalette(
          icon: FontAwesomeIcons.calendarCheck,
          color: AppColors.primary,
          background: Color(0xFFEBF2FF),
        );
      case NotificationType.offer:
        return const _NotificationPalette(
          icon: FontAwesomeIcons.tag,
          color: AppColors.accent,
          background: Color(0xFFFFF6E9),
        );
      case NotificationType.reminder:
        return const _NotificationPalette(
          icon: FontAwesomeIcons.clock,
          color: Color(0xFF6366F1),
          background: Color(0xFFEEF2FF),
        );
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final _NotificationPalette palette;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.palette, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: item.isUnread ? AppColors.surfaceLowest : AppColors.surfaceLowest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: item.isUnread ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: palette.background,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: FaIcon(palette.icon, size: 18.sp, color: palette.color),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.timeLabel,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
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
                    item.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: item.isUnread ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.5,
                      color: AppColors.textSecondary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationPalette {
  final dynamic icon;
  final Color color;
  final Color background;

  const _NotificationPalette({required this.icon, required this.color, required this.background});
}
