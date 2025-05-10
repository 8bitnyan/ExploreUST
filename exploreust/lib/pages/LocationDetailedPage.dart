import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LocationDetailedPage extends StatefulWidget {
  final String name;
  final String desc;
  const LocationDetailedPage({
    super.key,
    required this.name,
    required this.desc,
  });

  @override
  State<LocationDetailedPage> createState() => _LocationDetailedPageState();
}

class _LocationDetailedPageState extends State<LocationDetailedPage> {
  bool loading = false;

  // Mock data
  final String imageUrl =
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80';
  final String openingHours = 'Mon-Fri: 8:00-22:00\nSat-Sun: 10:00-20:00';
  final List<String> facilities = [
    'Study Rooms',
    'Computer Terminals',
    'Printing Services',
    'Group Discussion Areas',
    'Cafe',
  ];
  final List<String> announcements = [
    'Library will close early on 1st July for maintenance.',
    'New books have arrived in the Science section!',
  ];

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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: SafeArea(
        child:
            loading
                ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _skeletonCard(height: 180),
                    _skeletonCard(),
                    _skeletonCard(),
                    _skeletonCard(),
                  ],
                )
                : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Image Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.12),
                      margin: const EdgeInsets.only(bottom: 18),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Name & Description
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.desc,
                      style: TextStyle(fontSize: 17, color: textColor),
                    ),
                    const SizedBox(height: 18),
                    // Opening Hours
                    Text(
                      'Opening Hours',
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
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                openingHours,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Facilities
                    Text(
                      'Facilities',
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
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              facilities
                                  .map(
                                    (f) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            f,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                    // Announcements
                    Text(
                      'Announcements',
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
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        children:
                            announcements
                                .map(
                                  (a) => ListTile(
                                    leading: const Icon(
                                      Icons.campaign,
                                      color: Colors.amber,
                                      size: 28,
                                    ),
                                    title: Text(a),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
