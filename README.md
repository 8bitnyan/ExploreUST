# ExploreUST

ExploreUST is a modern, feature-rich Flutter app designed for HKUST students. It provides seamless access to campus resources, events, academic tools, bus schedules, and more, all powered by a Supabase backend.

## Features

### 🔐 Authentication
- **Supabase Auth**: Secure login and registration using HKUST email addresses only (`@connect.ust.hk` or `@ust.hk`).
- **Splash Screen**: Auth state is checked on launch; users are routed to login or the main dashboard accordingly.

### 🏠 Homepage
- **Personalized Dashboard**: See your classes, announcements, bookmarks, saved events, linked services, and profile info.
- **Real-Time Weather**: Displays current weather at your location using OpenWeatherMap API and geolocator.
- **Quick Access**: Jump to frequently used campus tools and external HKUST services.

### 🗺️ Map Page
- **Interactive Campus Map**: Google Maps integration with real campus locations fetched from Supabase.
- **User Location**: Shows your current position and highlights the nearest campus building.
- **Bus Schedules**: View soon-to-arrive buses and access the full bus schedule.

### 🚌 Bus Schedule Page
- **Live Bus Info**: See all shuttle bus routes, directions, days, and times, with a special alert for buses arriving within 5 minutes.

### 📅 Events Page
- **Event Calendar**: TableCalendar view with event markers and badges for days with events.
- **Event Details**: Tap to view full event info, bookable seats, and book/cancel participation.
- **Upcoming Events**: Chronologically sorted list of all events.

### 👤 Profile Page
- **Student Info**: View your profile, academic summary, enrolled courses, GPA, and advisor.
- **Campus Tools**: Quick access to bookmarks, saved events, and linked services.
- **Support & Resources**: FAQs, contact support, and bug reporting.

### ⚙️ Settings Page
- **Account Management**: Change password, update email, manage profile picture, and log out.
- **Preferences**: Language, time format (12/24h), font size, dark mode, and notification settings.
- **Accessibility**: Toggle dark mode and adjust font size.
- **Support & Feedback**: Report bugs, suggest features, and access help resources.

### 🦴 Skeleton Loaders
- **Shimmer Effects**: All major pages use skeleton loaders for a smooth, modern loading experience.

### 🧪 Mock Data Tool
- **Demo Mode**: Insert mock data for a demo user for testing and development, including locations, events, courses, bookmarks, and more.

## Data & Backend

- **Supabase**: All user, event, location, bus, and support data is stored and managed in Supabase tables.
- **Schema**: Includes tables for users, events, locations, bus_schedules, courses, bookmarks, saved_events, linked_services, support_requests, lost_and_found, and announcements.
- **Real-Time Fetching**: All data is fetched live from Supabase, ensuring up-to-date information.

## Navigation

- **Dashboard**: Bottom navigation bar for Home, Map, Profile, Events, and All (comprehensive quick access).
- **AllPage**: Central hub for all campus tools, facilities, services, events, and utilities.

## Getting Started

1. **Clone the repository** and run `flutter pub get`.
2. **Set up Supabase**: Update the Supabase URL and anon key in `main.dart` if needed.
3. **Run the app**: `flutter run`
4. **(Optional) Insert mock data**: Use the mock data tool for demo/testing.

## Dependencies

- [Flutter](https://flutter.dev/)
- [Supabase Flutter](https://supabase.com/docs/guides/with-flutter)
- [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter)
- [TableCalendar](https://pub.dev/packages/table_calendar)
- [Shimmer](https://pub.dev/packages/shimmer)
- [Geolocator](https://pub.dev/packages/geolocator)
- [Provider](https://pub.dev/packages/provider)
- [Intl](https://pub.dev/packages/intl)
- [Badges](https://pub.dev/packages/badges)
- [http](https://pub.dev/packages/http)

## Customization

- **Theme**: HKUST branding with light/dark mode support.
- **Localization**: English and Korean supported (see `l10n/`).
- **Settings**: User preferences are stored in Supabase and reflected throughout the app.

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)

---

**ExploreUST** is your all-in-one companion for HKUST campus life.  
For questions or support, please use the in-app support features or contact the development team.

---

*This README was generated based on the current codebase and features as of June 2024.*
