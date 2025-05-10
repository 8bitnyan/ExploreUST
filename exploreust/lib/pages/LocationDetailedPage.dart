import 'package:flutter/material.dart';

class LocationDetailedPage extends StatelessWidget {
  final String name;
  final String desc;
  const LocationDetailedPage({
    super.key,
    required this.name,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(desc, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
