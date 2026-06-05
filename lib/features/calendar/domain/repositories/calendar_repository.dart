import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class CalendarRepository {
  Future<Either<ErrorModel, List<CalendarEventEntity>>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
    required CalendarViewType viewType,
    required String token,
  });
}
