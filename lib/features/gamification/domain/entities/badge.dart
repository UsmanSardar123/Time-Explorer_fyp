import 'package:equatable/equatable.dart';

class Badge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isUnlocked;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  Badge copyWith({bool? isUnlocked}) {
    return Badge(
      id: id,
      name: name,
      description: description,
      icon: icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'isUnlocked': isUnlocked,
  };

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    icon: json['icon'],
    isUnlocked: json['isUnlocked'] ?? false,
  );

  @override
  List<Object?> get props => [id, name, description, icon, isUnlocked];
}
