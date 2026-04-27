import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

/// Fetches place metadata from Wikipedia REST API with Hive-backed caching.
class WikipediaService {
  static const _boxName = 'wikipedia_cache';
  static const _ua = 'TimeExplorer/1.0 (contact@example.com)';

  /// Returns {builtBy, yearBuilt, civilization, archStyle, fallback} for [placeName].
  Future<Map<String, String?>> fetchMetadata(String placeName) async {
    final box = Hive.box<String>(_boxName);
    final cached = box.get(placeName);
    if (cached != null) {
      try {
        final decoded = Map<String, String?>.from(json.decode(cached) as Map);
        if (decoded.containsKey('fallback') && (decoded['civilization']?.toLowerCase() != 'unknown' && decoded['civilization'] != null)) {
          return decoded;
        }
      } catch (_) {}
    }

    try {
      final slug = Uri.encodeComponent(placeName.replaceAll(' ', '_'));
      final uri = Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$slug');
      final res = await http.get(uri, headers: {'User-Agent': _ua}).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final body = json.decode(res.body) as Map<String, dynamic>;
        final extract = (body['extract'] as String? ?? '');
        
        var civilization = _civilization(extract);
        
        // DEEP SEARCH FALLBACK for Civilization
        if (civilization == null || civilization.toLowerCase() == 'unknown') {
          debugPrint('[WikipediaService] Deep searching civilization for "$placeName"...');
          civilization = await _deepSearchCivilization(placeName);
        }

        final result = <String, String?>{
          'builtBy': _builtBy(extract),
          'yearBuilt': _yearBuilt(extract),
          'civilization': civilization ?? 'Historical Civilization', // Universal fallback
          'archStyle': _architecturalStyle(extract),
          'fallback': _firstTwoSentences(extract),
        };
        
        await box.put(placeName, json.encode(result));
        return result;
      }
    } catch (e) {
      debugPrint('[WikipediaService] Error for "$placeName": $e');
    }
    return {
      'builtBy': null,
      'yearBuilt': null,
      'civilization': 'Historical Civilization',
      'archStyle': null,
      'fallback': null,
    };
  }

  Future<String?> _deepSearchCivilization(String placeName) async {
    try {
      // Search Wikipedia specifically for the civilization of this place
      final searchUri = Uri.parse('https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=${Uri.encodeComponent("$placeName civilization")}&format=json&origin=*');
      final searchRes = await http.get(searchUri);
      if (searchRes.statusCode == 200) {
        final searchBody = json.decode(searchRes.body);
        final snippets = (searchBody['query']['search'] as List?)?.map((s) => s['snippet'] as String).join(' ') ?? '';
        final found = _civilization(snippets.replaceAll(RegExp(r'<[^>]*>'), ''));
        if (found != null) return found;
      }
    } catch (_) {}
    return null;
  }

  String? _architecturalStyle(String t) {
    final styles = RegExp(
      r'\b(Gothic|Romanesque|Baroque|Renaissance|Neoclassical|Art Deco|Modernist|'
      r'Mughal|Indo-Islamic|Corinthian|Doric|Ionic|Byzantine|Dravidian|Nagara|'
      r'Islamic|Victorian|Edwardian|Palladian|Greek Revival|Moorish|Maya|Aztec|'
      r'Egyptian|Angkor|Khmer|Ancient Roman|Ancient Greek)\b',
      caseSensitive: false,
    ).firstMatch(t);
    if (styles != null) return '${styles.group(0)} architecture';
    return null;
  }

  /// First two sentences of [text], used as a fallback description.
  String? _firstTwoSentences(String text) {
    if (text.isEmpty) return null;
    final parts = text.split(RegExp(r'(?<=[.!?])\s+'));
    final two = parts.take(2).join(' ').trim();
    return two.isEmpty ? null : two;
  }

  String? _builtBy(String t) {
    // Priority patterns
    final patterns = [
      // "built by [Name]"
      RegExp(r'(?:built|constructed|commissioned|erected|founded|established|ordered|designed)\s+by\s+([^,.;:()\n]{2,60})', caseSensitive: false),
      // "[Name] commissioned/built ..."
      RegExp(r'([^,.;:()\n]{2,60})\s+(?:built|constructed|commissioned|erected|founded|established|ordered|designed)\b', caseSensitive: false),
      // "Emperor/King/Sultan X" pattern
      RegExp(r'\b(Emperor|King|Sultan|Pharaoh|Caliph|Shah|Mughal|Raja|Maharaja)\s+([A-Z][a-zA-Z ]{1,40})'),
    ];

    for (var p in patterns) {
      final m = p.firstMatch(t);
      if (m != null) {
        String? v;
        if (m.groupCount >= 2) {
          v = '${m.group(1)} ${m.group(2)?.trim()}';
        } else {
          v = m.group(1)?.trim();
        }
        
        if (v != null && v.isNotEmpty && !_isGenericTerm(v)) return v;
      }
    }
    return null;
  }

  bool _isGenericTerm(String s) {
    final lower = s.toLowerCase();
    return lower.contains('order') || lower.contains('the citizens') || lower.contains('the people');
  }

  String? _yearBuilt(String t) {
    // e.g. "1320 BCE", "762 AD", "3 BC"
    final era = RegExp(
      r'\b(\d{1,4})\s*(BCE?|CE?|AD|BC)\b',
      caseSensitive: false,
    ).firstMatch(t);
    if (era != null) return '${era.group(1)} ${era.group(2)!.toUpperCase()}';

    // "between X and Y"
    final between = RegExp(r'between\s+(\d{3,4})\s+and\s+(\d{3,4})', caseSensitive: false).firstMatch(t);
    if (between != null) return '${between.group(1)} – ${between.group(2)}';

    // "in 1889", "starting in 1541", "completed in 447"
    final inYear = RegExp(
      r'(?:completed|built|constructed|erected|opened|founded|established|starting)\s+in\s+(\d{3,4})',
      caseSensitive: false,
    ).firstMatch(t);
    if (inYear != null) return inYear.group(1);

    // Bare 4-digit year 1000–2025 (likely context of construction/founding in first sentences)
    return RegExp(
      r'\b(1[0-9]{3}|20[01][0-9]|202[0-5])\b',
    ).firstMatch(t)?.group(1);
  }

  String? _civilization(String t) {
    final known = RegExp(
      r'\b(Ancient Egypt(?:ian)?|Roman Empire|Ancient Greece|Mesopotamian|'
      r'Persian Empire|Ottoman Empire|Mughal Empire|Byzantine Empire|'
      r'Maya(?:n)?|Aztec|Inca|Indus Valley|Maurya(?:n)?|Gupta|Khmer|'
      r'Mongol(?:ian)?|Han Dynasty|Ming Dynasty|Qing Dynasty|'
      r'Umayyad|Abbasid|Safavid|Timurid|Achaemenid|Sumerian|Assyrian|Babylonian|'
      r'Sasanian|Greek|Roman|Egyptian|Viking|Islamic|Buddhist)\b',
      caseSensitive: false,
    ).firstMatch(t);
    if (known != null) return known.group(0);
    
    final generic = RegExp(
      r'\b([A-Z][a-zA-Z]+(?:\s[A-Z][a-zA-Z]+)?)\s+'
      r'(Empire|Dynasty|Kingdom|Sultanate|Caliphate|Republic|Civilization)\b',
    ).firstMatch(t);
    if (generic != null) return '${generic.group(1)} ${generic.group(2)}';
    return null;
  }

  /// Fetches a short description for a specific entity (e.g. "Mughal Empire").
  Future<String?> findEntitySummary(String entityName) async {
    if (entityName.toLowerCase() == 'unknown') return null;
    
    final box = Hive.box<String>(_boxName);
    final cacheKey = 'summary_$entityName';
    final cached = box.get(cacheKey);
    if (cached != null) return cached;

    try {
      final slug = Uri.encodeComponent(entityName.replaceAll(' ', '_'));
      final uri = Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$slug');
      final res = await http.get(uri, headers: {'User-Agent': _ua}).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final body = json.decode(res.body) as Map<String, dynamic>;
        final extract = body['extract'] as String? ?? '';
        final summary = _firstTwoSentences(extract);
        if (summary != null) {
          await box.put(cacheKey, summary);
          return summary;
        }
      }
    } catch (_) {}
    return null;
  }
}
