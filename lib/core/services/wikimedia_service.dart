import 'dart:convert';
import 'package:http/http.dart' as http;

class WikimediaService {
  static const String _baseUrl = 'https://en.wikipedia.org/w/api.php';
  // In a real app, store this securely (e.g., .env file)
  static const String _accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4MTc5NzUyYWJlMWFkNDhiZDkyYWFhMGU0ZmFlZGFjYSIsImp0aSI6Ijg0OGZlNjFlMzg3ZTI2ZWI5MmQxODUwMmUyYmM3YWNkM2JhODQ2MTdhOTczY2FiNmNlNDE3OGM2YjFiNTU5MmMyODE3MzEzNGYwNDAwOTk3IiwiaWF0IjoxNzY0NzU5NDE0Ljg4MDA4NSwibmJmIjoxNzY0NzU5NDE0Ljg4MDA4NywiZXhwIjozMzMyMTY2ODIxNC44NzY2MTQsInN1YiI6IjgwOTU2MTU5IiwiaXNzIjoiaHR0cHM6Ly9tZXRhLndpa2ltZWRpYS5vcmciLCJyYXRlbGltaXQiOnsicmVxdWVzdHNfcGVyX3VuaXQiOjUwMDAsInVuaXQiOiJIT1VSIn0sInNjb3BlcyI6WyJiYXNpYyJdfQ.UR6cLfbw4v1TC-OVKxrKJ0QCPXs4odaS5LEtoVsrFH4yBS457V1q7H5Vvi_4MgkwdFrefMxHJ_PzVo2BldL9o-WBJi_n7F3cFmTWmnjZGvYNYJjpIPJ4kwlYWX1FkfbMHElb2TEmq4orUYQKx5g2tDtaEfcKdD9aFPffwjFC3i17tH80gjic1lWTVF0dIvNBr3hyQXkD2rptJ-jJn5OGxSpZoL7urFpdaICLvwNz8GxTAsNAv7nKn3ZHuVK4qGlV1EE-3gEKy-_M437CcTnbT_k7X7uBkYwXWxS-iOPXR-uiyMFgR3rN40k0HO5hns4atihlS4GHCJKfqN8bs_DSy4_hgpEfKIZ2ecwNOX0PNS2qcAPTpSIh2aSYNj42sBbN2cUxJQ_Mn4EijinuT4LipLf1i3GsM2-Ow1QdeP5npsl12-0k41CGJT_Q1-b443LRhbBM0WtiwNMjUOphlK5TDpaFFWvr3MUz8kdEC0nzG5L2HeetCa_PYDaZf8PzuUS4uNy4vWSayoSz2j5vTYwELx0vxAe2WpM0ZjMueXchYsMxP2WfYodpDNI39up52H7obpBdJx9Zq2hwzqPd4u0uyispcpjSwJVZ7V1jIrK0V3A43FmfS_KOjXndbW8vT6cusfRXR5qM4KJVBga_UANO4TAgRTKt3osOT3LAek_ImAY';

  // In-memory cache to prevent redundant API calls
  static final Map<String, String> _urlCache = {};
  // Metadata cache for fetchPlaceMetadata results
  static final Map<String, Map<String, String?>> _metadataApiCache = {};
  // Track queries that failed to find an image to avoid redundant calls
  static final Set<String> _failedQueries = {};

