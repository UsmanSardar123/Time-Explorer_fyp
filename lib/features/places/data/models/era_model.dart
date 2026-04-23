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
  });

  factory EraModel.fromMap(Map<String, dynamic> data, String id) {
    return EraModel(
      id: id,
      eraName: data['eraName'] ?? '',
      timePeriod: data['timePeriod'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      detailedDescription: data['detailedDescription'] ?? '',
      outerImage: data['outerImage'] ?? data['image'] ?? '',
      innerImage: data['innerImage'] ?? data['image'] ?? '',
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
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
