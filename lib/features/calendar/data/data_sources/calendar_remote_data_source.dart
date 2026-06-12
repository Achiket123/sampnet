import 'dart:convert';
import 'package:hackathon/features/calendar/data/models/calendar_event_model.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';

abstract class CalendarRemoteDataSource {
  Future<List<CalendarEventModel>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
    required CalendarViewType viewType,
  });
}

class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  final ApiClient apiClient;

  CalendarRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CalendarEventModel>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
    required CalendarViewType viewType,
  }) async {
    final uri = Uri(
      path: '${ApiConstants.baseUrl}/calendar/events',
      queryParameters: {
        'start_date': startDate.toUtc().toIso8601String(),
        'end_date': endDate.toUtc().toIso8601String(),
        'view_type':
            viewType == CalendarViewType.personal ? 'personal' : 'team',
      },
    );
    final response = await apiClient
        .get("${ApiConstants.baseUrl}/calendar/events?${uri.query}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['events'] as List? ?? [];
      return list
          .map((json) =>
              CalendarEventModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } else {
      throw Exception('Failed to load calendar events: ${response.body}');
    }
  }
}
