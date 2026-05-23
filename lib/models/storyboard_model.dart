/// Data models for the Storyboard feature.
///
/// [StoryboardPanel] represents a single visual panel in a storyboard sequence.
/// [Storyboard] is the master model that groups panels into a navigable story.

class StoryboardPanel {
  final int panelNumber;
  final String imageUrl;
  final String description;
  final String audioUrl;

  const StoryboardPanel({
    required this.panelNumber,
    required this.imageUrl,
    required this.description,
    required this.audioUrl,
  });

  factory StoryboardPanel.fromMap(Map<String, dynamic> map) {
    return StoryboardPanel(
      panelNumber: (map['panelNumber'] as num).toInt(),
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
      audioUrl: map['audioUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'panelNumber': panelNumber,
      'imageUrl': imageUrl,
      'description': description,
      'audioUrl': audioUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryboardPanel &&
          runtimeType == other.runtimeType &&
          panelNumber == other.panelNumber &&
          imageUrl == other.imageUrl &&
          description == other.description &&
          audioUrl == other.audioUrl;

  @override
  int get hashCode => Object.hash(panelNumber, imageUrl, description, audioUrl);
}

class Storyboard {
  final String id;
  final String title;
  final String era;
  final int totalPanels;
  final List<StoryboardPanel> panelsList;

  const Storyboard({
    required this.id,
    required this.title,
    required this.era,
    required this.totalPanels,
    required this.panelsList,
  });

  factory Storyboard.fromMap(String id, Map<String, dynamic> map) {
    final rawPanels = map['panelsList'] as List<dynamic>? ?? [];
    final panels = rawPanels
        .map((p) => StoryboardPanel.fromMap(p as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.panelNumber.compareTo(b.panelNumber));

    return Storyboard(
      id: id,
      title: map['title'] as String? ?? '',
      era: map['era'] as String? ?? '',
      totalPanels: (map['totalPanels'] as num?)?.toInt() ?? panels.length,
      panelsList: panels,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'era': era,
      'totalPanels': totalPanels,
      'panelsList': panelsList.map((p) => p.toMap()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Storyboard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          era == other.era &&
          totalPanels == other.totalPanels;

  @override
  int get hashCode => Object.hash(id, title, era, totalPanels);
}