  /// Fetches the URL of the main image for a given [query] (e.g., "Eiffel Tower").
  Future<String?> getImageUrl(String query) async {
    if (_urlCache.containsKey(query)) {
      return _urlCache[query];
    }
    if (_failedQueries.contains(query)) {
      return null;
    }

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'action': 'query',
        'prop': 'pageimages',
        'format': 'json',
        'piprop': 'original',
        'titles': query,
        'origin': '*', // Required for CORS in web/some environments
      });

      print('WikimediaService: Fetching image for "$query"...');
      final response = await http.get(
        uri,
        headers: {
          // Authorization is optional for public Wikimedia data; removing if problematic
          // 'Authorization': 'Bearer $_accessToken', 
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
        },
      );

      print('WikimediaService: Response status for "$query": ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print('WikimediaService: Response body for "$query": $data'); // Uncomment for full details
        final pages = data['query']['pages'] as Map<String, dynamic>;
        
        if (pages.isNotEmpty) {
          final pageId = pages.keys.first;
          if (pageId != '-1') {
            final pageData = pages[pageId];
            if (pageData.containsKey('original')) {
              final url = pageData['original']['source'] as String;
              print('WikimediaService: Found image URL for "$query": $url');
              _urlCache[query] = url; // Cache the result
              return url;
            } else {
               print('WikimediaService: No "original" image found for "$query"');
            }
          } else {
             print('WikimediaService: Page not found for "$query" (pageid -1)');
          }
        }
      } else {
        print('WikimediaService: API Error for "$query": ${response.body}');
      }
    } catch (e) {
      print('WikimediaService: Exception fetching image for "$query": $e');
    }
    _failedQueries.add(query);
    return null;
  }
  /// Fetches a short description (extract) for a given [query] from Wikipedia.
  Future<String?> getDescription(String query) async {
    if (_urlCache.containsKey('desc_$query')) {
      return _urlCache['desc_$query'];
    }

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'action': 'query',
        'format': 'json',
        'prop': 'extracts',
        'exintro': 'true',
        'explaintext': 'true',
        'titles': query,
        'redirects': '1',
      });

      print('WikimediaService: Fetching description for "$query"...');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'] as Map<String, dynamic>;
        
        if (pages.isNotEmpty) {
          final pageId = pages.keys.first;
          if (pageId != '-1') {
            final extract = pages[pageId]['extract'] as String?;
            if (extract != null && extract.isNotEmpty) {
              print('WikimediaService: Found description for "$query"');
              _urlCache['desc_$query'] = extract;
              return extract;
            }
          }
        }
      }
    } catch (e) {
      print('WikimediaService: Exception fetching description for "$query": $e');
    }
    return null;
  }

  /// Fetches historical metadata (Built By, Year Built, Civilization) for
  /// [placeName] via the Wikipedia REST API page-summary endpoint.
  /// Returns a [Map] with keys 'builtBy', 'yearBuilt', 'civilization'.
  /// Null values mean the information could not be extracted from the text.
  Future<Map<String, String?>> fetchPlaceMetadata(String placeName) async {
    if (_metadataApiCache.containsKey(placeName)) {
      return _metadataApiCache[placeName]!;
    }
    try {
      final encoded = Uri.encodeComponent(placeName.replaceAll(' ', '_'));
      final uri = Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/$encoded',
      );
      print('WikimediaService: Fetching metadata for "$placeName"...');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'User-Agent': 'TimeExplorer/1.0 (contact@example.com)',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final extract = (data['extract'] as String? ?? '');
        final result = <String, String?>{
          'builtBy': _extractBuiltBy(extract),
          'yearBuilt': _extractYearBuilt(extract),
          'civilization': _extractCivilization(extract),
        };
        print('WikimediaService: Metadata for "$placeName": $result');
        _metadataApiCache[placeName] = result;
        return result;
      }
      print(
        'WikimediaService: fetchPlaceMetadata HTTP ${response.statusCode} for "$placeName"',
      );
    } catch (e) {
      print(
        'WikimediaService: fetchPlaceMetadata exception for "$placeName": $e',
      );
    }
    return {'builtBy': null, 'yearBuilt': null, 'civilization': null};
  }

  /// Looks for "built/constructed/commissioned by [Name]" in [text].
  String? _extractBuiltBy(String text) {
    final patterns = [
      RegExp(r'(?:built|constructed|commissioned|erected|founded|established|ordered|designed)\s+by\s+([^,.;:()\n]{2,60})', caseSensitive: false),
      RegExp(r'([^,.;:()\n]{2,60})\s+(?:built|constructed|commissioned|erected|founded|established|ordered|designed)\b', caseSensitive: false),
      RegExp(r'\b(Emperor|King|Sultan|Pharaoh|Caliph|Shah|Mughal|Raja|Maharaja)\s+([A-Z][a-zA-Z ]{1,40})'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        String? value;
        if (match.groupCount >= 2) {
          value = '${match.group(1)} ${match.group(2)?.trim()}';
        } else {
          value = match.group(1)?.trim();
        }
        
        if (value != null && value.length > 2 && !_isGenericTerm(value)) {
          return _toTitleCase(value);
        }
      }
    }
    return null;
  }

  bool _isGenericTerm(String s) {
    final lower = s.toLowerCase();
    return lower.contains('order') || lower.contains('the citizens') || lower.contains('the people');
  }

  /// Extracts the first plausible construction year (optionally with era) from [text].
  String? _extractYearBuilt(String text) {
    final withEra = RegExp(
      r'\b(\d{3,4})\s*(BCE?|CE?|AD|BC)\b',
      caseSensitive: false,
    );
    final eraMatch = withEra.firstMatch(text);
    if (eraMatch != null) {
      return '${eraMatch.group(1)} ${eraMatch.group(2)!.toUpperCase()}';
    }

    final between = RegExp(r'between\s+(\d{3,4})\s+and\s+(\d{3,4})', caseSensitive: false).firstMatch(text);
    if (between != null) return '${between.group(1)} – ${between.group(2)}';

    final inYear = RegExp(
      r'(?:completed|built|constructed|erected|opened|founded|established|starting)\s+in\s+(\d{3,4})',
      caseSensitive: false,
    ).firstMatch(text);
    if (inYear != null) return inYear.group(1);

    // Fallback: bare 4-digit year in the range 1000–2025
    final bareYear = RegExp(r'\b(1[0-9]{3}|20[01][0-9]|202[0-5])\b');
    final bareMatch = bareYear.firstMatch(text);
    if (bareMatch != null) return bareMatch.group(1);
    return null;
  }

  /// Extracts a civilization, empire, or dynasty name from [text].
  String? _extractCivilization(String text) {
    final known = RegExp(
      r'\b(Ancient Egypt(?:ian)?|Roman Empire|Ancient Greece|Mesopotamian|'
      r'Persian Empire|Ottoman Empire|Mughal Empire|Byzantine Empire|'
      r'Maya(?:n)?|Aztec|Inca|Indus Valley|Maurya(?:n)?|Gupta|Khmer|'
      r'Mongol(?:ian)?|Han Dynasty|Ming Dynasty|Qing Dynasty|'
      r'Umayyad|Abbasid|Safavid|Timurid|Achaemenid|Sumerian|Assyrian|Babylonian|'
      r'Sasanian|Greek|Roman|Egyptian|Viking|Islamic|Buddhist)\b',
      caseSensitive: false,
    );
    final knownMatch = known.firstMatch(text);
    if (knownMatch != null) {
      return _toTitleCase(knownMatch.group(0)!);
    }
    // Generic "[Name] Empire/Dynasty/Kingdom/..."
    final generic = RegExp(
      r'\b([A-Z][a-zA-Z]+(?:\s[A-Z][a-zA-Z]+)?)\s+'
      r'(Empire|Dynasty|Kingdom|Civilization|Sultanate|Republic)\b',
    );
    final gMatch = generic.firstMatch(text);
    if (gMatch != null) {
      final full = '${gMatch.group(1)} ${gMatch.group(2)}';
      if (full.length < 50) return full;
    }
    return null;
  }

  /// Converts [text] to Title Case.
  String _toTitleCase(String text) {
    return text.trim().split(RegExp(r'\s+')).map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }
}
