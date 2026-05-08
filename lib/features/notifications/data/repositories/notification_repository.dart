import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeexplorer/features/notifications/domain/entities/notification_entity.dart';

class NotificationRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _db.collection('users').doc(userId).collection('notifications');

  Stream<List<NotificationEntity>> watchNotifications(String userId) =>
      _col(userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(NotificationEntity.fromFirestore).toList());

  Future<void> markAsRead(String userId, String notificationId) =>
      _col(userId).doc(notificationId).update({'isRead': true});

  Future<void> markAllAsRead(String userId) async {
    final batch = _db.batch();
    final unread =
        await _col(userId).where('isRead', isEqualTo: false).get();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> addNotification(
      String userId, NotificationEntity notification) =>
      _col(userId).add(notification.toFirestore());

  Future<void> seedTestNotifications(String userId) async {
    final existing = await _col(userId).limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final now = DateTime.now();
    final samples = [
      _build(
        'Keep your streak alive! 🔥',
        "You're on a 3-day streak. Log in today to keep it going!",
        NotificationType.streakReminder,
        now.subtract(const Duration(hours: 1)),
        false,
      ),
      _build(
        'You earned 150 XP! ⭐',
        'Great job completing the Daily Quiz. Keep exploring!',
        NotificationType.xpReward,
        now.subtract(const Duration(hours: 3)),
        false,
      ),
      _build(
        'New Era Unlocked! 🏛️',
        'The Roman Empire era is now available for exploration.',
        NotificationType.eraUnlocked,
        now.subtract(const Duration(hours: 6)),
        false,
        '/event-explorer',
      ),
      _build(
        'Daily Mission Ready! 📜',
        'Your daily history challenge is waiting. Complete it for bonus XP!',
        NotificationType.dailyMission,
        now.subtract(const Duration(days: 1)),
        true,
        '/quiz',
      ),
      _build(
        'Welcome to Time Explorer! 🎉',
        'Start your journey through history. Explore eras, chat with historians, and earn XP!',
        NotificationType.adminAnnouncement,
        now.subtract(const Duration(days: 2)),
        true,
      ),
    ];

    final batch = _db.batch();
    for (final n in samples) {
      batch.set(_col(userId).doc(), n.toFirestore());
    }
    await batch.commit();
  }

  NotificationEntity _build(
    String title,
    String message,
    NotificationType type,
    DateTime createdAt,
    bool isRead, [
    String? actionRoute,
  ]) =>
      NotificationEntity(
        id: '',
        title: title,
        message: message,
        createdAt: createdAt,
        isRead: isRead,
        type: type,
        actionRoute: actionRoute,
      );
}
