enum NotificationType { booking, offer, reminder, payment }

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

  NotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? timeLabel,
    NotificationType? type,
    bool? isUnread,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timeLabel: timeLabel ?? this.timeLabel,
      type: type ?? this.type,
      isUnread: isUnread ?? this.isUnread,
    );
  }

  factory NotificationModel.fromSupabase(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notifikasi',
      subtitle: json['body']?.toString() ?? '',
      timeLabel: _relativeTimeLabel(json['created_at']?.toString()),
      type: _notificationType(json['type']?.toString()),
      isUnread: json['is_read'] != true,
    );
  }
}

NotificationType _notificationType(String? value) {
  return switch (value) {
    'offer' => NotificationType.offer,
    'reminder' => NotificationType.reminder,
    'payment' => NotificationType.payment,
    _ => NotificationType.booking,
  };
}

String _relativeTimeLabel(String? value) {
  final createdAt = DateTime.tryParse(value ?? '')?.toLocal();
  if (createdAt == null) return 'Baru saja';

  final difference = DateTime.now().difference(createdAt);
  if (difference.inMinutes < 1) return 'Baru saja';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays}d ago';
  return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}';
}
