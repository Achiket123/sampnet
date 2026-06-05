import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetTeamCalendarUsecase {
  final CalendarRepository repository;

  GetTeamCalendarUsecase({required this.repository});

  Future<Either<ErrorModel, List<CalendarEventEntity>>> call({
    required DateTime startDate,
    required DateTime endDate,
    required String token,
  }) {
    return repository.getEvents(
      startDate: startDate,
      endDate: endDate,
      viewType: CalendarViewType.team,
      token: token,
    );
  }
}