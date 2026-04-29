import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WikimediaMediaService {
  static const String _baseUrl = 'https://commons.wikimedia.org/w/api.php';
  static const Duration _cacheDuration = Duration(hours: 24);

  Future<List<String>> fetchImagesForPlace(String placeId, String placeName, List<String>? tags) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'media_cache_$placeId';
    
    // Check Cache
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      try {
        final decoded = json.decode(cachedData) as Map<String, dynamic>;
        final timestamp = DateTime.parse(decoded['timestamp'] as String);
        if (DateTime.now().difference(timestamp) < _cacheDuration) {
          return List<String>.from(decoded['urls'] as List);
        }
      } catch (e) {
        // Cache parsing failed, ignore and fetch fresh
      }
    }

    // Fetch Fresh Data
    try {
      final query = (tags != null && tags.isNotEmpty) ? tags.join(' OR ') : placeName;
      final uri = Uri.parse(
        '$_baseUrl?action=query&generator=search&gsrsearch=${Uri.encodeComponent(query)}&gsrnamespace=6&gsrlimit=10&prop=imageinfo&iiprop=url&format=json'
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']?['pages'] as Map<String, dynamic>?;
        
        if (pages != null) {
          final List<String> imageUrls = [];
          for (final page in pages.values) {
            final imageInfo = page['imageinfo'] as List<dynamic>?;
            if (imageInfo != null && imageInfo.isNotEmpty) {
              final url = imageInfo[0]['url'] as String?;
              // Filter out common unwanted icons/svgs from Commons
              if (url != null && !url.toLowerCase().endsWith('.svg') && !url.toLowerCase().endsWith('.pdf')) {
                imageUrls.add(url);
              }
            }
          }

          // Save to Cache
          if (imageUrls.isNotEmpty) {
            prefs.setString(cacheKey, json.encode({
              'timestamp': DateTime.now().toIso8601String(),
              'urls': imageUrls,
            }));
            return imageUrls;
          }
        }
      }
    } catch (e) {
      // Return empty on network failure
    }
    
    return [];
  }
}
