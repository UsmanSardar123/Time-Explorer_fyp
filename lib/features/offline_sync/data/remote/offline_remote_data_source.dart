import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/offline_record.dart';

// Writes to NEW sub-collections under users/{uid}/ — does NOT touch
// any existing collections used by the rest of the app.
class OfflineRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  OfflineRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> uploadProgress(OfflineRecord record) =>
      _upload(record, 'offline_progress');

  Future<void> uploadQuizzes(OfflineRecord record) =>
      _upload(record, 'offline_quizzes');

  Future<void> uploadBadges(OfflineRecord record) =>
      _upload(record, 'offline_badges');

  Future<void> uploadStreaks(OfflineRecord record) =>
      _upload(record, 'offline_streaks');

  Future<void> _upload(OfflineRecord record, String subcollection) async {
    final uid = _uid;
    if (uid == null) throw Exception('OfflineSync: no authenticated user');

    final payload = {
      ...(jsonDecode(record.data) as Map<String, dynamic>),
      'syncedAt': FieldValue.serverTimestamp(),
      'clientTimestamp': record.timestamp.millisecondsSinceEpoch,
    };

    await _firestore
        .collection('users')
        .doc(uid)
        .collection(subcollection)
        .doc(record.id.toString())
        .set(payload, SetOptions(merge: true));
  }
}
