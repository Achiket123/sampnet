import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/calendar/data/data_sources/calendar_remote_data_source.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource remoteDataSource;

  CalendarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, List<CalendarEventEntity>>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
    required CalendarViewType viewType,
    required String token,
  }) async {
    try {
      final events = await remoteDataSource.getEvents(
        startDate: startDate,
        endDate: endDate,
        viewType: viewType,
      );
      return Right(events);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}
