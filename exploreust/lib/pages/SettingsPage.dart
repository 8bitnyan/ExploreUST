import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/ClickyIconButton.dart';
import 'package:provider/provider.dart';
import '../app_settings_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String userId =
      'e6be865f-a429-4209-8e57-8c94789f4068'; // Replace with real user id

  bool loading = true;
  bool saving = false;
  String? error;

  // Settings fields
  String language = 'English';
  String timeFormat = '24h';
  String fontSize = 'System';
  bool notifyClasses = true;
  bool notifyEvents = true;
  bool notifyAnnouncements = false;
  bool darkMode = false;

  // User profile fields
  String? userName;
  String? userEmail;

  double get effectiveFontSize {
    switch (fontSize) {
      case 'Small':
        return 13.0;
      case 'Medium':
        return 16.0;
      case 'Large':
        return 20.0;
      default:
        return 15.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
    _fetchUserProfile();
  }

  Future<void> _fetchSettings() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final supabase = Supabase.instance.client;
      final resp =
          await supabase
              .from('user_settings')
              .select()
              .eq('user_id', userId)
              .maybeSingle();
      if (resp != null) {
        setState(() {
          language = resp['language'] ?? 'English';
          timeFormat = resp['time_format'] ?? '24h';
          fontSize = resp['font_size'] ?? 'System';
          notifyClasses = resp['notify_classes'] ?? true;
          notifyEvents = resp['notify_events'] ?? true;
          notifyAnnouncements = resp['notify_announcements'] ?? false;
          darkMode = resp['dark_mode'] ?? false;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load settings.';
        loading = false;
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final supabase = Supabase.instance.client;
      final resp =
          await supabase
              .from('users')
              .select('name, email')
              .eq('id', userId)
              .maybeSingle();
      if (resp != null) {
        setState(() {
          userName = resp['name'] ?? '';
          userEmail = resp['email'] ?? '';
        });
      }
    } catch (e) {
      // ignore error, keep mock if needed
    }
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    setState(() {
      saving = true;
    });
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('user_settings').upsert({
        'user_id': userId,
        key: value,
      });
      setState(() {
        saving = false;
        error = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Setting updated.')));
    } catch (e) {
      setState(() {
        saving = false;
        error = 'Failed to update setting.';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update setting.')));
    }
  }

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );
    final textTheme = Theme.of(context).textTheme;
    final appSettings = Provider.of<AppSettingsController>(
      context,
      listen: false,
    );
    return Theme(
      data: Theme.of(context).copyWith(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        textTheme: textTheme.apply(fontSizeFactor: effectiveFontSize / 15.0),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
          actions: [
            Tooltip(
              message: AppLocalizations.of(context)!.logout,
              child: ClickyIconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child:
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Top Row: User avatar, name, email
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/men/32.jpg',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userName == null
                                  ? Container(
                                    width: 100,
                                    height: 18,
                                    color: Colors.grey.shade300,
                                    margin: const EdgeInsets.only(bottom: 4),
                                  )
                                  : Text(
                                    userName!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20 * (effectiveFontSize / 15.0),
                                    ),
                                  ),
                              userEmail == null
                                  ? Container(
                                    width: 140,
                                    height: 14,
                                    color: Colors.grey.shade200,
                                  )
                                  : Text(
                                    userEmail!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14 * (effectiveFontSize / 15.0),
                                    ),
                                  ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // 1. Account Settings (no logic for now)
                      Text(
                        AppLocalizations.of(context)!.accountSettings,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * (effectiveFontSize / 15.0),
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: cardShape,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.12),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.lock_outline),
                              title: Text('Change password'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.email_outlined),
                              title: Text('Update email'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.account_circle_outlined,
                              ),
                              title: Text('Manage profile picture'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.redAccent,
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.logout,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                              onTap: () => _logout(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 32),

                      // 2. Language & Region
                      Text(
                        AppLocalizations.of(context)!.language,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * (effectiveFontSize / 15.0),
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: cardShape,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.12),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(
                                AppLocalizations.of(context)!.language,
                              ),
                              trailing: DropdownButton<String>(
                                value: language,
                                items: [
                                  DropdownMenuItem(
                                    value: 'English',
                                    child: Text(
                                      AppLocalizations.of(context)!.english,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '한국어',
                                    child: Text(
                                      AppLocalizations.of(context)!.korean,
                                    ),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => language = v);
                                    _updateSetting('language', v);
                                    // Update global locale
                                    Locale? locale;
                                    if (v == 'English') {
                                      locale = const Locale('en');
                                    } else if (v == '한국어')
                                      locale = const Locale('ko');
                                    appSettings.setLocale(locale);
                                  }
                                },
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.access_time),
                              title: Text(
                                AppLocalizations.of(context)!.dateTimeFormat,
                              ),
                              trailing: DropdownButton<String>(
                                value: timeFormat,
                                items: [
                                  DropdownMenuItem(
                                    value: '12h',
                                    child: Text(
                                      AppLocalizations.of(context)!.twelveHour,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '24h',
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.twentyFourHour,
                                    ),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => timeFormat = v);
                                    _updateSetting('time_format', v);
                                    appSettings.setTimeFormat(v);
                                  }
                                },
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.format_size),
                              title: Text(
                                AppLocalizations.of(context)!.fontSize,
                              ),
                              trailing: DropdownButton<String>(
                                value: fontSize,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Small',
                                    child: Text('Small'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Medium',
                                    child: Text('Medium'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Large',
                                    child: Text('Large'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'System',
                                    child: Text('System'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => fontSize = v);
                                    _updateSetting('font_size', v);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 32),

                      // 3. Notifications
                      Text(
                        AppLocalizations.of(context)!.notifications,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * (effectiveFontSize / 15.0),
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: cardShape,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.12),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          children: [
                            SwitchListTile(
                              secondary: const Icon(Icons.class_),
                              title: Text('Class reminders'),
                              value: notifyClasses,
                              onChanged: (v) {
                                setState(() => notifyClasses = v);
                                _updateSetting('notify_classes', v);
                              },
                            ),
                            SwitchListTile(
                              secondary: const Icon(Icons.event),
                              title: Text('Event reminders'),
                              value: notifyEvents,
                              onChanged: (v) {
                                setState(() => notifyEvents = v);
                                _updateSetting('notify_events', v);
                              },
                            ),
                            SwitchListTile(
                              secondary: const Icon(Icons.campaign),
                              title: Text('New announcements'),
                              value: notifyAnnouncements,
                              onChanged: (v) {
                                setState(() => notifyAnnouncements = v);
                                _updateSetting('notify_announcements', v);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.nightlight_round),
                              title: Text('Set quiet hours'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 32),

                      // 4. Accessibility Options (only dark mode for now)
                      Text(
                        AppLocalizations.of(context)!.accessibilityOptions,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * (effectiveFontSize / 15.0),
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: cardShape,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.12),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          children: [
                            SwitchListTile(
                              secondary: const Icon(Icons.dark_mode),
                              title: Text(
                                AppLocalizations.of(context)!.darkMode,
                              ),
                              value: darkMode,
                              onChanged: (v) {
                                setState(() => darkMode = v);
                                _updateSetting('dark_mode', v);
                                appSettings.setThemeMode(
                                  v ? ThemeMode.dark : ThemeMode.light,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 32),

                      // 5. General (no logic for now)
                      Text(
                        AppLocalizations.of(context)!.general,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * (effectiveFontSize / 15.0),
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: cardShape,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.12),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.color_lens),
                              title: Text('Theme'),
                              trailing: DropdownButton<String>(
                                value: darkMode ? 'Dark' : 'Light',
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Light',
                                    child: Text('Light'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Dark',
                                    child: Text('Dark'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'System',
                                    child: Text('System default'),
                                  ),
                                ],
                                onChanged: (v) {},
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.cleaning_services),
                              title: Text('Clear cache / storage'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.refresh),
                              title: Text('Reset settings'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 32),

                      // 6. Support & Feedback (no logic for now)
                      Text(
                        AppLocalizations.of(context)!.supportFeedback,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * (effectiveFontSize / 15.0),
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: cardShape,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.12),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.bug_report,
                                color: Colors.red,
                              ),
                              title: Text('Report a bug'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.lightbulb_outline,
                                color: Colors.amber,
                              ),
                              title: Text('Suggest a feature'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.help_outline,
                                color: Colors.blue,
                              ),
                              title: Text('FAQ / Help Center'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.support_agent,
                                color: Colors.teal,
                              ),
                              title: Text('Contact support'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
        ),
      ),
    );
  }
}
