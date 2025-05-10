import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> insertMockDataForDemoUser(BuildContext context) async {
  final supabase = Supabase.instance.client;
  const userId = 'e6be865f-a429-4209-8e57-8c94789f4068';
  try {
    // Insert mock locations
    final locations = [
      {
        'id': '11111111-1111-1111-1111-111111111111',
        'name': 'Library',
        'description': 'Study and resources',
        'lat': 22.3377,
        'lng': 114.2651,
        'type': 'Facility',
      },
      {
        'id': '22222222-2222-2222-2222-222222222222',
        'name': 'Academic Building',
        'description': 'Main teaching block',
        'lat': 22.3371,
        'lng': 114.2636,
        'type': 'Academic',
      },
    ];
    for (final loc in locations) {
      await supabase.from('locations').upsert(loc);
    }
    // Insert mock events
    final events = [
      {
        'id': '33333333-3333-3333-3333-333333333333',
        'title': 'AI Career Talk',
        'description': 'Talk on AI careers.',
        'date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'location_id': '22222222-2222-2222-2222-222222222222',
        'tags': ['Academic', 'Talk'],
        'organizer': 'Career Center',
        'speaker': 'Dr. Jane Smith',
        'agenda': 'Intro, Keynote, Q&A',
        'bookable': true,
        'cap': 150,
      },
    ];
    for (final event in events) {
      await supabase.from('events').upsert(event);
    }
    await supabase.from('users').upsert({
      'id': userId,
      'email': 'ykpark@connect.ust.hk',
      'name': 'You Kwang Park',
      'student_id': '20712623',
      'program': 'BEng in Computer Science',
      'year': 3,
      'avatar_url': null,
      'created_at': DateTime.now().toIso8601String(),
    });
    // Insert mock event booking
    await supabase.from('event_bookings').upsert({
      'event_id': '33333333-3333-3333-3333-333333333333',
      'user_id': userId,
      'booked_at': DateTime.now().toIso8601String(),
    });
    // Insert mock course
    await supabase.from('courses').upsert({
      'code': 'COMP4521',
      'name': 'Mobile App Dev',
      'instructor': 'Prof. Chan',
      'location': 'Room 1402',
      'schedule': '09:00 - 10:20',
      'user_id': userId,
    });
    // Insert mock bookmark
    await supabase.from('bookmarks').upsert({
      'user_id': userId,
      'location_id': '11111111-1111-1111-1111-111111111111',
      'created_at': DateTime.now().toIso8601String(),
    });
    // Insert mock saved event
    await supabase.from('saved_events').upsert({
      'user_id': userId,
      'event_id': '33333333-3333-3333-3333-333333333333',
      'created_at': DateTime.now().toIso8601String(),
    });
    // Insert mock linked service
    await supabase.from('linked_services').upsert({
      'user_id': userId,
      'service_name': 'Canvas',
      'linked_at': DateTime.now().toIso8601String(),
    });
    // Insert mock support request
    await supabase.from('support_requests').upsert({
      'user_id': userId,
      'type': 'Support',
      'message': 'How to use the app?',
      'created_at': DateTime.now().toIso8601String(),
      'status': 'Open',
    });
    if (context.mounted) {
      print('Mock data inserted successfully for user: $userId');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mock data inserted!')));
    }
  } catch (e, stack) {
    print('Error inserting mock data: $e');
    print(stack);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error inserting mock data: $e')));
    }
  }
}
