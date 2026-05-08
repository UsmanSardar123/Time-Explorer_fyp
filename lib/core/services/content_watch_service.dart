import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

class ContentWatchService {
  static final ContentWatchService instance = ContentWatchService._();
  ContentWatchService._();

  StreamSubscription<QuerySnapshot>? _eventsSubscription;
  StreamSubscription<QuerySnapshot>? _erasSubscription;

  void startWatching() {
    if (_eventsSubscription != null) return;
    _eventsSubscription = _watchNew('events', (doc) async {
      final data = doc.data() as Map<String, dynamic>?;
      final title = (data?['title'] as String?) ?? 'New Historical Event';
      final era = data?['era'] as String?;
      await NotificationService.showNewContent(title, eraName: era);
    });
    _erasSubscription = _watchNew('eras', (doc) async {
      final data = doc.data() as Map<String, dynamic>?;
      final name = (data?['name'] as String?) ?? 'New Era';
      await NotificationService.showNewContent('$name Era');
    });
    debugPrint('[CONTENT_WATCH] Watching events and eras for new content');
  }

  StreamSubscription<QuerySnapshot> _watchNew(
    String collection,
    Future<void> Function(DocumentSnapshot) onAdded,
  ) {
    bool isFirstSnapshot = true;
    return FirebaseFirestore.instance.collection(collection).snapshots().listen(
      (snapshot) {
        if (isFirstSnapshot) {
          isFirstSnapshot = false;
          return;
        }
        for (final change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            onAdded(change.doc).catchError(
              (e) => debugPrint('[CONTENT_WATCH] Error for $collection: $e'),
            );
          }
        }
      },
      onError: (e) =>
          debugPrint('[CONTENT_WATCH] Stream error for $collection: $e'),
    );
  }

  void stopWatching() {
    _eventsSubscription?.cancel();
    _erasSubscription?.cancel();
    _eventsSubscription = null;
    _erasSubscription = null;
  }
}
