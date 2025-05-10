import 'package:flutter/material.dart';
import '../components/ClickyContainer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top Row: Customer Support and Settings
          Row(
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.support_agent, color: Colors.teal),
                onPressed: () {
                  // TODO: Implement customer support action
                },
                tooltip: 'Customer Support',
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                tooltip: 'Settings',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1. Student Info Block
          Card(
            shape: cardShape,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.12),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(
                      'assets/profile_placeholder.png',
                    ), // Replace with actual image asset or network
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Alex Chan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Student ID: 20712345',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text('BEng in Computer Science'),
                        SizedBox(height: 2),
                        Text('Year 3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 2. Academic Summary
          Text(
            'Academic Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: cardShape,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.12),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.menu_book,
                    color: Colors.blue,
                    size: 28,
                  ),
                  title: const Text('Enrolled Courses'),
                  subtitle: const Text('COMP4521, MATH1010, HUMA1000'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.grade,
                    color: Colors.amber,
                    size: 28,
                  ),
                  title: const Text('GPA'),
                  subtitle: const Text('3.67 / 4.3'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.green,
                    size: 28,
                  ),
                  title: const Text('Academic Advisor'),
                  subtitle: const Text('Prof. Lee (lee@ust.hk)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 3. Campus Tools Access
          Text(
            'Campus Tools',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: cardShape,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.12),
            child: Column(
              children: [
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(Icons.bookmark, color: Colors.red),
                    title: const Text('Bookmarked Locations'),
                    subtitle: const Text('LG7 Study Room, UniBistro'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.deepPurple),
                    title: const Text('Saved Events'),
                    subtitle: const Text('AI Seminar, Career Fair'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(Icons.link, color: Colors.blue),
                    title: const Text('Linked Services'),
                    subtitle: const Text('Canvas, Library, SIS'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 4. Support / Resources
          Text(
            'Support & Resources',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: cardShape,
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.12),
            child: Column(
              children: [
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(
                      Icons.help_outline,
                      color: Colors.green,
                    ),
                    title: const Text('FAQs'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(
                      Icons.support_agent,
                      color: Colors.teal,
                    ),
                    title: const Text('Contact Support / Feedback'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(Icons.bug_report, color: Colors.red),
                    title: const Text('Report a Bug / Request Feature'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy SettingsPage for navigation
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}
