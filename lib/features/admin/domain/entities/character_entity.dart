import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String era;
  final String description;
  final String? imageUrl;
  final String? title;
  final String? birthYear;
  final String? deathYear;
  final String? nationality;
  final List<String>? achievements;
  final String? legacy;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.era,
    required this.description,
    this.imageUrl,
    this.title,
    this.birthYear,
    this.deathYear,
    this.nationality,
    this.achievements,
    this.legacy,
  });

  @override
  List<Object?> get props => [
        id, name, category, era, description, imageUrl,
        title, birthYear, deathYear, nationality, achievements, legacy,
      ];
}
