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

    final allNotifications = provider.notifications;
    final unreadCount = allNotifications.where((item) => item.isUnread).length;
    final notifications = showUnreadOnly
        ? allNotifications.where((item) => item.isUnread).toList()
        : allNotifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context, totalCount: allNotifications.length, unreadCount: unreadCount),
            SizedBox(height: 14.h),
            _buildFilterSection(unreadCount: unreadCount, totalCount: allNotifications.length),
            SizedBox(height: 10.h),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: notifications.isEmpty
                    ? Padding(
                        key: ValueKey('empty-$showUnreadOnly'),
                        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 128.h),
                        child: EmptyStateView(
                          icon: showUnreadOnly
                              ? Icons.mark_email_read_outlined
                              : Icons.notifications_off_outlined,
                          title: showUnreadOnly ? 'Semua sudah dibaca' : 'Tidak ada notifikasi',
                          message: showUnreadOnly
                              ? 'Notifikasi yang belum dibaca akan muncul di sini.'
                              : 'Update booking, promo, dan pengingat jadwal akan muncul di sini.',
                        ),
                      )
                    : ListView.separated(
                        key: ValueKey('list-$showUnreadOnly-${notifications.length}'),
                        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 128.h),
                        physics: const BouncingScrollPhysics(),
                        itemCount: notifications.length,
                        separatorBuilder: (_, _) => SizedBox(height: 14.h),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required int totalCount, required int unreadCount}) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -36.w,
              top: -38.h,
              child: _buildGlowCircle(size: 122.h, color: Colors.white.withValues(alpha: 0.10)),
            ),
            Positioned(
              left: -42.w,
              bottom: -44.h,
              child: _buildGlowCircle(
                size: 118.h,
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
                        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifikasi',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Pantau update booking dan promo terbaru',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (unreadCount > 0)
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        child: InkWell(
                          onTap: () => _markAllAsRead(context),
                          borderRadius: BorderRadius.circular(14.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                            child: Text(
                              'Baca',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatPill(
                        context,
                        label: 'Semua',
                        value: totalCount.toString(),
                        icon: Icons.inbox_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildStatPill(
                        context,
                        label: 'Belum dibaca',
                        value: unreadCount.toString(),
                        icon: Icons.mark_email_unread_rounded,
                        color: AppColors.accentGold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required int unreadCount, required int totalCount}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.32)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.045),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildFilterChip(
                label: 'Semua',
                count: totalCount,
                icon: Icons.notifications_none_rounded,
                isSelected: !showUnreadOnly,
                onTap: () => setState(() => showUnreadOnly = false),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildFilterChip(
                label: 'Belum Dibaca',
                count: unreadCount,
                icon: Icons.mark_email_unread_outlined,
                isSelected: showUnreadOnly,
                onTap: () => setState(() => showUnreadOnly = true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppColors.textMuted, size: 16.sp),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (count > 0) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.18)
                        : AppColors.primaryLight.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, NotificationModel item) {
    _showNotificationDetail(context, item);
  }

  void _markAllAsRead(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Fitur tandai semua dibaca akan aktif saat backend/provider sudah disambungkan.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          margin: EdgeInsets.all(20.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        ),
      );
  }

  void _showNotificationDetail(BuildContext context, NotificationModel item) {
    final palette = _paletteFor(item.type);
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
                    color: palette.background,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: FaIcon(palette.icon, size: 22.sp, color: palette.color),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  item.title,
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
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    item.timeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
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

  Widget _buildGlowCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final _NotificationPalette palette;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.palette, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        splashColor: palette.color.withValues(alpha: 0.08),
        highlightColor: palette.color.withValues(alpha: 0.04),
        child: Ink(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: item.isUnread
                ? AppColors.surfaceLowest
                : AppColors.surfaceLowest.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: item.isUnread
                  ? palette.color.withValues(alpha: 0.14)
                  : AppColors.divider.withValues(alpha: 0.24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: item.isUnread ? 0.065 : 0.035),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconBox(),
              SizedBox(width: 13.w),
              Expanded(child: _buildContent(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: palette.color.withValues(alpha: 0.08)),
          ),
          child: Center(
            child: FaIcon(palette.icon, size: 18.sp, color: palette.color),
          ),
        ),
        if (item.isUnread)
          Positioned(
            right: -2.w,
            top: -2.h,
            child: Container(
              height: 11.h,
              width: 11.h,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surfaceLowest, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _typeLabel(item.type),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.color,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              item.timeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14.5.sp,
            fontWeight: item.isUnread ? FontWeight.w900 : FontWeight.w800,
            color: item.isUnread ? AppColors.textPrimary : AppColors.textSecondary,
            letterSpacing: -0.2,
            height: 1.25,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          item.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            height: 1.45,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary.withValues(alpha: 0.86),
          ),
        ),
      ],
    );
  }

  String _typeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return 'BOOKING';
      case NotificationType.offer:
        return 'PROMO';
      case NotificationType.reminder:
        return 'REMINDER';
    }
  }
}

class _NotificationPalette {
  final FaIconData icon;
  final Color color;
  final Color background;

  const _NotificationPalette({required this.icon, required this.color, required this.background});
}
