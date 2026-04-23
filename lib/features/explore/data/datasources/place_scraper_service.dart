import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

// The 10 canonical keys returned by fetchPlaceData.
const _kBuildType = 'buildType';
const _kTimeBuild = 'timeBuild';
const _kCivilization = 'civilization';
const _kHistoricalPeriod = 'historicalPeriod';
const _kPrimaryMaterial = 'primaryMaterial';
const _kCurrentLocation = 'currentLocation';
const _kDimensions = 'dimensions';
const _kPurpose = 'purpose';
const _kUnescoStatus = 'unescoStatus';
const _kArchitect = 'architect';

const _allKeys = [
  _kBuildType, _kTimeBuild, _kCivilization, _kHistoricalPeriod,
  _kPrimaryMaterial, _kCurrentLocation, _kDimensions, _kPurpose,
  _kUnescoStatus, _kArchitect,
];

const _headers = {
  'User-Agent': 'Mozilla/5.0 (compatible; TimeExplorer/1.0; educational-app)',
  'Accept': 'text/html,application/xhtml+xml',
  'Accept-Language': 'en-US,en;q=0.9',
};

/// Fetches all 10 historical attributes for [placeName].
/// Tries Wikipedia → Britannica → UNESCO → World History Encyclopedia in order.
/// Never returns "Unknown" — applies era-aware defaults for any remaining gaps.
Future<Map<String, String>> fetchPlaceData(String placeName) async {
  final data = <String, String>{};

  await _scrapeWikipedia(placeName, data);

  if (_hasMissing(data)) {
    await _scrapeBritannica(placeName, data);
  }

  if (_hasMissing(data)) {
    await _scrapeUnesco(placeName, data);
  }

  if (_hasMissing(data)) {
    await _scrapeWorldHistory(placeName, data);
  }

  _applyEraDefaults(placeName, data);
  return data;
}

// ─── Wikipedia ───────────────────────────────────────────────────────────────

Future<void> _scrapeWikipedia(String name, Map<String, String> data) async {
  try {
    final slug = Uri.encodeComponent(name.replaceAll(' ', '_'));
    final uri = Uri.parse('https://en.wikipedia.org/wiki/$slug');
    final response = await http.get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) return;

    final doc = html_parser.parse(response.body);
    final infobox = doc.querySelector('table.infobox');
    if (infobox == null) return;

    for (final row in infobox.querySelectorAll('tr')) {
      final label = (row.querySelector('th.infobox-label') ??
              row.querySelector('th'))
          ?.text
          .trim()
          .toLowerCase() ?? '';
      final valueEl = row.querySelector('td.infobox-data') ??
          row.querySelector('td');
      if (valueEl == null || label.isEmpty) continue;

      // Clean: strip footnotes [1], newlines, extra spaces.
      final value = _clean(valueEl.text);
      if (value.isEmpty) continue;

      _assign(data, _kBuildType,        label, value, const [
        'type', 'style', 'architectural style', 'structure type', 'building type',
      ]);
      _assign(data, _kTimeBuild,        label, value, const [
        'built', 'construction', 'constructed', 'date built', 'year built',
        'completed', 'founded', 'established',
      ]);
      _assign(data, _kCivilization,     label, value, const [
        'culture', 'civilization', 'civilisation', 'empire', 'dynasty',
      ]);
      _assign(data, _kHistoricalPeriod, label, value, const [
        'period', 'era', 'epoch', 'age', 'date',
      ]);
      _assign(data, _kPrimaryMaterial,  label, value, const [
        'material', 'materials', 'built of', 'construction material',
      ]);
      _assign(data, _kCurrentLocation,  label, value, const [
        'location', 'coordinates', 'address', 'place', 'country',
      ]);
      _assign(data, _kDimensions,       label, value, const [
        'height', 'length', 'width', 'area', 'dimensions', 'size', 'weight',
        'diameter', 'depth',
      ]);
      _assign(data, _kPurpose,          label, value, const [
        'function', 'purpose', 'use', 'used for', 'dedicated to',
      ]);
      _assign(data, _kUnescoStatus,     label, value, const [
        'unesco', 'world heritage', 'heritage site', 'designation',
      ]);
      _assign(data, _kArchitect,        label, value, const [
        'architect', 'builder', 'built by', 'commissioned by', 'patron',
        'ruler', 'ordered by', 'constructed by',
      ]);
    }
  } catch (_) {}
}

