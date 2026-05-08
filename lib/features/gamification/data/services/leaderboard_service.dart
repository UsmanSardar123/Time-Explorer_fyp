import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/leaderboard_user.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore;

  LeaderboardService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<LeaderboardUser>> getLeaderboardData() async {
    try {
      debugPrint('[LEADERBOARD] Fetching leaderboard data...');
      final snapshot = await _firestore
          .collection('users')
          .orderBy('xp', descending: true)
          .limit(100) 
          .get();

      debugPrint('[LEADERBOARD] Docs found (orderBy): ${snapshot.docs.length}');
      
      if (snapshot.docs.isEmpty) {
        debugPrint('[LEADERBOARD] No users found with orderBy("xp"). Attempting raw fetch...');
        final rawSnapshot = await _firestore.collection('users').limit(100).get();
        debugPrint('[LEADERBOARD] Raw docs found: ${rawSnapshot.docs.length}');
        final users = _mapSnapshot(rawSnapshot.docs);
        users.sort((a, b) => b.xp.compareTo(a.xp));
        return users;
      }

      return _mapSnapshot(snapshot.docs);
    } catch (e) {
      debugPrint('[LEADERBOARD] Error fetching leaderboard data: $e');
      return [];
    }
  }

  Stream<List<LeaderboardUser>> getLeaderboardStream() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) {
      debugPrint('[LEADERBOARD] Stream update: ${snapshot.docs.length} docs');
      final users = _mapSnapshot(snapshot.docs);
      users.sort((a, b) => b.xp.compareTo(a.xp));
      return users.take(100).toList();
    });
  }

  List<LeaderboardUser> _mapSnapshot(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.map((doc) {
      final data = doc.data();
      final gamification = data['gamification'] as Map<String, dynamic>?;

      final xp = data['xp'] ?? gamification?['xp'] ?? 0;
      final level = data['level'] ?? gamification?['level'] ?? 1;

      // Resolve the best available display name
      final rawName = data['displayName']
          ?? data['name']
          ?? data['username'];
      final email = data['email'] as String?;
      final name = _resolveName(rawName, email, doc.id);

      final photoUrl = data['photoUrl'] as String?;

      final createdAtRaw = data['createdAt'];
      DateTime? createdAt;
      if (createdAtRaw is Timestamp) {
        createdAt = createdAtRaw.toDate();
      }

      final exploredPlaces = gamification?['exploredPlaceIds'] as List<dynamic>?;
      final exploredCount = exploredPlaces?.length ?? 0;

      return LeaderboardUser(
        id: doc.id,
        name: name,
        xp: xp is int ? xp : int.tryParse(xp.toString()) ?? 0,
        level: level is int ? level : int.tryParse(level.toString()) ?? 1,
        photoUrl: photoUrl,
        createdAt: createdAt,
        placesExploredCount: exploredCount,
      );
    }).toList();
  }

  String _resolveName(dynamic rawName, String? email, String docId) {
    if (rawName is String && rawName.trim().isNotEmpty) {
      return rawName.trim();
    }
    if (email != null && email.contains('@')) {
      final prefix = email.split('@').first;
      if (prefix.isNotEmpty) return _formatEmailPrefix(prefix);
    }
    // Last resort: shorten the doc ID to an Explorer alias
    return 'Explorer ${docId.substring(0, 6).toUpperCase()}';
  }

  String _formatEmailPrefix(String prefix) {
    // Convert "john.doe" or "john_doe" → "John Doe"
    final parts = prefix.split(RegExp(r'[._\-]'));
    return parts
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }
}
