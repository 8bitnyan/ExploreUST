import 'package:flutter/material.dart';
import '../components/quick_access.dart';
import '../components/ClickyIconButton.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Top Row: Weather, Canvas, Notification
            Row(
              children: [
                // Weather indicator
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '28°C',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // To Canvas button
                ClickyIconButton(icon: Icon(Icons.school), onPressed: () {}),
                const SizedBox(width: 10),
                // Notification icon
                ClickyIconButton(
                  icon: Icon(Icons.notifications_none_rounded),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 18),
            const QuickAccess(),
            const SizedBox(height: 18),
            // Classes of the Day Card
            Text(
              'Today\'s Classes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.class_,
                      color: Colors.blue,
                      size: 28,
                    ),
                    title: const Text('COMP4521 - Mobile App Dev'),
                    subtitle: const Text(
                      '09:00 - 10:20 | Room 1402 | Prof. Chan',
                    ),
                    trailing: ClickyIconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.class_,
                      color: Colors.green,
                      size: 28,
                    ),
                    title: const Text('MATH1010 - Calculus I'),
                    subtitle: const Text('11:00 - 12:20 | LT-A | Prof. Lee'),
                    trailing: ClickyIconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.class_,
                      color: Colors.deepPurple,
                      size: 28,
                    ),
                    title: const Text('HUMA1000 - Ethics'),
                    subtitle: const Text(
                      '14:00 - 15:20 | Room 2303 | Prof. Wong',
                    ),
                    trailing: ClickyIconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Next Location Shortcut
            Text(
              'Next Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              child: ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: Colors.teal,
                  size: 32,
                ),
                title: const Text(
                  'Your next class is in Room 1402, Lift 25-26',
                ),
                trailing: ClickyIconButton(
                  icon: Icon(Icons.schedule),
                  onPressed: () {},
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 18),

            // Announcements
            Text(
              'Latest Announcements',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              child: ListTile(
                leading: const Icon(
                  Icons.campaign,
                  color: Colors.amber,
                  size: 32,
                ),
                title: const Text('MATH1010 rescheduled to LT-A at 3PM'),
                subtitle: const Text(
                  'Academic notices, campus news, urgent alerts',
                ),
                trailing: ClickyIconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {},
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 18),

            // Event Highlights
            Text(
              'Event Highlights',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              child: ListTile(
                leading: const Icon(
                  Icons.event,
                  color: Colors.deepPurple,
                  size: 32,
                ),
                title: const Text('Happening Today: workshops, talks, meetups'),
                trailing: ClickyIconButton(
                  icon: Icon(Icons.event_available),
                  onPressed: () {},
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 18),

            // Canteen Menu Preview
            Text(
              'Canteen Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              child: ListTile(
                leading: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.green,
                  size: 32,
                ),
                title: const Text('LG7, UniBistro, etc.'),
                subtitle: const Text(
                  'Daily meal options, crowdedness, wait time',
                ),
                trailing: ClickyIconButton(
                  icon: Icon(Icons.restaurant),
                  onPressed: () {},
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 18),

            // Shuttle Bus Timings
            Text(
              'Shuttle Bus',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              child: ListTile(
                leading: const Icon(
                  Icons.directions_bus,
                  color: Colors.red,
                  size: 32,
                ),
                title: const Text('Next departure to/from HKUST'),
                trailing: ClickyIconButton(
                  icon: Icon(Icons.schedule),
                  onPressed: () {},
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 18),

            // Weather & Alerts
            Text(
              'Weather & Alerts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.12),
              child: ListTile(
                leading: const Icon(
                  Icons.wb_sunny,
                  color: Colors.orange,
                  size: 32,
                ),
                title: const Text('Plan commutes or outdoor events'),
                trailing: ClickyIconButton(
                  icon: Icon(Icons.cloud),
                  onPressed: () {},
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