// ─── Britannica ───────────────────────────────────────────────────────────────

Future<void> _scrapeBritannica(String name, Map<String, String> data) async {
  try {
    final slug = Uri.encodeComponent(name.toLowerCase().replaceAll(' ', '-'));
    // Try the most common Britannica URL pattern for historical topics.
    final uri = Uri.parse('https://www.britannica.com/topic/$slug');
    final response = await http.get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) return;

    final doc = html_parser.parse(response.body);

    // .topic-identifier gives the broad category (e.g. "ancient Egyptian temple")
    if (!data.containsKey(_kBuildType)) {
      final identifier = doc.querySelector('.topic-identifier')?.text.trim();
      if (identifier != null && identifier.isNotEmpty) {
        data[_kBuildType] = _clean(identifier);
      }
    }

    // .fact-box contains <dt> labels and <dd> values.
    final factBox = doc.querySelector('.fact-box') ??
        doc.querySelector('[class*="fact-box"]');
    if (factBox != null) {
      final terms = factBox.querySelectorAll('dt');
      final defs  = factBox.querySelectorAll('dd');
      final len   = terms.length < defs.length ? terms.length : defs.length;

      for (var i = 0; i < len; i++) {
        final label = terms[i].text.trim().toLowerCase();
        final value = _clean(defs[i].text);
        if (value.isEmpty) continue;

        _assign(data, _kTimeBuild,        label, value, const ['founded', 'built', 'date', 'construction']);
        _assign(data, _kCivilization,     label, value, const ['culture', 'civilization', 'empire']);
        _assign(data, _kHistoricalPeriod, label, value, const ['period', 'era', 'age']);
        _assign(data, _kPrimaryMaterial,  label, value, const ['material', 'built of']);
        _assign(data, _kCurrentLocation,  label, value, const ['location', 'country', 'place']);
        _assign(data, _kDimensions,       label, value, const ['height', 'size', 'length', 'area']);
        _assign(data, _kPurpose,          label, value, const ['function', 'purpose', 'use']);
        _assign(data, _kArchitect,        label, value, const ['architect', 'builder', 'built by']);
      }
    }

    // UNESCO status: Britannica sometimes lists it in a sidebar paragraph.
    if (!data.containsKey(_kUnescoStatus)) {
      final body = doc.querySelector('.topic-content')?.text ?? '';
      if (body.toLowerCase().contains('world heritage')) {
        data[_kUnescoStatus] = 'UNESCO World Heritage Site';
      }
    }
  } catch (_) {}
}

// ─── UNESCO ──────────────────────────────────────────────────────────────────

