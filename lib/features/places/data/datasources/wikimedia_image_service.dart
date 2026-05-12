import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WikimediaImageService {
  /// Fetches a high-quality image URL from Wikimedia API based on the search term.
  /// 
  /// Returns [null] if no image is found or an error occurs.
  static Future<String?> fetchPlaceImageUrl(String placeName) async {
    if (placeName.isEmpty) return null;

    try {
      final query = Uri.encodeComponent(placeName);
      final url = Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$query');

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'TimeExplorerApp/1.0 (mailto:admin@timeexplorer.app)', // Recommended by Wikimedia API guidelines
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Prefer original image for highest quality, fallback to thumbnail if original not present
        if (data.containsKey('originalimage') && data['originalimage']['source'] != null) {
          return data['originalimage']['source'] as String;
        } else if (data.containsKey('thumbnail') && data['thumbnail']['source'] != null) {
          return data['thumbnail']['source'] as String;
        }
      }
      
      // If direct match fails, we could optionally implement a search query here, 
      // but for simplicity and to avoid irrelevant images, we return null.
      return null;
    } catch (e) {
      debugPrint('[WikimediaImageService] Error fetching image for $placeName: $e');
      return null;
    }
  }
}
