import 'package:flutter/material.dart';
import 'components/navigation_bar.dart';
import 'pages/Homepage.dart';
import 'pages/MapPage.dart';
import 'pages/EventsPage.dart';
import 'pages/ProfilePage.dart';
import 'pages/AllPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/SplashPage.dart';
import 'pages/AuthPage.dart';
import 'package:provider/provider.dart';
import 'app_settings_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://byhgngvrdzhhzedeqdsb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5aGduZ3ZyZHpoaHplZGVxZHNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MjAyNzAsImV4cCI6MjA2MDk5NjI3MH0.0LBPDXe-Wesm04EerxEZ88lLP8PUbM-KdMdFxNhyLa0',
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettingsController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsController>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF005AAA), // HKUST Blue
          onPrimary: Colors.white,
          secondary: Color(0xFFF9A825), // Golden Yellow
          onSecondary: Colors.black, // Dark Charcoal
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
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: const [Locale('en'), Locale('ko')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashPage(),
      routes: {
        '/home': (context) => const Homepage(),
        '/auth': (context) => const AuthPage(),
      },
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
