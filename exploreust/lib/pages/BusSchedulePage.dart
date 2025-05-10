import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';

class BusSchedulePage extends StatefulWidget {
  const BusSchedulePage({super.key});

  @override
  State<BusSchedulePage> createState() => _BusSchedulePageState();
}

class _BusSchedulePageState extends State<BusSchedulePage> {
  List<Map<String, dynamic>> toCampus = [];
  List<Map<String, dynamic>> fromCampus = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusSchedules();
  }

  Future<void> _fetchBusSchedules() async {
    setState(() {
      loading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('bus_schedules').select();
      setState(() {
        toCampus = List<Map<String, dynamic>>.from(
          response.where((b) => b['direction'] == 'To Campus'),
        );
        fromCampus = List<Map<String, dynamic>>.from(
          response.where((b) => b['direction'] == 'From Campus'),
        );
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Error fetching bus schedules: $e');
    }
  }

  Widget _skeletonCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      margin: const EdgeInsets.only(bottom: 18),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 70,
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

  Widget _busCard(Map<String, dynamic> schedule) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: Icon(
          schedule['direction'] == 'To Campus'
              ? Icons.arrow_downward
              : Icons.arrow_upward,
          color:
              schedule['direction'] == 'To Campus' ? Colors.green : Colors.blue,
          size: 32,
        ),
        title: Text(
          schedule['route'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Days: ${(schedule['days'] as List?)?.join(', ') ?? 'N/A'}'),
            Text('Times: ${(schedule['times'] as List?)?.join(', ') ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final now = DateTime.now();
    final weekday =
        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][now.weekday - 1];
    final soonBuses = <Map<String, dynamic>>[];
    for (final sched in [...toCampus, ...fromCampus]) {
      final days = (sched['days'] as List?)?.cast<String>() ?? [];
      if (!days.contains(weekday)) continue;
      final times = (sched['times'] as List?)?.cast<String>() ?? [];
      for (final t in times) {
        final parts = t.split(':');
        if (parts.length != 2) continue;
        final busTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.tryParse(parts[0]) ?? 0,
          int.tryParse(parts[1]) ?? 0,
        );
        final diff = busTime.difference(now).inMinutes;
        if (diff >= 0 && diff <= 5) {
          soonBuses.add({
            'route': sched['route'],
            'direction': sched['direction'],
            'time': t,
          });
        }
      }
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Bus Schedules')),
      body: SafeArea(
        child:
            loading
                ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [_skeletonCard(), _skeletonCard(), _skeletonCard()],
                )
                : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Soon to Arrive Buses Alert
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child:
                            soonBuses.isEmpty
                                ? ListTile(
                                  leading: const Icon(
                                    Icons.directions_bus,
                                    color: Colors.indigo,
                                    size: 32,
                                  ),
                                  title: const Text(
                                    'Soon to Arrive Buses',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'No buses arriving in the next 5 minutes.',
                                  ),
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const ListTile(
                                      leading: Icon(
                                        Icons.warning,
                                        color: Colors.orange,
                                        size: 32,
                                      ),
                                      title: Text(
                                        'Soon to Arrive Buses',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Arriving within 5 minutes:',
                                      ),
                                    ),
                                    ...soonBuses.map(
                                      (bus) => ListTile(
                                        leading: Icon(
                                          bus['direction'] == 'To Campus'
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward,
                                          color:
                                              bus['direction'] == 'To Campus'
                                                  ? Colors.green
                                                  : Colors.blue,
                                        ),
                                        title: Text('${bus['route']}'),
                                        subtitle: Text('${bus['direction']}'),
                                        trailing: Text(
                                          bus['time'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'To Campus',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (toCampus.isEmpty)
                      const ListTile(title: Text('No schedules found.'))
                    else
                      ...toCampus.map(_busCard),
                    const SizedBox(height: 24),
                    Text(
                      'From Campus',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (fromCampus.isEmpty)
                      const ListTile(title: Text('No schedules found.'))
                    else
                      ...fromCampus.map(_busCard),
                  ],
                ),
      ),
    );
  }
}
