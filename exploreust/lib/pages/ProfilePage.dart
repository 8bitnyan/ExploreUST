import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/ClickyContainer.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const String userId = 'e6be865f-a429-4209-8e57-8c94789f4068';

  Map<String, dynamic>? userProfile;
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> bookmarks = [];
  List<Map<String, dynamic>> savedEvents = [];
  List<Map<String, dynamic>> linkedServices = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() {
      loading = true;
    });
    final supabase = Supabase.instance.client;
    try {
      final userResp =
          await supabase.from('users').select().eq('id', userId).single();
      final coursesResp = await supabase
          .from('courses')
          .select()
          .eq('user_id', userId);
      final bookmarksResp = await supabase
          .from('bookmarks')
          .select('*,location:location_id(*)')
          .eq('user_id', userId);
      final savedEventsResp = await supabase
          .from('saved_events')
          .select('*,event:event_id(*)')
          .eq('user_id', userId);
      final linkedResp = await supabase
          .from('linked_services')
          .select()
          .eq('user_id', userId);
      setState(() {
        userProfile = userResp;
        courses = List<Map<String, dynamic>>.from(coursesResp);
        bookmarks = List<Map<String, dynamic>>.from(bookmarksResp);
        savedEvents = List<Map<String, dynamic>>.from(savedEventsResp);
        linkedServices = List<Map<String, dynamic>>.from(linkedResp);
        loading = false;
      });
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() {
        loading = false;
      });
    }
  }

  Widget _skeletonCard({double height = 80}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      margin: const EdgeInsets.only(bottom: 18),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(width: 120, height: 12, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );

    if (loading) {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _skeletonCard(),
              _skeletonCard(),
              _skeletonCard(),
              _skeletonCard(height: 120),
              _skeletonCard(),
            ],
          ),
        ),
      );
    }

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
                    backgroundImage:
                        userProfile?['avatar_url'] != null
                            ? NetworkImage(userProfile!['avatar_url'])
                            : null,
                    child:
                        userProfile?['avatar_url'] == null
                            ? Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey.shade400,
                            )
                            : null,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile?['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Student ID: ${userProfile?['student_id'] ?? ''}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(userProfile?['program'] ?? ''),
                        const SizedBox(height: 2),
                        Text('Year ${userProfile?['year'] ?? ''}'),
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
                  subtitle: Text(
                    courses.isEmpty
                        ? 'No courses'
                        : courses.map((c) => c['code']).join(', '),
                  ),
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
                    subtitle: Text(
                      bookmarks.isEmpty
                          ? 'No bookmarks'
                          : bookmarks
                              .map((b) => b['location']?['name'])
                              .where((n) => n != null)
                              .join(', '),
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.deepPurple),
                    title: const Text('Saved Events'),
                    subtitle: Text(
                      savedEvents.isEmpty
                          ? 'No saved events'
                          : savedEvents
                              .map((e) => e['event']?['title'])
                              .where((t) => t != null)
                              .join(', '),
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                ClickyContainer(
                  onTap: () {},
                  child: ListTile(
                    leading: const Icon(Icons.link, color: Colors.blue),
                    title: const Text('Linked Services'),
                    subtitle: Text(
                      linkedServices.isEmpty
                          ? 'No linked services'
                          : linkedServices
                              .map((s) => s['service_name'])
                              .where((n) => n != null)
                              .join(', '),
                    ),
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
