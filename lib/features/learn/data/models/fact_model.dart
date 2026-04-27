class FactModel {
  final String id;
  final String title;
  final String description;
  final String? relatedEntityId;
  final String? type; // character / place
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FactModel({
    required this.id,
    required this.title,
    required this.description,
    this.relatedEntityId,
    this.type,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory FactModel.fromMap(Map<String, dynamic> map, String id) {
    return FactModel(
      id: id,
      title: map['title'] ?? map['fact'] ?? '', // Fallback to old 'fact' field
      description: map['description'] ?? '',
      relatedEntityId: map['relatedEntityId'],
      type: map['type'],
      category: map['category'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'relatedEntityId': relatedEntityId,
      'type': type,
      'category': category,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  FactModel copyWith({
    String? id,
    String? title,
    String? description,
    String? relatedEntityId,
    String? type,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FactModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      type: type ?? this.type,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
