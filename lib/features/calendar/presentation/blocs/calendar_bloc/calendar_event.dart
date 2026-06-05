import 'package:equatable/equatable.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalendarEvents extends CalendarEvent {
  final DateTime startDate;
  final DateTime endDate;
  final CalendarViewType viewType;
  final String token;

  const LoadCalendarEvents({
    required this.startDate,
    required this.endDate,
    required this.viewType,
    required this.token,
  });

  @override
  List<Object?> get props => [startDate, endDate, viewType, token];
}

class NextMonth extends CalendarEvent {}

class PreviousMonth extends CalendarEvent {}

class EventTapped extends CalendarEvent {
  final CalendarEventEntity event;

  const EventTapped({required this.event});

  @override
  List<Object?> get props => [event];
}
