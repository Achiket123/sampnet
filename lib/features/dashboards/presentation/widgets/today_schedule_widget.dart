import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/features/calendar/domain/use_cases/get_personal_calendar_usecase.dart';
import 'package:hackathon/features/calendar/domain/use_cases/get_team_calendar_usecase.dart';
import 'package:hackathon/features/projects/presentation/pages/project_detail_page.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';

class TodayScheduleWidget extends StatefulWidget {
  const TodayScheduleWidget({super.key});

  @override
  State<TodayScheduleWidget> createState() => _TodayScheduleWidgetState();
}

class _TodayScheduleWidgetState extends State<TodayScheduleWidget> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _todayEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchTodayEvents();
  }

  Future<void> _fetchTodayEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = getIt<User>();
      final token = user.token ?? '';
      if (token.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Authentication token not found.";
        });
        return;
      }

      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final personalFuture = getIt<GetPersonalCalendarUsecase>().call(
        startDate: startDate,
        endDate: endDate,
        token: token,
      );

      final teamFuture = getIt<GetTeamCalendarUsecase>().call(
        startDate: startDate,
        endDate: endDate,
        token: token,
      );

      final results = await Future.wait([personalFuture, teamFuture]);

      final personalResult = results[0];
      final teamResult = results[1];

      final List<Map<String, dynamic>> mergedEvents = [];

      personalResult.fold(
        (failure) => debugPrint("Failed to load personal events: ${failure.message}"),
        (events) {
          for (var e in events) {
            mergedEvents.add({
              'event': e,
              'source': 'Personal',
            });
          }
        },
      );

      teamResult.fold(
        (failure) => debugPrint("Failed to load team events: ${failure.message}"),
        (events) {
          for (var e in events) {
            // Check for duplicate entity ID to avoid listing the same event twice
            final exists = mergedEvents.any((m) =>
                (m['event'] as CalendarEventEntity).id == e.id &&
                (m['event'] as CalendarEventEntity).eventType == e.eventType);
            if (!exists) {
              mergedEvents.add({
                'event': e,
                'source': 'Team',
              });
            }
          }
        },
      );

      // Filter to ensure start time or end time overlaps with today
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

      final filtered = mergedEvents.where((item) {
        final event = item['event'] as CalendarEventEntity;
        // Event overlaps with today if startTime is before or equal to todayEnd and endTime is after or equal to todayStart
        return event.startTime.isBefore(todayEnd) && event.endTime.isAfter(todayStart);
      }).toList();

      // Sort by startTime
      filtered.sort((a, b) {
        final eventA = a['event'] as CalendarEventEntity;
        final eventB = b['event'] as CalendarEventEntity;
        return eventA.startTime.compareTo(eventB.startTime);
      });

      if (mounted) {
        setState(() {
          _todayEvents = filtered;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _showEventDetailsDialog(BuildContext context, CalendarEventEntity event, String source) {
    showDialog(
      context: context,
      builder: (context) {
        final startStr = DateFormat('MMMM d, yyyy h:mm a').format(event.startTime);
        final endStr = DateFormat('MMMM d, yyyy h:mm a').format(event.endTime);

        Color typeColor = ColorPallete.textSecondary;
        switch (event.eventType.toLowerCase()) {
          case 'task':
            typeColor = ColorPallete.redPrimary;
            break;
          case 'milestone':
            typeColor = ColorPallete.statusColor('pending');
            break;
          case 'leave':
            typeColor = ColorPallete.error;
            break;
          case 'attendance':
            typeColor = ColorPallete.statusColor('approved');
            break;
        }

        return Dialog(
          backgroundColor: ColorPallete.backgroundSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: typeColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            event.eventType.toUpperCase(),
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ColorPallete.textPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            source,
                            style: const TextStyle(
                              color: ColorPallete.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: ColorPallete.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: ColorPallete.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (event.description.isNotEmpty) ...[
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: ColorPallete.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
                Divider(color: ColorPallete.textPrimary.withOpacity(0.12)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: ColorPallete.textSecondary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Starts: $startStr",
                            style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 13),
                          ),
                          Text(
                            "Ends: $endStr",
                            style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: ColorPallete.textSecondary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Status: ${event.status}",
                      style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                if (event.assignedToName != null && event.assignedToName!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: ColorPallete.textSecondary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Assigned to: ${event.assignedToName}",
                        style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                if (event.eventType.toLowerCase() == 'task')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPallete.redPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/task-detail/${event.entityId}');
                      },
                      child: const Text("Go to Task Details", style: TextStyle(color: ColorPallete.textPrimary)),
                    ),
                  )
                else if (event.eventType.toLowerCase() == 'project' || event.eventType.toLowerCase() == 'project_deadline')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPallete.textSecondary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('${ProjectDetailPage.routePath}/${event.entityId}');
                      },
                      child: const Text("Go to Project Details", style: TextStyle(color: ColorPallete.textPrimary)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: ColorPallete.redPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Today's Schedule",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorPallete.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: ColorPallete.textSecondary, size: 20),
                onPressed: _fetchTodayEvents,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            _ShimmerSchedule()
          else if (_errorMessage != null)
            Center(
              child: Column(
                children: [
                  Text(
                    "Error loading schedule: $_errorMessage",
                    style: const TextStyle(color: ColorPallete.error, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _fetchTodayEvents,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          else if (_todayEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      color: ColorPallete.textPrimary.withOpacity(0.24),
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No schedule for today",
                      style: TextStyle(
                        color: ColorPallete.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _todayEvents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _todayEvents[index];
                final event = item['event'] as CalendarEventEntity;
                final source = item['source'] as String;

                Color typeColor = ColorPallete.textSecondary;
                switch (event.eventType.toLowerCase()) {
                  case 'task':
                    typeColor = ColorPallete.redPrimary;
                    break;
                  case 'milestone':
                    typeColor = ColorPallete.statusColor('pending');
                    break;
                  case 'leave':
                    typeColor = ColorPallete.error;
                    break;
                  case 'attendance':
                    typeColor = ColorPallete.statusColor('approved');
                    break;
                }

                final timeStr = "${DateFormat('hh:mm a').format(event.startTime)} - ${DateFormat('hh:mm a').format(event.endTime)}";

                return InkWell(
                  onTap: () {
                    if (event.eventType.toLowerCase() == 'task') {
                      context.push('/task-detail/${event.entityId}');
                    } else if (event.eventType.toLowerCase() == 'leave') {
                      context.push('/leave-management');
                    } else {
                      _showEventDetailsDialog(context, event, source);
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorPallete.backgroundTertiary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(color: typeColor, width: 4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  color: ColorPallete.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (event.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  event.description,
                                  style: const TextStyle(
                                    color: ColorPallete.textSecondary,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: ColorPallete.textPrimary.withOpacity(0.4),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      color: ColorPallete.textPrimary.withOpacity(0.6),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                event.eventType.toUpperCase(),
                                style: TextStyle(
                                  color: typeColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ColorPallete.textPrimary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                source,
                                style: const TextStyle(
                                  color: ColorPallete.textSecondary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ShimmerSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorPallete.backgroundTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: double.infinity,
                  color: ColorPallete.textPrimary.withOpacity(0.05),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 10,
                        decoration: BoxDecoration(
                          color: ColorPallete.textPrimary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 80,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ColorPallete.textPrimary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
