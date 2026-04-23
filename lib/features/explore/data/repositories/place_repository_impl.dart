import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/explore/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final FirebaseFirestore _firestore;

  PlaceRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<PlaceEntity>> getPlaces({String? category}) async {
    try {
      Query query = _firestore.collection('places');
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      
      final querySnapshot = await query.get();
      
      var places = querySnapshot.docs.map((doc) {
        final json = doc.data() as Map<String, dynamic>;
        return PlaceEntity(
          id: doc.id,
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

      return places;
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }
}
