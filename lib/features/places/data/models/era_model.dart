import 'package:timeexplorer/features/places/domain/entities/era.dart';

class EraModel extends Era {
  const EraModel({
    required super.id,
    required super.eraName,
    required super.timePeriod,
    required super.shortDescription,
    required super.detailedDescription,
    required super.outerImage,
    required super.innerImage,
    super.keyEvents = const [],
    super.interestingFacts = const [],
  });

  factory EraModel.fromMap(Map<String, dynamic> data, String id) {
    List<String> toStringList(dynamic value) {
      if (value is List) return value.map((e) => e.toString()).toList();
      return const [];
    }

    return EraModel(
      id: id,
      eraName: data['eraName'] ?? '',
      timePeriod: data['timePeriod'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      detailedDescription: data['detailedDescription'] ?? '',
      outerImage: data['outerImage'] ?? data['image'] ?? '',
      innerImage: data['innerImage'] ?? data['image'] ?? '',
      keyEvents: toStringList(data['keyEvents']),
      interestingFacts: toStringList(data['interestingFacts']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eraName': eraName,
      'timePeriod': timePeriod,
      'shortDescription': shortDescription,
      'detailedDescription': detailedDescription,
      'outerImage': outerImage,
      'innerImage': innerImage,
      'keyEvents': keyEvents,
      'interestingFacts': interestingFacts,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
