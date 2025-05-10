import 'package:flutter/material.dart';
import '../components/ClickyContainer.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  // Mock event data
  final List<Map<String, dynamic>> events = [
    {
      'title': 'AI Career Talk',
      'date': DateTime.now().add(const Duration(days: 1, hours: 2)),
      'location': 'LT-A',
      'tags': ['Academic', 'Talk'],
      'organizer': 'Career Center',
      'description':
          'Join us for an insightful talk on AI careers. Learn from industry experts and network with peers.',
      'speaker': 'Dr. Jane Smith',
      'agenda': 'Intro, Keynote, Q&A',
      'bookable': true,
      'booked': false,
      'seats': 120,
      'cap': 150,
    },
    {
      'title': 'Coding Club Hackathon',
      'date': DateTime.now().add(const Duration(days: 3)),
      'location': 'LG7 Common Room',
      'tags': ['Club', 'Workshop'],
      'organizer': 'Coding Club',
      'description':
          '24-hour hackathon with prizes and food. Form teams and build something cool!',
      'speaker': 'N/A',
      'agenda': 'Kickoff, Hacking, Demos',
      'bookable': true,
      'booked': true,
      'seats': 80,
      'cap': 100,
    },
    {
      'title': 'Public Art Tour',
      'date': DateTime.now().add(const Duration(days: 2, hours: 5)),
      'location': 'Atrium',
      'tags': ['Public', 'Tour'],
      'organizer': 'Art Society',
      'description': 'Explore campus art installations with a guided tour.',
      'speaker': 'Prof. Lee',
      'agenda': 'Tour, Q&A',
      'bookable': false,
      'booked': false,
      'seats': 0,
      'cap': 0,
    },
  ];

  String searchQuery = '';
  String filterType = 'All';
  String filterDate = 'All';
  String filterLocation = 'All';
  bool filterBookable = false;
  bool pushNotifications = true;

  List<Map<String, dynamic>> get filteredEvents {
    return events.where((event) {
        final matchesSearch =
            searchQuery.isEmpty ||
            event['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            event['tags'].any(
              (tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()),
            );
        final matchesType =
            filterType == 'All' || event['tags'].contains(filterType);
        final matchesBookable = !filterBookable || event['bookable'] == true;
        // Date filter (simple)
        final now = DateTime.now();
        bool matchesDate = true;
        if (filterDate == 'Today') {
          matchesDate =
              event['date'].day == now.day &&
              event['date'].month == now.month &&
              event['date'].year == now.year;
        } else if (filterDate == 'This Week') {
          final weekFromNow = now.add(const Duration(days: 7));
          matchesDate =
              event['date'].isAfter(now) && event['date'].isBefore(weekFromNow);
        }
        final matchesLocation =
            filterLocation == 'All' || event['location'] == filterLocation;
        return matchesSearch &&
            matchesType &&
            matchesDate &&
            matchesLocation &&
            matchesBookable;
      }).toList()
      ..sort((a, b) => a['date'].compareTo(b['date']));
  }

  List<Map<String, dynamic>> get myBookings =>
      events.where((e) => e['booked'] == true).toList();

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
                        event['title'],
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
                    Text('${event['date'].toLocal()}'.split('.')[0]),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.teal),
                    const SizedBox(width: 6),
                    Text(event['location']),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    ...event['tags']
                        .map<Widget>((tag) => Chip(label: Text(tag)))
                        .toList(),
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
                  event['description'],
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
                if (event['bookable']) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.event_seat, color: Colors.amber.shade700),
                      const SizedBox(width: 6),
                      Text('Seats: ${event['seats']} / ${event['cap']}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  event['booked']
                      ? ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check),
                        label: const Text('Booked'),
                      )
                      : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            event['booked'] = true;
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

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Top Row: Search, Notification Toggle, My Bookings
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search events... (name, tag, keyword)',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                    ),
                    onChanged: (v) => setState(() => searchQuery = v),
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: pushNotifications,
                  onChanged: (v) => setState(() => pushNotifications = v),
                  activeColor: Colors.deepPurple,
                ),
                const SizedBox(width: 4),
                const Text('Remind me'),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.event_available, color: Colors.teal),
                  tooltip: 'My Bookings',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'My Bookings',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (myBookings.isEmpty)
                                const Text('No bookings yet.'),
                              ...myBookings.map(
                                (event) => ClickyContainer(
                                  onTap: null,
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.event,
                                      color: Colors.deepPurple,
                                    ),
                                    title: Text(event['title']),
                                    subtitle: Text(
                                      '${event['date'].toLocal()}'.split(
                                        '.',
                                      )[0],
                                    ),
                                    trailing: TextButton(
                                      onPressed: () {
                                        // Cancel booking with warning
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  'Cancel Booking?',
                                                ),
                                                content: const Text(
                                                  'Are you sure? You may not be able to rebook after the deadline.',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        event['booked'] = false;
                                                      });
                                                      Navigator.pop(
                                                        context,
                                                      ); // close dialog
                                                      Navigator.pop(
                                                        context,
                                                      ); // close sheet
                                                    },
                                                    child: const Text(
                                                      'Yes, Cancel',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filter chips
            Wrap(
              spacing: 8,
              children: [
                DropdownButton<String>(
                  value: filterDate,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Dates')),
                    DropdownMenuItem(value: 'Today', child: Text('Today')),
                    DropdownMenuItem(
                      value: 'This Week',
                      child: Text('This Week'),
                    ),
                  ],
                  onChanged: (v) => setState(() => filterDate = v!),
                ),
                DropdownButton<String>(
                  value: filterType,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Types')),
                    DropdownMenuItem(value: 'Talk', child: Text('Talk')),
                    DropdownMenuItem(value: 'Club', child: Text('Club')),
                    DropdownMenuItem(
                      value: 'Academic',
                      child: Text('Academic'),
                    ),
                    DropdownMenuItem(
                      value: 'Workshop',
                      child: Text('Workshop'),
                    ),
                    DropdownMenuItem(value: 'Public', child: Text('Public')),
                  ],
                  onChanged: (v) => setState(() => filterType = v!),
                ),
                DropdownButton<String>(
                  value: filterLocation,
                  items: const [
                    DropdownMenuItem(
                      value: 'All',
                      child: Text('All Locations'),
                    ),
                    DropdownMenuItem(value: 'LT-A', child: Text('LT-A')),
                    DropdownMenuItem(
                      value: 'LG7 Common Room',
                      child: Text('LG7 Common Room'),
                    ),
                    DropdownMenuItem(value: 'Atrium', child: Text('Atrium')),
                  ],
                  onChanged: (v) => setState(() => filterLocation = v!),
                ),
                FilterChip(
                  label: const Text('Bookable Only'),
                  selected: filterBookable,
                  onSelected: (v) => setState(() => filterBookable = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Upcoming Events Feed
            Text(
              'Upcoming Events',
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
                      event['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${event['date'].toLocal()}'.split('.')[0]),
                        Text(event['location']),
                        Wrap(
                          spacing: 6,
                          children: [
                            ...event['tags']
                                .map<Widget>(
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
                        event['bookable']
                            ? (event['booked']
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
