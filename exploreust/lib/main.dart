import 'package:flutter/material.dart';
import 'components/navigation_bar.dart';
import 'pages/Homepage.dart';
import 'pages/MapPage.dart';
import 'pages/EventsPage.dart';
import 'pages/ProfilePage.dart';
import 'pages/AllPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploreUST',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF005AAA), // HKUST Blue
          onPrimary: Colors.white,
          secondary: Color(0xFFF9A825), // Golden Yellow
          onSecondary: Colors.black,
          background: Color(0xFFF5F5F5), // Light Grey
          onBackground: Color(0xFF212121), // Dark Charcoal
          surface: Colors.white, // Cards, content blocks
          onSurface: Color(0xFF212121), // Main text
          error: Color(0xFFD32F2F), // Red Accent
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Light Grey
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF005AAA), // HKUST Blue
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00897B), // Teal Green
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF212121)), // Dark Charcoal
          bodyMedium: TextStyle(color: Color(0xFF212121)),
          bodySmall: TextStyle(color: Color(0xFF757575)), // Medium Grey
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFF9A825), // Golden Yellow
        ),
        highlightColor: Color(
          0xFF00897B,
        ), // Teal Green for navigation/highlight
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const Homepage(),
    const MapPage(),
    const ProfilePage(),
    const EventsPage(),
    const AllPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
