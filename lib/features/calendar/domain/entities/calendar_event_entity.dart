import 'package:equatable/equatable.dart';

enum CalendarViewType { personal, team }

class CalendarEventEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType; // task, milestone, leave, attendance
  final int entityId;
  final String status;
  final String? assignedToName;

  const CalendarEventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.eventType,
    required this.entityId,
    required this.status,
    this.assignedToName,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        eventType,
        entityId,
        status,
        assignedToName,
      ];
}
