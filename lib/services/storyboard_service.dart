import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeexplorer/models/storyboard_model.dart';

/// Service layer for fetching [Storyboard] documents from Cloud Firestore.
///
/// Targets the `storyboards` collection. Accepts an optional [FirebaseFirestore]
/// instance for dependency injection during testing.
class StoryboardService {
  final FirebaseFirestore _firestore;

  StoryboardService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches a single storyboard by its document ID.
  ///
  /// Returns `null` if the document does not exist.
  Future<Storyboard?> getStoryboardById(String id) async {
    final doc = await _firestore.collection('storyboards').doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return Storyboard.fromMap(doc.id, doc.data()!);
  }

  /// Returns a real-time stream of a single storyboard document.
  Stream<Storyboard?> streamStoryboardById(String id) {
    return _firestore.collection('storyboards').doc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return Storyboard.fromMap(doc.id, doc.data()!);
    });
  }
}
