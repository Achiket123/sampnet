import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/features/calendar/domain/use_cases/get_personal_calendar_usecase.dart';
import 'package:hackathon/features/calendar/domain/use_cases/get_team_calendar_usecase.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetPersonalCalendarUsecase getPersonalCalendarUsecase;
  final GetTeamCalendarUsecase getTeamCalendarUsecase;

  CalendarBloc({
    required this.getPersonalCalendarUsecase,
    required this.getTeamCalendarUsecase,
  }) : super(CalendarInitial()) {
    on<LoadCalendarEvents>(_onLoadCalendarEvents);
    on<EventTapped>(_onEventTapped);
  }

  Future<void> _onLoadCalendarEvents(
    LoadCalendarEvents event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    
    final result = event.viewType == CalendarViewType.personal
        ? await getPersonalCalendarUsecase(
            startDate: event.startDate,
            endDate: event.endDate,
            token: event.token,
          )
        : await getTeamCalendarUsecase(
            startDate: event.startDate,
            endDate: event.endDate,
            token: event.token,
          );

    result.fold(
      (failure) => emit(CalendarError(message: failure.message)),
      (events) => emit(CalendarLoaded(
        events: events,
        focusedDate: event.startDate.add(event.endDate.difference(event.startDate) ~/ 2),
        viewType: event.viewType,
      )),
    );
  }

  void _onEventTapped(
    EventTapped event,
    Emitter<CalendarState> emit,
  ) {
    if (state is CalendarLoaded) {
      final loadedState = state as CalendarLoaded;
      emit(CalendarNavigationState(
        event: event.event,
        events: loadedState.events,
        focusedDate: loadedState.focusedDate,
        viewType: loadedState.viewType,
      ));
    }
  }
}
