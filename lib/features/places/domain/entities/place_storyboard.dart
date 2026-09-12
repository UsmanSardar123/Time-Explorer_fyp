import 'package:equatable/equatable.dart';

class PlaceStoryboardSection extends Equatable {
  final String type;
  final String title;
  final String text;
  final List<String> items;

  const PlaceStoryboardSection({
    required this.type,
    required this.title,
    this.text = '',
    this.items = const [],
  });

  factory PlaceStoryboardSection.fromMap(Map<String, dynamic> map) {
    final type = map['type'];
    final title = map['title'];
    final text = map['text'];
    final rawItems = map['items'];
    if (type is! String || type.trim().isEmpty ||
        title is! String || title.trim().isEmpty ||
        (text is! String && rawItems is! List)) {
      throw const FormatException('Invalid storyboard section');
    }

    final items = rawItems is List
        ? rawItems.whereType<String>().map((item) => item.trim()).where((item) => item.isNotEmpty).toList()
        : <String>[];
    final sectionText = text is String ? text.trim() : '';
    if (sectionText.isEmpty && items.isEmpty) {
      throw const FormatException('Storyboard section has no content');
    }

    return PlaceStoryboardSection(
      type: type.trim(),
      title: title.trim(),
      text: sectionText,
      items: items,
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'title': title,
        'text': text,
        'items': items,
      };

  @override
  List<Object?> get props => [type, title, text, items];
}

class PlaceStoryboard extends Equatable {
  final String title;
  final String subtitle;
  final String intro;
  final List<PlaceStoryboardSection> sections;

  const PlaceStoryboard({
    required this.title,
    required this.subtitle,
    required this.intro,
    required this.sections,
  });

  factory PlaceStoryboard.fromMap(Map<String, dynamic> map) {
    final title = map['title'];
    final subtitle = map['subtitle'];
    final intro = map['intro'];
    final rawSections = map['sections'];
    if (title is! String || title.trim().isEmpty ||
        subtitle is! String || subtitle.trim().isEmpty ||
        intro is! String || intro.trim().isEmpty ||
        rawSections is! List || rawSections.isEmpty) {
      throw const FormatException('Invalid storyboard');
    }

    final sections = rawSections
        .whereType<Map>()
        .map((section) => PlaceStoryboardSection.fromMap(Map<String, dynamic>.from(section)))
        .toList();
    if (sections.length != rawSections.length) {
      throw const FormatException('Invalid storyboard sections');
    }

    return PlaceStoryboard(
      title: title.trim(),
      subtitle: subtitle.trim(),
      intro: intro.trim(),
      sections: sections,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'subtitle': subtitle,
        'intro': intro,
        'sections': sections.map((section) => section.toMap()).toList(),
      };

  @override
  List<Object?> get props => [title, subtitle, intro, sections];
}
