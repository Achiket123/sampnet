import 'package:equatable/equatable.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<CalendarEventEntity> events;
  final DateTime focusedDate;
  final CalendarViewType viewType;

  const CalendarLoaded({
    required this.events,
    required this.focusedDate,
    required this.viewType,
  });

  @override
  List<Object?> get props => [events, focusedDate, viewType];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CalendarNavigationState extends CalendarLoaded {
  final CalendarEventEntity event;

  const CalendarNavigationState({
    required this.event,
    required List<CalendarEventEntity> events,
    required DateTime focusedDate,
    required CalendarViewType viewType,
  }) : super(events: events, focusedDate: focusedDate, viewType: viewType);

  @override
  List<Object?> get props => [event, events, focusedDate, viewType];
}
