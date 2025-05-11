import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/quick_access.dart';
import '../components/ClickyIconButton.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../app_settings_controller.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Demo user id
  static const String userId = 'e6be865f-a429-4209-8e57-8c94789f4068';

  Map<String, dynamic>? userProfile;
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> announcements = [];
  List<Map<String, dynamic>> bookmarks = [];
  List<Map<String, dynamic>> savedEvents = [];
  List<Map<String, dynamic>> linkedServices = [];
  bool loading = true;
  double? _temperature;
  String? _weatherIcon;
  bool _weatherLoading = true;

  Icon _courseIcon(String? code) {
    if (code == null) {
      return const Icon(Icons.class_, color: Colors.grey, size: 28);
    }
    if (code.startsWith('COMP')) {
      return const Icon(Icons.computer, color: Colors.blue, size: 28);
    } else if (code.startsWith('MATH')) {
      return const Icon(Icons.calculate, color: Colors.green, size: 28);
    } else if (code.startsWith('HUMA')) {
      return const Icon(Icons.menu_book, color: Colors.deepPurple, size: 28);
    }
    return const Icon(Icons.class_, color: Colors.grey, size: 28);
  }

  Icon _locationIcon(String? type) {
    switch (type) {
      case 'Facility':
        return const Icon(Icons.local_library, color: Colors.green);
      case 'Academic':
        return const Icon(Icons.school, color: Colors.blue);
      case 'Residence':
        return const Icon(Icons.home, color: Colors.orange);
      case 'Canteen':
        return const Icon(Icons.restaurant, color: Colors.red);
      default:
        return const Icon(Icons.place, color: Colors.grey);
    }
  }

  Icon _eventIcon(List? tags) {
    if (tags == null) return const Icon(Icons.event, color: Colors.deepPurple);
    if (tags.contains('Sports')) {
      return const Icon(Icons.sports_soccer, color: Colors.green);
    }
    if (tags.contains('Music')) {
      return const Icon(Icons.music_note, color: Colors.pink);
    }
    if (tags.contains('Academic')) {
      return const Icon(Icons.school, color: Colors.blue);
    }
    if (tags.contains('Food')) {
      return const Icon(Icons.restaurant, color: Colors.red);
    }
    return const Icon(Icons.event, color: Colors.deepPurple);
  }

  Icon _serviceIcon(String? name) {
    switch (name?.toLowerCase()) {
      case 'canvas':
        return const Icon(Icons.school, color: Colors.blue);
      case 'library':
        return const Icon(Icons.local_library, color: Colors.green);
      case 'sis':
        return const Icon(Icons.account_box, color: Colors.orange);
      case 'email':
        return const Icon(Icons.email, color: Colors.red);
      default:
        return const Icon(Icons.link, color: Colors.grey);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllData();
    _fetchWeather();
  }

  Future<void> _fetchAllData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    final supabase = Supabase.instance.client;
    try {
      final userResp =
          await supabase.from('users').select().eq('id', userId).single();
      final coursesResp = await supabase
          .from('courses')
          .select()
          .eq('user_id', userId);
      final annResp = await supabase
          .from('announcements')
          .select()
          .order('created_at', ascending: false)
          .limit(3);
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
      if (mounted) {
        setState(() {
          userProfile = userResp;
          courses = List<Map<String, dynamic>>.from(coursesResp);
          announcements = List<Map<String, dynamic>>.from(annResp);
          bookmarks = List<Map<String, dynamic>>.from(bookmarksResp);
          savedEvents = List<Map<String, dynamic>>.from(savedEventsResp);
          linkedServices = List<Map<String, dynamic>>.from(linkedResp);
          loading = false;
        });
      }
    } catch (e) {
      print('Error fetching homepage data: $e');
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _fetchWeather() async {
    if (mounted) {
      setState(() {
        _weatherLoading = true;
      });
    }
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _weatherLoading = false;
            });
          }
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      final lat = position.latitude;
      final lon = position.longitude;
      const apiKey =
          '9093d832e8e3629dfc55108478b4703a'; // <-- Replace with your API key
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _temperature = data['main']['temp']?.toDouble();
            _weatherIcon = data['weather'][0]['icon'];
            _weatherLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _weatherLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _weatherLoading = false;
        });
      }
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

  String formatTime(String time, BuildContext context) {
    final timeFormat = Provider.of<AppSettingsController>(context).timeFormat;
    // Assume time is in 'HH:mm' format
    final parts = time.split(':');
    if (parts.length != 2) return time;
    final dt = DateTime(
      2000,
      1,
      1,
      int.tryParse(parts[0]) ?? 0,
      int.tryParse(parts[1]) ?? 0,
    );
    if (timeFormat == '12h') {
      return DateFormat('hh:mm a').format(dt);
    } else {
      return DateFormat('HH:mm').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Top Row: Weather, Canvas, Notification
            Row(
              children: [
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
                    children: [
                      if (_weatherLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (_weatherIcon != null && _temperature != null)
                        Row(
                          children: [
                            Image.network(
                              'https://openweathermap.org/img/wn/${_weatherIcon!}@2x.png',
                              width: 28,
                              height: 28,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_temperature!.round()}°C',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: const [
                            Icon(
                              Icons.wb_sunny,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'N/A',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                ClickyIconButton(icon: Icon(Icons.school), onPressed: () {}),
                const SizedBox(width: 10),
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
              "Today's Classes",
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
              child:
                  courses.isEmpty
                      ? const ListTile(title: Text('No classes today'))
                      : Column(
                        children:
                            courses
                                .map(
                                  (course) => ListTile(
                                    leading: _courseIcon(course['code']),
                                    title: Text(
                                      '${course['code']} - ${course['name']}',
                                    ),
                                    subtitle: Text(
                                      '${formatTime(course['schedule'].split(" - ")[0], context)} - ${formatTime(course['schedule'].split(" - ")[1], context)} | ${course['location']} | ${course['instructor']}',
                                    ),
                                    trailing: ClickyIconButton(
                                      icon: Icon(Icons.map),
                                      onPressed: () {},
                                    ),
                                  ),
                                )
                                .toList(),
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
              child:
                  announcements.isEmpty
                      ? const ListTile(title: Text('No announcements'))
                      : Column(
                        children:
                            announcements
                                .map(
                                  (a) => ListTile(
                                    leading: const Icon(
                                      Icons.campaign,
                                      color: Colors.amber,
                                      size: 32,
                                    ),
                                    title: Text(a['title'] ?? ''),
                                    subtitle: Text(a['content'] ?? ''),
                                  ),
                                )
                                .toList(),
                      ),
            ),
            const SizedBox(height: 18),
            // Bookmarked Locations
            Text(
              'Bookmarked Locations',
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
              child:
                  bookmarks.isEmpty
                      ? const ListTile(title: Text('No bookmarks'))
                      : Column(
                        children:
                            bookmarks
                                .map(
                                  (b) => ListTile(
                                    leading: _locationIcon(
                                      b['location']?['type'],
                                    ),
                                    title: Text(b['location']?['name'] ?? ''),
                                    subtitle: Text(
                                      b['location']?['description'] ?? '',
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
            ),
            const SizedBox(height: 18),
            // Saved Events
            Text(
              'Saved Events',
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
              child:
                  savedEvents.isEmpty
                      ? const ListTile(title: Text('No saved events'))
                      : Column(
                        children:
                            savedEvents
                                .map(
                                  (e) => ListTile(
                                    leading: _eventIcon(e['event']?['tags']),
                                    title: Text(e['event']?['title'] ?? ''),
                                    subtitle: Text(
                                      e['event']?['description'] ?? '',
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
            ),
            const SizedBox(height: 18),
            // Linked Services
            Text(
              'Linked Services',
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
              child:
                  linkedServices.isEmpty
                      ? const ListTile(title: Text('No linked services'))
                      : Column(
                        children:
                            linkedServices
                                .map(
                                  (s) => ListTile(
                                    leading: _serviceIcon(s['service_name']),
                                    title: Text(s['service_name'] ?? ''),
                                    subtitle: Text(
                                      'Linked at: ${s['linked_at'] ?? ''}',
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
            ),
            const SizedBox(height: 18),
            // Profile Info
            Text(
              'Profile Info',
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
              child:
                  userProfile == null
                      ? const ListTile(title: Text('No profile info'))
                      : ListTile(
                        leading: const Icon(Icons.person, color: Colors.green),
                        title: Text(userProfile?['name'] ?? ''),
                        subtitle: Text(
                          'Student ID: ${userProfile?['student_id'] ?? ''}\nProgram: ${userProfile?['program'] ?? ''}\nYear: ${userProfile?['year'] ?? ''}',
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
