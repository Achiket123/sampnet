import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';

class CalendarEventModel extends CalendarEventEntity {
  const CalendarEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startTime,
    required super.endTime,
    required super.eventType,
    required super.entityId,
    required super.status,
    super.assignedToName,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    final startStr = json['start_time'] as String? ?? '';
    final endStr = json['end_time'] as String? ?? '';
    
    DateTime parsedStart = DateTime.tryParse(startStr) ?? DateTime.now();
    DateTime parsedEnd = DateTime.tryParse(endStr) ?? DateTime.now();
    
    parsedStart = parsedStart.isUtc ? parsedStart.toLocal() : parsedStart;
    parsedEnd = parsedEnd.isUtc ? parsedEnd.toLocal() : parsedEnd;

    return CalendarEventModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startTime: parsedStart,
      endTime: parsedEnd,
      eventType: json['event_type'] as String? ?? '',
      entityId: json['entity_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      assignedToName: json['assigned_to_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
      'event_type': eventType,
      'entity_id': entityId,
      'status': status,
      'assigned_to_name': assignedToName,
    };
  }
}
