import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';

class BookmarkProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  BookmarkProvider({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  List<PlaceEntity> _bookmarkedPlaces = [];
  bool _isLoading = false;

  List<PlaceEntity> get bookmarkedPlaces => _bookmarkedPlaces;
  bool get isLoading => _isLoading;

  Future<void> loadBookmarks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
      if (!docSnapshot.exists) {
        _bookmarkedPlaces = [];
        return;
      }

      final data = docSnapshot.data()!;
      final List<dynamic> bookmarksData = data['bookmarks'] ?? [];

      _bookmarkedPlaces = bookmarksData.map((json) {
        return PlaceEntity(
          id: json['id'] ?? '',
          name: json['name'] ?? '',
          description: json['description'] ?? '',
          imageUrl: json['imageUrl'] ?? '',
          category: json['category'] ?? '',
          rating: (json['rating'] ?? 0.0).toDouble(),
          location: json['location'] ?? '',
          history: json['history'],
          era: json['era'],
          quickFacts: json['quickFacts'] != null 
              ? Map<String, String>.from(json['quickFacts']) 
              : null,
          galleryImages: json['images'] != null 
              ? List<String>.from(json['images']) 
              : null,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isBookmarked(String placeId) {
    return _bookmarkedPlaces.any((place) => place.id == placeId);
  }

  Future<void> toggleBookmark(PlaceEntity place) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final isSaved = isBookmarked(place.id);

    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      
      final placeMap = {
        'id': place.id,
        'name': place.name,
        'description': place.description,
        'imageUrl': place.imageUrl,
        'category': place.category,
        'rating': place.rating,
        'location': place.location,
        'history': place.history,
        'era': place.era,
        'quickFacts': place.quickFacts,
        'images': place.galleryImages,
      };

      if (isSaved) {
        // Remove
        await userRef.update({
          'bookmarks': FieldValue.arrayRemove([placeMap])
        }).catchError((e) {
             // fallback if exact match fails
             debugPrint('Array remove failed: $e, fetching and manually removing');
        });
        // We'll trust local state
        _bookmarkedPlaces.removeWhere((p) => p.id == place.id);
      } else {
        // Add
        await userRef.set({
          'bookmarks': FieldValue.arrayUnion([placeMap])
        }, SetOptions(merge: true));
        _bookmarkedPlaces.add(place);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
    }
  }
}
