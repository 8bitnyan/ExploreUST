import 'package:flutter/material.dart';
import '../components/ClickyIconButton.dart';
import '../components/ClickyContainer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/mock_data_tool.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );

    Widget optionTile({
      required IconData icon,
      required String title,
      String? subtitle,
      VoidCallback? onTap,
      Color? iconColor,
    }) {
      return ClickyContainer(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, size: 28, color: iconColor),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: const Icon(Icons.chevron_right),
        ),
      );
    }

    Widget sectorCard({required List<Widget> children}) {
      return Card(
        shape: cardShape,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.12),
        margin: const EdgeInsets.only(bottom: 18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: children),
        ),
      );
    }

    Widget quickAccessCard({
      required IconData icon,
      required String title,
      VoidCallback? onTap,
    }) {
      return ClickyContainer(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // DEV: Insert mock data button (only in debug mode)
            if (!bool.fromEnvironment('dart.vm.product'))
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bug_report, color: Colors.red),
                  label: const Text('Insert Mock Data for Demo User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => insertMockDataForDemoUser(context),
                ),
              ),
            // Top Row: User name and action buttons
            Row(
              children: [
                const Text(
                  'Alex Paul',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const Spacer(),
                ClickyIconButton(
                  icon: const Icon(Icons.search, color: Colors.blueAccent),
                  onPressed: () {},
                ),
                ClickyIconButton(
                  icon: const Icon(Icons.support_agent, color: Colors.teal),
                  onPressed: () {},
                ),
                ClickyIconButton(
                  icon: const Icon(Icons.settings, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Frequently Used Section (optional)
            Text(
              'Frequently Used',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            sectorCard(
              children: [
                optionTile(
                  icon: Icons.calendar_today,
                  title: 'Course Schedule',
                  iconColor: Colors.blue,
                ),
                optionTile(
                  icon: Icons.map,
                  title: 'Campus Map',
                  iconColor: Colors.brown,
                ),
              ],
            ),

            // Academic Tools
            Text(
              'Academic Tools',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            sectorCard(
              children: [
                optionTile(
                  icon: Icons.calendar_today,
                  title: 'Course Schedule',
                  iconColor: Colors.blue,
                ),
                optionTile(
                  icon: Icons.schedule,
                  title: 'Exam Timetable',
                  iconColor: Colors.deepPurple,
                ),
                optionTile(
                  icon: Icons.calculate,
                  title: 'GPA Calculator',
                  iconColor: Colors.orange,
                ),
                optionTile(
                  icon: Icons.event_note,
                  title: 'Academic Calendar',
                  iconColor: Colors.teal,
                ),
                optionTile(
                  icon: Icons.school,
                  title: 'Canvas / SIS Links',
                  iconColor: Colors.redAccent,
                ),
              ],
            ),

            // Campus Facilities
            Text(
              'Campus Facilities',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            sectorCard(
              children: [
                optionTile(
                  icon: Icons.local_library,
                  title: 'Library',
                  iconColor: Colors.green,
                ),
                optionTile(
                  icon: Icons.meeting_room,
                  title: 'Study Rooms',
                  iconColor: Colors.cyan,
                ),
                optionTile(
                  icon: Icons.science,
                  title: 'Labs & Lecture Theatres',
                  iconColor: Colors.amber,
                ),
                optionTile(
                  icon: Icons.directions_bus,
                  title: 'Shuttle Bus Info',
                  iconColor: Colors.indigo,
                ),
                optionTile(
                  icon: Icons.map,
                  title: 'Campus Map',
                  iconColor: Colors.brown,
                ),
              ],
            ),

            // Student Services
            Text(
              'Student Services',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            sectorCard(
              children: [
                optionTile(
                  icon: Icons.attach_money,
                  title: 'Financial Aid / Scholarships',
                  iconColor: Colors.pink,
                ),
                optionTile(
                  icon: Icons.health_and_safety,
                  title: 'Health & Counseling',
                  iconColor: Colors.lightGreen,
                ),
                optionTile(
                  icon: Icons.business_center,
                  title: 'Career Center',
                  iconColor: Colors.deepOrange,
                ),
                optionTile(
                  icon: Icons.work,
                  title: 'Internship/Job Portal',
                  iconColor: Colors.blueGrey,
                ),
              ],
            ),

            // Events & Clubs
            Text(
              'Events & Clubs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            sectorCard(
              children: [
                optionTile(
                  icon: Icons.groups,
                  title: 'Club Directory',
                  iconColor: Colors.purple,
                ),
                optionTile(
                  icon: Icons.account_balance,
                  title: 'Student Union Info',
                  iconColor: Colors.lime,
                ),
                optionTile(
                  icon: Icons.event,
                  title: 'Bookable Event List',
                  iconColor: Colors.deepPurpleAccent,
                ),
                optionTile(
                  icon: Icons.event_available,
                  title: 'My Bookings',
                  iconColor: Colors.teal,
                ),
              ],
            ),

            // Utilities
            Text(
              'Utilities',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            sectorCard(
              children: [
                optionTile(
                  icon: Icons.find_in_page,
                  title: 'Lost & Found',
                  iconColor: Colors.indigoAccent,
                ),
                optionTile(
                  icon: Icons.restaurant_menu,
                  title: 'Cafeteria Menus',
                  iconColor: Colors.red,
                ),
                optionTile(
                  icon: Icons.print,
                  title: 'Printer Locations',
                  iconColor: Colors.grey,
                ),
                optionTile(
                  icon: Icons.warning,
                  title: 'Emergency Contacts',
                  iconColor: Colors.redAccent,
                ),
                optionTile(
                  icon: Icons.wb_sunny,
                  title: 'Weather',
                  iconColor: Colors.lightBlue,
                ),
              ],
            ),

            // Quick Access to External Sites
            Text(
              'Quick Access',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: cardShape,
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.12),
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  quickAccessCard(
                    icon: Icons.language,
                    title: 'HKUST Official Website',
                  ),
                  quickAccessCard(icon: Icons.school, title: 'Canvas'),
                  quickAccessCard(
                    icon: Icons.account_box,
                    title: 'SIS (Student Info System)',
                  ),
                  quickAccessCard(
                    icon: Icons.local_library,
                    title: 'Library Portal',
                  ),
                  quickAccessCard(
                    icon: Icons.computer,
                    title: 'eLearning Resources',
                  ),
                  quickAccessCard(icon: Icons.email, title: 'Email'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
