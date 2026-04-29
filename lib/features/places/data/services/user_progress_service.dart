import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserProgressService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  DocumentReference? get _progressDoc {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('places');
  }

  /// Marks [placeId] as explored in Firestore.
  /// Returns true only when this is the first time this place is recorded
  /// (so callers can gate XP awards on the return value).
  Future<bool> recordPlaceExplored(String placeId) async {
    final ref = _progressDoc;
    if (ref == null) return false;

    return _firestore.runTransaction<bool>((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() as Map<String, dynamic>?;
      final ids = List<String>.from(data?['exploredPlaceIds'] ?? []);

      if (ids.contains(placeId)) return false;

      ids.add(placeId);
      tx.set(
        ref,
        {'exploredPlaceIds': ids, 'totalExplored': ids.length},
        SetOptions(merge: true),
      );
      return true;
    });
  }
}
