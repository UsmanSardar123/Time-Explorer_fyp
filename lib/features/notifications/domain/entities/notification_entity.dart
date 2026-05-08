import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  streakReminder,
  xpReward,
  eraUnlocked,
  dailyMission,
  adminAnnouncement,
}

class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;
  final String? actionRoute;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.actionRoute,
  });

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id,
        title: title,
        message: message,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        type: type,
        actionRoute: actionRoute,
      );

  factory NotificationEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationEntity(
      id: doc.id,
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] as bool? ?? false,
      type: _typeFromString(data['type'] as String? ?? ''),
      actionRoute: data['actionRoute'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'message': message,
        'createdAt': Timestamp.fromDate(createdAt),
        'isRead': isRead,
        'type': _typeToString(type),
        if (actionRoute != null) 'actionRoute': actionRoute,
      };

  static NotificationType _typeFromString(String type) {
    switch (type) {
      case 'streak_reminder':
        return NotificationType.streakReminder;
      case 'xp_reward':
        return NotificationType.xpReward;
      case 'era_unlocked':
        return NotificationType.eraUnlocked;
      case 'daily_mission':
        return NotificationType.dailyMission;
      default:
        return NotificationType.adminAnnouncement;
    }
  }

  static String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.streakReminder:
        return 'streak_reminder';
      case NotificationType.xpReward:
        return 'xp_reward';
      case NotificationType.eraUnlocked:
        return 'era_unlocked';
      case NotificationType.dailyMission:
        return 'daily_mission';
      case NotificationType.adminAnnouncement:
        return 'admin_announcement';
    }
  }
}
