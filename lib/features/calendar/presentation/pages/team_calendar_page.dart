import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/features/calendar/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:hackathon/features/calendar/presentation/blocs/calendar_bloc/calendar_event.dart';
import 'package:hackathon/features/calendar/presentation/blocs/calendar_bloc/calendar_state.dart';
import 'package:hackathon/features/calendar/presentation/widgets/calendar_month_view.dart';
import 'package:hackathon/features/calendar/presentation/widgets/create_event_dialog.dart';
import 'package:hackathon/features/calendar/presentation/pages/personal_calendar_page.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/features/projects/presentation/pages/project_detail_page.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:hackathon/widgets/custom_drawer.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';
import 'package:intl/intl.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
final GlobalKey<ScaffoldState> _teamCalendarPageKey = GlobalKey<ScaffoldState>();

class TeamCalendarPage extends StatefulWidget {
  static const String routePath = '/calendar/team';
  static const String routeName = 'calendar_team';

  const TeamCalendarPage({super.key});

  @override
  State<TeamCalendarPage> createState() => _TeamCalendarPageState();
}

class _TeamCalendarPageState extends State<TeamCalendarPage> {
   late final CalendarBloc _calendarBloc;
  List<CalendarEventEntity> _cachedEvents = [];
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarBloc = getIt<CalendarBloc>();
  }

  @override
  void dispose() {
    _calendarBloc.close();
    super.dispose();
  }
  void _showEventDetailsDialog(BuildContext context, CalendarEventEntity event) {
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
          case 'project':
          case 'project_deadline':
            typeColor = ColorPallete.textSecondary;
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final token = getIt<User>().token ?? '';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: BlocProvider.value(
        value: _calendarBloc,
        child: BlocListener<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state is CalendarNavigationState) {
              if (state.event.eventType.toLowerCase() == 'task') {
                context.push('/task-detail/${state.event.entityId}');
              } else if (state.event.eventType.toLowerCase() == 'leave') {
                context.push('/leave-management');
              } else {
                _showEventDetailsDialog(context, state.event);
              }
            }
          },
          child: Scaffold(
            key: _teamCalendarPageKey,
            drawer: CustomDrawer(
              selectedIndex: ListOfSideBar.sideBarItems.indexOf('Calendar'),
            ),
            backgroundColor: ColorPallete.transparent,
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorPallete.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CreateEventDialog(
                    initialDateTime: _selectedDay,
                    token: token,
                    viewType: CalendarViewType.team,
                    onSuccess: () {
                      final focusedDate = _selectedDay;
                      final start = DateTime(focusedDate.year, focusedDate.month, 1).subtract(const Duration(days: 7));
                      final end = DateTime(focusedDate.year, focusedDate.month + 1, 1).add(const Duration(days: 7));
                      _calendarBloc.add(LoadCalendarEvents(
                            startDate: start,
                            endDate: end,
                            viewType: CalendarViewType.team,
                            token: token,
                          ));
                    },
                  ),
                );
              },
              child: const Icon(Icons.add, color: ColorPallete.textPrimary),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
              ),
              children: [
                _appBar(context),
                const SizedBox(height: 20),
                BlocBuilder<CalendarBloc, CalendarState>(
                  bloc: _calendarBloc,
                  buildWhen: (previous, current) => current is! CalendarNavigationState,
                  builder: (context, state) {
                    if (state is CalendarError) {
                      return SizedBox(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(color: ColorPallete.error, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                final now = DateTime.now();
                                final start = DateTime(now.year, now.month, 1).subtract(const Duration(days: 7));
                                final end = DateTime(now.year, now.month + 1, 1).add(const Duration(days: 7));
                                _calendarBloc.add(LoadCalendarEvents(
                                      startDate: start,
                                      endDate: end,
                                      viewType: CalendarViewType.team,
                                      token: token,
                                    ));
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is CalendarLoaded) {
                      _cachedEvents = state.events;
                    }
                    final bool isLoading = state is CalendarLoading;

                    return Stack(
                      children: [
                        CalendarMonthView(
                          events: _cachedEvents,
                          viewType: CalendarViewType.team,
                          onEventTapped: (event) {
                            _calendarBloc.add(EventTapped(event: event));
                          },
                          onMonthChanged: (start, end) {
                            _calendarBloc.add(LoadCalendarEvents(
                                  startDate: start,
                                  endDate: end,
                                  viewType: CalendarViewType.team,
                                  token: token,
                                ));
                          },
                          onDaySelected: (day) {
                            setState(() {
                              _selectedDay = day;
                            });
                          },
                          onCreateEventTapped: (dateTime) {
                            showDialog(
                              context: context,
                              builder: (context) => CreateEventDialog(
                                initialDateTime: dateTime,
                                token: token,
                                viewType: CalendarViewType.team,
                                onSuccess: () {
                                  // Refresh calendar events
                                  final focusedDate = state is CalendarLoaded 
                                      ? state.focusedDate 
                                      : DateTime.now();
                                  final start = DateTime(focusedDate.year, focusedDate.month, 1).subtract(const Duration(days: 7));
                                  final end = DateTime(focusedDate.year, focusedDate.month + 1, 1).add(const Duration(days: 7));
                                  _calendarBloc.add(LoadCalendarEvents(
                                        startDate: start,
                                        endDate: end,
                                        viewType: CalendarViewType.team,
                                        token: token,
                                      ));
                                },
                              ),
                            );
                          },
                        ),
                        if (isLoading)
                          Positioned.fill(
                            child: Container(
                              color: ColorPallete.textSecondary.withOpacity(0.25),
                              child: const Center(
                                child: CircularProgressIndicator(color: ColorPallete.error),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return CustomAppBar(
      callback: () {
        context.pushReplacement(Dashboard.routePath);
      },
      children: [
        const SizedBox(width: 8),
        Text(
          'TEAM CALENDAR',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: ColorPallete.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            context.go(PersonalCalendarPage.routePath);
          },
          icon: const Icon(Icons.person, color: ColorPallete.textPrimary),
          label: const Text(
            "Personal View",
            style: TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
