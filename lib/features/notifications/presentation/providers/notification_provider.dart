import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timeexplorer/features/notifications/data/repositories/notification_repository.dart';
import 'package:timeexplorer/features/notifications/domain/entities/notification_entity.dart';

class NotificationProvider extends ChangeNotifier {
  final _repo = NotificationRepository();

  List<NotificationEntity> _notifications = [];
  StreamSubscription<List<NotificationEntity>>? _sub;
  bool _isLoading = false;
  String? _userId;

  List<NotificationEntity> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> init(String userId) async {
    if (_userId == userId) return;
    _userId = userId;
    _isLoading = true;
    notifyListeners();

    await _repo.seedTestNotifications(userId);

    _sub?.cancel();
    _sub = _repo.watchNotifications(userId).listen((list) {
      _notifications = list;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> markAsRead(String notificationId) async {
    if (_userId == null) return;
    await _repo.markAsRead(_userId!, notificationId);
  }

  Future<void> markAllAsRead() async {
    if (_userId == null) return;
    await _repo.markAllAsRead(_userId!);
  }

  Future<void> addNotification(NotificationEntity notification) async {
    if (_userId == null) return;
    await _repo.addNotification(_userId!, notification);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
