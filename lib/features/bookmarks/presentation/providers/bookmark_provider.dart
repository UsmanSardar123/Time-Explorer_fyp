import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/event_explorer/data/datasources/event_static_data_source.dart';
import 'package:timeexplorer/features/event_explorer/domain/entities/historical_event.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';

class BookmarkProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const _eventPrefKey = 'event_explorer_favorites';
  static const _charBookmarksKey = 'bookmarks_characters';

  BookmarkProvider({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  List<PlaceEntity> _bookmarkedPlaces = [];
  List<HistoricalEvent> _bookmarkedEvents = [];
  List<Character> _bookmarkedCharacters = [];
  bool _isLoading = false;

  List<PlaceEntity> get bookmarkedPlaces => _bookmarkedPlaces;
  List<HistoricalEvent> get bookmarkedEvents => _bookmarkedEvents;
  List<Character> get bookmarkedCharacters => _bookmarkedCharacters;
  bool get isLoading => _isLoading;

  Future<void> loadBookmarks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _loadPlaces(user.uid),
        _loadEvents(),
        _loadCharacters(user.uid),
      ]);
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadPlaces(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) { _bookmarkedPlaces = []; return; }
    final List<dynamic> raw = doc.data()?['bookmarks'] ?? [];
    _bookmarkedPlaces = raw.map((json) => PlaceEntity(
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
    )).toList();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_eventPrefKey) ?? []).toSet();
    if (ids.isEmpty) { _bookmarkedEvents = []; return; }
    final all = await EventStaticDataSource().fetchAll();
    _bookmarkedEvents = all.where((e) => ids.contains(e.id)).toList();
  }

  Future<void> _loadCharacters(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final List<dynamic> raw = doc.data()?[_charBookmarksKey] ?? [];
    _bookmarkedCharacters = raw.map((json) => Character(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: CharacterCategory.fromString(json['category'] ?? ''),
      era: json['era'] ?? '',
      description: json['description'] ?? '',
      origin: json['origin'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
    )).toList();
  }

  bool isBookmarked(String placeId) =>
      _bookmarkedPlaces.any((p) => p.id == placeId);

  bool isCharacterBookmarked(String characterId) =>
      _bookmarkedCharacters.any((c) => c.id == characterId);

  Future<void> toggleBookmark(PlaceEntity place) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final isSaved = isBookmarked(place.id);
    try {
      final ref = _firestore.collection('users').doc(user.uid);
      final map = {
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
        await ref.update({'bookmarks': FieldValue.arrayRemove([map])})
            .catchError((_) {});
        _bookmarkedPlaces.removeWhere((p) => p.id == place.id);
      } else {
        await ref.set(
            {'bookmarks': FieldValue.arrayUnion([map])},
            SetOptions(merge: true));
        _bookmarkedPlaces.add(place);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling place bookmark: $e');
    }
  }

  Future<void> toggleCharacterBookmark(Character character) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final isSaved = isCharacterBookmarked(character.id);
    try {
      final ref = _firestore.collection('users').doc(user.uid);
      final map = {
        'id': character.id,
        'name': character.name,
        'category': character.category.name,
        'era': character.era,
        'description': character.description,
        'origin': character.origin,
        'imageUrl': character.imageUrl,
        'title': character.title,
      };
      if (isSaved) {
        await ref.update({_charBookmarksKey: FieldValue.arrayRemove([map])})
            .catchError((_) {});
        _bookmarkedCharacters.removeWhere((c) => c.id == character.id);
      } else {
        await ref.set(
            {_charBookmarksKey: FieldValue.arrayUnion([map])},
            SetOptions(merge: true));
        _bookmarkedCharacters.add(character);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling character bookmark: $e');
    }
  }
}
