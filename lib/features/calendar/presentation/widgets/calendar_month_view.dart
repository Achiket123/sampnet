import 'package:flutter/material.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:intl/intl.dart';

class CalendarMonthView extends StatefulWidget {
  final List<CalendarEventEntity> events;
  final ValueChanged<CalendarEventEntity> onEventTapped;
  final CalendarViewType viewType;
  final Function(DateTime start, DateTime end) onMonthChanged;
  final ValueChanged<DateTime>? onCreateEventTapped;
  final ValueChanged<DateTime>? onDaySelected;

  const CalendarMonthView({
    super.key,
    required this.events,
    required this.onEventTapped,
    required this.viewType,
    required this.onMonthChanged,
    this.onCreateEventTapped,
    this.onDaySelected,
  });

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  late DateTime _currentMonth;
  late DateTime _selectedDay;
  late final ScrollController _timelineScrollController;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDay = DateTime.now();
    _timelineScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyMonthChanged();
      // Scroll to 08:00 AM on start
      if (_timelineScrollController.hasClients) {
        _timelineScrollController.animateTo(
          480, // Offset for 8:00 AM slots
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timelineScrollController.dispose();
    super.dispose();
  }

  void _notifyMonthChanged() {
    final visibleDays = _generateVisibleDays(_currentMonth);
    final start = visibleDays.first;
    final end = DateTime(visibleDays.last.year, visibleDays.last.month, visibleDays.last.day, 23, 59, 59);
    widget.onMonthChanged(start, end);
  }

  List<DateTime> _generateVisibleDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final int weekday = firstDayOfMonth.weekday; // 1 = Mon, 7 = Sun
    final int paddingDays = weekday - 1;
    final firstVisibleDay = firstDayOfMonth.subtract(Duration(days: paddingDays));
    return List.generate(42, (index) => firstVisibleDay.add(Duration(days: index)));
  }

  bool _isEventOnDay(CalendarEventEntity event, DateTime day) {
    final dayStart = DateTime(day.year, day.month, day.day);

    final startDay = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
    final endDay = DateTime(event.endTime.year, event.endTime.month, event.endTime.day);

    if (startDay.isAtSameMomentAs(endDay)) {
      return startDay.isAtSameMomentAs(dayStart);
    }

    return (dayStart.isAtSameMomentAs(startDay) || dayStart.isAfter(startDay)) &&
        (dayStart.isAtSameMomentAs(endDay) || dayStart.isBefore(endDay));
  }

  List<CalendarEventEntity> _getEventsForDay(DateTime day) {
    return widget.events.where((e) => _isEventOnDay(e, day)).toList();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
    _notifyMonthChanged();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
    _notifyMonthChanged();
  }

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'task':
        return Colors.blue;
      case 'meeting':
        return Colors.purple;
      case 'notification':
      case 'notifications':
        return Colors.teal;
      case 'appraisal':
      case 'appraisals':
        return Colors.pink;
      case 'milestone':
        return Colors.orange;
      case 'leave':
        return Colors.red;
      case 'attendance':
        return Colors.green;
      case 'project':
      case 'project_deadline':
        return Colors.cyan;
      default:
        return Colors.blueGrey;
    }
  }

  String _formatTime(DateTime dt) {
    return DateFormat('h:mm a').format(dt);
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat('MMMM yyyy').format(_currentMonth),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildWeekdaysHeader() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Center(child: Text('M', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        Center(child: Text('T', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        Center(child: Text('W', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        Center(child: Text('T', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        Center(child: Text('F', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        Center(child: Text('S', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        Center(child: Text('S', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildDaysGrid(List<DateTime> visibleDays) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPallete.blackSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.1,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 42,
        itemBuilder: (context, index) {
          final day = visibleDays[index];
          final isCurrentMonth = day.month == _currentMonth.month;
          final isToday = DateUtils.isSameDay(day, DateTime.now());
          final isSelected = DateUtils.isSameDay(day, _selectedDay);
          final dayEvents = _getEventsForDay(day);

          // Get unique event types for indicators
          final uniqueEventTypes = dayEvents.map((e) => e.eventType).toSet().toList();

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
              });
              if (widget.onDaySelected != null) {
                widget.onDaySelected!(day);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.red.withOpacity(0.2)
                    : isToday
                        ? Colors.white.withOpacity(0.05)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? Colors.red
                      : isToday
                          ? Colors.white.withOpacity(0.3)
                          : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: isCurrentMonth
                          ? Colors.white
                          : Colors.white.withOpacity(0.25),
                      fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: uniqueEventTypes.take(4).map((type) {
                      return Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getEventColor(type),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<CalendarEventEntity> selectedEvents) {
    // Generate 30-minute intervals for the selected day
    final slots = <DateTime>[];
    for (int hour = 0; hour < 24; hour++) {
      slots.add(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, hour, 0));
      slots.add(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, hour, 30));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Schedule for ${DateFormat('MMMM d, yyyy').format(_selectedDay)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Click slot to schedule",
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        
        Container(
          height: 450,
          decoration: BoxDecoration(
            color: ColorPallete.blackSecondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListView.builder(
              controller: _timelineScrollController,
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slotStart = slots[index];
                final slotEnd = slotStart.add(const Duration(minutes: 30));

                final slotEvents = selectedEvents.where((e) {
                  if (e.startTime.isAtSameMomentAs(e.endTime)) {
                    return (e.startTime.isAtSameMomentAs(slotStart) || e.startTime.isAfter(slotStart)) &&
                        e.startTime.isBefore(slotEnd);
                  }
                  return e.startTime.isBefore(slotEnd) && e.endTime.isAfter(slotStart);
                }).toList();

                return _buildTimelineSlot(context, slotStart, slotEvents);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSlot(BuildContext context, DateTime slotTime, List<CalendarEventEntity> slotEvents) {
    final timeStr = DateFormat('hh:mm a').format(slotTime);
    final isHour = slotTime.minute == 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time column
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            alignment: Alignment.topRight,
            child: Text(
              isHour ? timeStr : DateFormat(':mm').format(slotTime),
              style: TextStyle(
                color: isHour ? Colors.white70 : Colors.white38,
                fontSize: 11,
                fontWeight: isHour ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          // Divider between time and slot content
          Container(
            width: 1.5,
            color: Colors.white.withOpacity(0.08),
          ),
          // Slot content
          Expanded(
            child: slotEvents.isNotEmpty
                ? Column(
                    children: slotEvents.map((event) {
                      final themeColor = _getEventColor(event.eventType);
                      return GestureDetector(
                        onTap: () => widget.onEventTapped(event),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: themeColor.withOpacity(0.4)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      event.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: themeColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      event.eventType.toUpperCase(),
                                      style: TextStyle(
                                        color: themeColor,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (event.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  event.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                "${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.onCreateEventTapped != null) {
                          widget.onCreateEventTapped!(slotTime);
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Free Slot",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.12),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.white.withOpacity(0.12),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleDays = _generateVisibleDays(_currentMonth);
    final selectedEvents = _getEventsForDay(_selectedDay);
    final bool isWide = MediaQuery.of(context).size.width > 900;

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMonthHeader(),
                const SizedBox(height: 15),
                _buildWeekdaysHeader(),
                const SizedBox(height: 5),
                _buildDaysGrid(visibleDays),
              ],
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 4,
            child: _buildTimeline(context, selectedEvents),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMonthHeader(),
        const SizedBox(height: 15),
        _buildWeekdaysHeader(),
        const SizedBox(height: 5),
        _buildDaysGrid(visibleDays),
        const SizedBox(height: 25),
        _buildTimeline(context, selectedEvents),
      ],
    );
  }
}
