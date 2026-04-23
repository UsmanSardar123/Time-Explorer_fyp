import 'package:equatable/equatable.dart';

class Era extends Equatable {
  final String id;
  final String eraName;
  final String timePeriod;
  final String shortDescription;
  final String detailedDescription;
  final String outerImage;
  final String innerImage;

  const Era({
    required this.id,
    required this.eraName,
    required this.timePeriod,
    required this.shortDescription,
    required this.detailedDescription,
    required this.outerImage,
    required this.innerImage,
  });

  @override
  List<Object?> get props => [
        id,
        eraName,
        timePeriod,
        shortDescription,
        detailedDescription,
        outerImage,
        innerImage,
      ];
}
