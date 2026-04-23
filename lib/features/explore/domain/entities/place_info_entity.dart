import 'package:equatable/equatable.dart';

class PlaceInfoEntity extends Equatable {
  final String? civilization;
  final String? builtBy;
  final String? construction;
  final String? architectureStyle;
  final String? wikiLocation;
  final String? fallback;

  const PlaceInfoEntity({
    this.civilization,
    this.builtBy,
    this.construction,
    this.architectureStyle,
    this.wikiLocation,
    this.fallback,
  });

  @override
  List<Object?> get props => [
        civilization,
        builtBy,
        construction,
        architectureStyle,
        wikiLocation,
        fallback,
      ];
}
