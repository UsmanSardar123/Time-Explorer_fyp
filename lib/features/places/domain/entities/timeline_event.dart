import 'package:equatable/equatable.dart';

class TimelineEvent extends Equatable {
  final String year;
  final String event;

  const TimelineEvent({
    required this.year,
    required this.event,
  });

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'event': event,
    };
  }

  factory TimelineEvent.fromMap(Map<String, dynamic> map) {
    return TimelineEvent(
      year: map['year'] ?? '',
      event: map['event'] ?? '',
    );
  }

  @override
  List<Object?> get props => [year, event];
}
