class FactModel {
  final String id;
  final String fact;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FactModel({
    required this.id,
    required this.fact,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory FactModel.fromMap(Map<String, dynamic> map, String id) {
    return FactModel(
      id: id,
      fact: map['fact'] ?? '',
      category: map['category'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fact': fact,
      'category': category,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  FactModel copyWith({
    String? id,
    String? fact,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FactModel(
      id: id ?? this.id,
      fact: fact ?? this.fact,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
