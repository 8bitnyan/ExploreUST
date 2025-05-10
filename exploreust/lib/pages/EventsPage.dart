import 'package:flutter/material.dart';
import '../components/ClickyContainer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:badges/badges.dart' as badges;

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static const String userId = 'e6be865f-a429-4209-8e57-8c94789f4068';

  List<Map<String, dynamic>> events = [];
  Set<String> bookedEventIds = {};
  bool loading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      loading = true;
    });
    final supabase = Supabase.instance.client;
    try {
      final eventsResp = await supabase.from('events').select().order('date');
      final bookingsResp = await supabase
          .from('event_bookings')
          .select('event_id')
          .eq('user_id', userId);
      setState(() {
        events = List<Map<String, dynamic>>.from(eventsResp);
        bookedEventIds = Set<String>.from(
          bookingsResp.map((b) => b['event_id']),
        );
        loading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        loading = false;
      });
    }
  }

  // Map<DateTime, List<Map<String, dynamic>>> for eventLoader
  Map<DateTime, List<Map<String, dynamic>>> get _eventsByDay {
    final map = <DateTime, List<Map<String, dynamic>>>{};
    for (final event in events) {
      final eventDate = DateTime.tryParse(event['date'] ?? '');
      if (eventDate != null) {
        final day = DateTime(eventDate.year, eventDate.month, eventDate.day);
        map.putIfAbsent(day, () => []).add(event);
      }
    }
    return map;
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _eventsByDay[key] ?? [];
  }

  void showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      event['date'] != null
                          ? '${event['date']}'.split('.')[0]
                          : '',
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.teal),
                    const SizedBox(width: 6),
                    Text(event['location'] ?? ''),
                  ],
                ),
                const SizedBox(height: 10),
                if (event['tags'] != null && event['tags'] is List)
                  Wrap(
                    spacing: 8,
                    children: [
                      ...List<String>.from(
                        event['tags'],
                      ).map((tag) => Chip(label: Text(tag))),
                    ],
                  ),
                if (event['organizer'] != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.group,
                        size: 18,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 6),
                      Text('Organizer: ${event['organizer']}'),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  event['description'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                if (event['speaker'] != null && event['speaker'] != 'N/A')
                  Text(
                    'Speaker: ${event['speaker']}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                if (event['agenda'] != null) Text('Agenda: ${event['agenda']}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.map, color: Colors.green.shade700),
                    const SizedBox(width: 6),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View on Map'),
                    ),
                  ],
                ),
                if (event['bookable'] == true) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.event_seat, color: Colors.amber.shade700),
                      const SizedBox(width: 6),
                      Text(
                        'Seats: ${event['seats'] ?? 0} / ${event['cap'] ?? 0}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  bookedEventIds.contains(event['id'])
                      ? ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check),
                        label: const Text('Booked'),
                      )
                      : ElevatedButton(
                        onPressed: () async {
                          final supabase = Supabase.instance.client;
                          await supabase.from('event_bookings').upsert({
                            'event_id': event['id'],
                            'user_id': userId,
                            'booked_at': DateTime.now().toIso8601String(),
                          });
                          setState(() {
                            bookedEventIds.add(event['id']);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Book Now'),
                      ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Sort events by date ascending (chronological)
    events.sort((a, b) {
      final aDate = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2100);
      final bDate = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2100);
      return aDate.compareTo(bDate);
    });

    // Filter events by selected day
    final filteredEvents =
        _selectedDay == null ? events : _getEventsForDay(_selectedDay!);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Calendar View
            Card(
              shape: cardShape,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              margin: const EdgeInsets.only(bottom: 18),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(
                    _focusedDay.year,
                    _focusedDay.month,
                    1,
                  ),
                  lastDay: DateTime.utc(
                    _focusedDay.year,
                    _focusedDay.month + 1,
                    0,
                  ),
                  focusedDay: _focusedDay,
                  selectedDayPredicate:
                      (day) =>
                          _selectedDay != null &&
                          day.year == _selectedDay!.year &&
                          day.month == _selectedDay!.month &&
                          day.day == _selectedDay!.day,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: _getEventsForDay,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, eventsForDay) {
                      if (eventsForDay.isNotEmpty) {
                        return badges.Badge(
                          badgeContent: Text(
                            '${eventsForDay.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: Colors.deepPurple,
                            padding: const EdgeInsets.all(6),
                          ),
                          position: badges.BadgePosition.bottomEnd(
                            bottom: -8,
                            end: -8,
                          ),
                          child: const SizedBox.shrink(),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            // Events for selected day
            Text(
              'Events on ${_selectedDay != null ? "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}" : 'Selected Day'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            if (filteredEvents.isEmpty) const Text('No events found.'),
            ...filteredEvents.map(
              (event) => Card(
                shape: cardShape,
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.12),
                margin: const EdgeInsets.only(bottom: 14),
                child: ClickyContainer(
                  onTap: () => showEventDetails(event),
                  child: ListTile(
                    leading: const Icon(
                      Icons.event,
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                    title: Text(
                      event['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['date'] != null
                              ? '${event['date']}'.split('.')[0]
                              : '',
                        ),
                        Text(event['location'] ?? ''),
                        if (event['tags'] != null && event['tags'] is List)
                          Wrap(
                            spacing: 6,
                            children: [
                              ...List<String>.from(event['tags'])
                                  .map(
                                    (tag) => Chip(
                                      label: Text(tag),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        if (event['organizer'] != null)
                          Text(
                            'Organizer: ${event['organizer']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    trailing:
                        event['bookable'] == true
                            ? (bookedEventIds.contains(event['id'])
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : const Icon(
                                  Icons.event_available,
                                  color: Colors.amber,
                                ))
                            : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Upcoming Events (all)
            Text(
              'Upcoming Events',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            if (events.isEmpty) const Text('No events found.'),
            ...events.map(
              (event) => Card(
                shape: cardShape,
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.12),
                margin: const EdgeInsets.only(bottom: 14),
                child: ClickyContainer(
                  onTap: () => showEventDetails(event),
                  child: ListTile(
                    leading: const Icon(
                      Icons.event,
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                    title: Text(
                      event['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['date'] != null
                              ? '${event['date']}'.split('.')[0]
                              : '',
                        ),
                        Text(event['location'] ?? ''),
                        if (event['tags'] != null && event['tags'] is List)
                          Wrap(
                            spacing: 6,
                            children: [
                              ...List<String>.from(event['tags'])
                                  .map(
                                    (tag) => Chip(
                                      label: Text(tag),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        if (event['organizer'] != null)
                          Text(
                            'Organizer: ${event['organizer']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    trailing:
                        event['bookable'] == true
                            ? (bookedEventIds.contains(event['id'])
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : const Icon(
                                  Icons.event_available,
                                  color: Colors.amber,
                                ))
                            : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
