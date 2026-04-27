// FILE: lib/features/personalities/data/services/rate_limit_service.dart
// PURPOSE: Tracks daily message count per user and enforces soft (55) and hard (60) limits.
// SPRINT: 5

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum RateLimitStatus { ok, warning, blocked }

class RateLimitResult {
  final RateLimitStatus status;
  final int count;
  const RateLimitResult(this.status, this.count);
}

class RateLimitService {
  static const int _softLimit = 55;
  static const int _hardLimit = 60;

  final FirebaseFirestore _firestore;

  RateLimitService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String get _todayKey {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  Future<RateLimitResult> checkAndIncrement(String uid) async {
    if (uid == 'anonymous') return const RateLimitResult(RateLimitStatus.ok, 0);

    final ref = _firestore
        .collection('users')
        .doc(uid)
        .collection('usage')
        .doc(_todayKey);

    try {
      final snap = await ref.get();
      final current = (snap.data()?['messageCount'] as int?) ?? 0;

      if (current >= _hardLimit) {
        return RateLimitResult(RateLimitStatus.blocked, current);
      }

      final newCount = current + 1;
      await ref.set({'messageCount': newCount}, SetOptions(merge: true));

      return RateLimitResult(
        newCount >= _softLimit ? RateLimitStatus.warning : RateLimitStatus.ok,
        newCount,
      );
    } catch (e) {
      debugPrint('[RateLimitService] checkAndIncrement failed (non-fatal): $e');
      return const RateLimitResult(RateLimitStatus.ok, 0);
    }
  }
}
