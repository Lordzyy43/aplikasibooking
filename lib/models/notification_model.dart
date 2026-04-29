enum NotificationType {
  booking,
  offer,
  reminder,
}

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.type,
    this.isUnread = true,
  });

  final String id;
  final String title;
  final String subtitle;
  final String timeLabel;
  final NotificationType type;
  final bool isUnread;
}