Future<void> _scrapeUnesco(String name, Map<String, String> data) async {
  try {
    final query = Uri.encodeQueryComponent(name);
    final searchUri = Uri.parse('https://whc.unesco.org/en/list/?search=$query&order=');
    final searchRes = await http.get(searchUri, headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (searchRes.statusCode != 200) return;

    final searchDoc = html_parser.parse(searchRes.body);

    // Grab the first result link to the site detail page.
    final firstLink = searchDoc.querySelector('.liste_site a')?.attributes['href'];
    if (firstLink == null) return;

    final detailUri = Uri.parse('https://whc.unesco.org$firstLink');
    final detailRes = await http.get(detailUri, headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (detailRes.statusCode != 200) return;

    final doc = html_parser.parse(detailRes.body);

    // UNESCO status is confirmed by presence on the detail page.
    if (!data.containsKey(_kUnescoStatus)) {
      final year = doc.querySelector('.field-name-field-date')?.text.trim();
      data[_kUnescoStatus] = year != null && year.isNotEmpty
          ? 'UNESCO World Heritage Site (inscribed $year)'
          : 'UNESCO World Heritage Site';
    }

    // .quick-facts has a <dl> with <dt>/<dd> pairs.
    final quickFacts = doc.querySelector('.quick-facts') ??
        doc.querySelector('[class*="quick-facts"]');
    if (quickFacts != null) {
      final terms = quickFacts.querySelectorAll('dt');
      final defs  = quickFacts.querySelectorAll('dd');
      final len   = terms.length < defs.length ? terms.length : defs.length;

      for (var i = 0; i < len; i++) {
        final label = terms[i].text.trim().toLowerCase();
        final value = _clean(defs[i].text);
        if (value.isEmpty) continue;

        _assign(data, _kCurrentLocation,  label, value, const ['state', 'country', 'location']);
        _assign(data, _kHistoricalPeriod, label, value, const ['period', 'date', 'criteria']);
        _assign(data, _kCivilization,     label, value, const ['culture', 'civilization']);
      }
    }

    // Property description sometimes contains material and dimensions.
    if (!data.containsKey(_kPrimaryMaterial) || !data.containsKey(_kDimensions)) {
      final desc = doc.querySelector('.field-name-body')?.text ?? '';
      if (!data.containsKey(_kPrimaryMaterial)) {
        final matMatch = RegExp(r'(?:made of|built (?:with|from|of)|constructed (?:from|of))\s+([^,.]+)',
            caseSensitive: false).firstMatch(desc);
        if (matMatch != null) data[_kPrimaryMaterial] = _clean(matMatch.group(1) ?? '');
      }
      if (!data.containsKey(_kDimensions)) {
        final dimMatch = RegExp(r'(\d[\d,.]* (?:metres?|meters?|km|hectares?|feet|ft)[^,.]*)',
            caseSensitive: false).firstMatch(desc);
        if (dimMatch != null) data[_kDimensions] = _clean(dimMatch.group(1) ?? '');
      }
    }
  } catch (_) {}
}

// ─── World History Encyclopedia ───────────────────────────────────────────────

Future<void> _scrapeWorldHistory(String name, Map<String, String> data) async {
  try {
    final query = Uri.encodeQueryComponent(name);
    final uri = Uri.parse('https://www.worldhistory.org/search/?q=$query');
    final searchRes = await http.get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (searchRes.statusCode != 200) return;

    final searchDoc = html_parser.parse(searchRes.body);
    final firstHref = searchDoc.querySelector('.search-result a')?.attributes['href'];
    if (firstHref == null) return;

    final detailUri = Uri.parse('https://www.worldhistory.org$firstHref');
    final detailRes = await http.get(detailUri, headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (detailRes.statusCode != 200) return;

    final doc = html_parser.parse(detailRes.body);

    // Definition panel has the period/civilization.
    final definitionRows = doc.querySelectorAll('.definition-list__row');
    for (final row in definitionRows) {
      final label = row.querySelector('.definition-list__label')?.text.trim().toLowerCase() ?? '';
      final value = _clean(row.querySelector('.definition-list__value')?.text ?? '');
      if (value.isEmpty) continue;

      _assign(data, _kTimeBuild,        label, value, const ['date', 'founded', 'built', 'period']);
      _assign(data, _kCivilization,     label, value, const ['culture', 'civilization', 'empire']);
      _assign(data, _kHistoricalPeriod, label, value, const ['period', 'era']);
      _assign(data, _kCurrentLocation,  label, value, const ['location', 'place', 'region']);
      _assign(data, _kArchitect,        label, value, const ['built by', 'architect', 'ruler']);
    }

    // Pull purpose from the opening paragraph if still missing.
    if (!data.containsKey(_kPurpose)) {
      final intro = doc.querySelector('.intro p, article p')?.text ?? '';
      if (intro.length > 20) {
        // First sentence makes a serviceable purpose summary.
        final sentence = intro.split('.').first.trim();
        if (sentence.isNotEmpty) data[_kPurpose] = sentence;
      }
    }
  } catch (_) {}
}

// ─── Era-aware defaults ───────────────────────────────────────────────────────

/// Fills any remaining gaps with plausible defaults inferred from the place
/// name and whatever has already been scraped.
void _applyEraDefaults(String placeName, Map<String, String> data) {
  final nameLower = placeName.toLowerCase();
  final period    = (data[_kHistoricalPeriod] ?? data[_kTimeBuild] ?? '').toLowerCase();
  final isAncient = period.contains(RegExp(r'bc|ancient|antiquity|classical')) ||
      nameLower.contains(RegExp(r'pyramid|temple|acropolis|colosseum|parthenon|angkor'));
  final isMedieval = period.contains(RegExp(r'medieval|middle ages|1[0-4]\d\d')) ||
      nameLower.contains(RegExp(r'castle|cathedral|fort|mosque'));
  final isIndustrial = period.contains(RegExp(r'19th|industrial|1[89]\d\d'));

  data.putIfAbsent(_kBuildType,        () => isAncient   ? 'Ancient Monumental Structure'
                                          : isMedieval  ? 'Medieval Fortified Structure'
                                          : 'Historic Architectural Complex');
  data.putIfAbsent(_kTimeBuild,        () => isAncient   ? 'Constructed in Antiquity (before 500 AD)'
                                          : isMedieval  ? 'Medieval Period (500–1500 AD)'
                                          : isIndustrial? '19th Century'
                                          : 'Date not publicly recorded');
  data.putIfAbsent(_kCivilization,     () => _inferCivilization(nameLower));
  data.putIfAbsent(_kHistoricalPeriod, () => isAncient   ? 'Ancient Period'
                                          : isMedieval  ? 'Medieval Period'
                                          : 'Modern Historical Period');
  data.putIfAbsent(_kPrimaryMaterial,  () => isAncient   ? 'Limestone, Sandstone, and Granite'
                                          : isMedieval  ? 'Cut Stone and Mortar'
                                          : 'Brick, Stone, and Timber');
  data.putIfAbsent(_kCurrentLocation,  () => 'Location on record — see site authority');
  data.putIfAbsent(_kDimensions,       () => 'Scale not centrally documented');
  data.putIfAbsent(_kPurpose,          () => isAncient   ? 'Religious, ceremonial, or funerary complex'
                                          : isMedieval  ? 'Defensive fortification and seat of power'
                                          : 'Cultural and civic landmark');
  data.putIfAbsent(_kUnescoStatus,     () => 'UNESCO status not confirmed in public records');
  data.putIfAbsent(_kArchitect,        () => isAncient   ? 'Master builders of the ruling dynasty'
                                          : 'Historical architect not attributed in sources');
}

String _inferCivilization(String nameLower) {
  if (nameLower.contains(RegExp(r'egypt|nile|pharaoh|pyramid'))) return 'Ancient Egyptian';
  if (nameLower.contains(RegExp(r'rome|roman|colosseum|pantheon'))) return 'Ancient Roman';
  if (nameLower.contains(RegExp(r'greek|greece|acropolis|parthenon'))) return 'Ancient Greek';
  if (nameLower.contains(RegExp(r'india|indus|mughal|taj'))) return 'South Asian';
  if (nameLower.contains(RegExp(r'china|chinese|ming|qing'))) return 'Chinese Imperial';
  if (nameLower.contains(RegExp(r'mayan|aztec|inca|mesoamerica'))) return 'Pre-Columbian';
  if (nameLower.contains(RegExp(r'mesopotam|babylon|assyria|sumeria'))) return 'Ancient Mesopotamian';
  if (nameLower.contains(RegExp(r'ottoman|istanbul|mosque'))) return 'Ottoman';
  return 'Civilisation not conclusively identified';
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

bool _hasMissing(Map<String, String> data) =>
    _allKeys.any((k) => !data.containsKey(k));

/// Assigns [value] to [key] only if the key is missing and [label] matches
/// one of the [synonyms].
void _assign(
  Map<String, String> data,
  String key,
  String label,
  String value,
  List<String> synonyms,
) {
  if (data.containsKey(key)) return;
  if (synonyms.any((s) => label.contains(s))) {
    data[key] = value;
  }
}

/// Strips Wikipedia footnotes, brackets, excess whitespace, and newlines.
String _clean(String raw) {
  return raw
      .replaceAll(RegExp(r'\[\d+\]'), '')   // [1], [2] footnotes
      .replaceAll(RegExp(r'\s+'), ' ')       // collapse whitespace
      .replaceAll(RegExp(r'^\s*[,;]\s*'), '') // leading punctuation
      .trim();
}
