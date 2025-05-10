import 'package:flutter/material.dart';

class BusSchedulePage extends StatelessWidget {
  const BusSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus Schedules')),
      body: const Center(
        child: Text(
          'Bus Schedule Page Placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
