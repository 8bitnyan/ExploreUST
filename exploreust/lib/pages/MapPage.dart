import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/ClickyIconButton.dart';
import 'package:geolocator/geolocator.dart';
import 'BusSchedulePage.dart';
import 'LocationDetailedPage.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  int _busTabIndex = 0;
  LatLng? _userLocation;
  String? _currentLocationName;
  String? _selectedPath;
  String? _selectedMarkerName;
  final GlobalKey _busScheduleKey = GlobalKey();

  // HKUST campus center
  static const LatLng _hkustCenter = LatLng(22.3364, 114.2654);

  // Mock campus locations
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Academic Building',
      'position': LatLng(22.3371, 114.2636),
      'desc': 'Main teaching block',
    },
    {
      'name': 'Library',
      'position': LatLng(22.3377, 114.2651),
      'desc': 'Study and resources',
    },
    {
      'name': 'Student Hall',
      'position': LatLng(22.3352, 114.2672),
      'desc': 'Student residence',
    },
    {
      'name': 'Canteen',
      'position': LatLng(22.3360, 114.2645),
      'desc': 'Food and drinks',
    },
    {
      'name': 'Sports Center',
      'position': LatLng(22.3348, 114.2639),
      'desc': 'Gym and sports',
    },
  ];

  // Mock bus schedule data
  final List<Map<String, dynamic>> _busTabs = [
    {
      'label': 'To Campus',
      'icon': Icons.arrow_downward,
      'schedules': [
        {'route': 'Bus 11', 'time': '08:00, 08:30, 09:00'},
        {'route': 'Bus 91', 'time': '08:15, 08:45, 09:15'},
      ],
    },
    {
      'label': 'From Campus',
      'icon': Icons.arrow_upward,
      'schedules': [
        {'route': 'Bus 11', 'time': '17:00, 17:30, 18:00'},
        {'route': 'Bus 91', 'time': '17:15, 17:45, 18:15'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Geolocator.getPositionStream().listen((pos) {
      setState(() {
        _userLocation = LatLng(pos.latitude, pos.longitude);
      });
      _updateNearestLocation();
    });

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(pos.latitude, pos.longitude);
    });
    _updateNearestLocation();
  }

  void _updateNearestLocation() {
    if (_selectedMarkerName == null) {
      String nearest;
      if (_userLocation != null) {
        nearest = _findNearestLocationName(_userLocation!);
      } else {
        nearest = 'Academic Building';
      }
      if (nearest != _currentLocationName) {
        setState(() {
          _currentLocationName = nearest;
        });
      }
    }
  }

  String _findNearestLocationName(LatLng userLoc) {
    double minDist = double.infinity;
    String nearest = 'Academic Building';
    for (final loc in _locations) {
      final LatLng pos = loc['position'];
      final d = Geolocator.distanceBetween(
        userLoc.latitude,
        userLoc.longitude,
        pos.latitude,
        pos.longitude,
      );
      if (d < minDist) {
        minDist = d;
        nearest = loc['name'];
      }
    }
    // If user is too far (>500m), default to Academic Building
    if (minDist > 500) {
      return 'Academic Building';
    }
    return nearest;
  }

  void _onMarkerTapped(String markerName) {
    if (markerName == _currentLocationName) {
      setState(() {
        _selectedPath = null;
        _selectedMarkerName = null;
      });
      _updateNearestLocation();
      return;
    }
    // Mock best pathway
    final mockPaths = {
      'Library': 'Atrium -> Lift 19 -> Library',
      'Academic Building': 'Atrium -> Academic Building',
      'Student Hall': 'Atrium -> Lift 13 -> Student Hall',
      'Canteen': 'Atrium -> Canteen',
      'Sports Center': 'Atrium -> Sports Center',
    };
    setState(() {
      _selectedPath = mockPaths[markerName] ?? 'Pathway unavailable';
      _selectedMarkerName = markerName;
    });
  }

  Set<Marker> get _markersWithTap =>
      _locations.map((loc) {
        final isCurrent = loc['name'] == _currentLocationName;
        return Marker(
          markerId: MarkerId(loc['name']),
          position: loc['position'],
          infoWindow: InfoWindow(title: loc['name'], snippet: loc['desc']),
          icon:
              isCurrent
                  ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  )
                  : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
          onTap: () => _onMarkerTapped(loc['name']),
        );
      }).toSet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final cardRadius = BorderRadius.circular(18);
    final shadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.10),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 20),
                        SizedBox(width: 4),
                        Text(
                          _currentLocationName ?? 'Loading...',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ClickyIconButton(
                    icon: Icon(Icons.bus_alert_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: GoogleMap(
                      onMapCreated: (controller) => _mapController = controller,
                      initialCameraPosition: const CameraPosition(
                        target: _hkustCenter,
                        zoom: 16.5,
                      ),
                      markers: _markersWithTap,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      mapType: MapType.normal,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Builder(
                            builder: (context) {
                              // If a marker is tapped, show its details; otherwise, show nearest location
                              final String? name =
                                  _selectedMarkerName ?? _currentLocationName;
                              final Map<String, dynamic> loc = _locations
                                  .firstWhere(
                                    (l) => l['name'] == name,
                                    orElse: () => <String, dynamic>{},
                                  );
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.place,
                                        color: accent,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        name ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                        ),
                                        tooltip: 'See details',
                                        onPressed: () {
                                          final Map<String, dynamic> loc =
                                              _locations.firstWhere(
                                                (l) => l['name'] == name,
                                                orElse:
                                                    () => <String, dynamic>{
                                                      'name': name ?? '',
                                                      'desc': '',
                                                    },
                                              );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      LocationDetailedPage(
                                                        name: loc['name'] ?? '',
                                                        desc: loc['desc'] ?? '',
                                                      ),
                                            ),
                                          );
                                        },
                                      ),
                                      if (_selectedMarkerName != null)
                                        IconButton(
                                          icon: const Icon(Icons.close_rounded),
                                          onPressed:
                                              () => setState(() {
                                                _selectedPath = null;
                                                _selectedMarkerName = null;
                                                _updateNearestLocation();
                                              }),
                                        ),
                                    ],
                                  ),
                                  if (loc.isNotEmpty && loc['desc'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        loc['desc'],
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  if (_selectedPath != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.directions_walk,
                                            color: accent,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _selectedPath!,
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (_selectedMarkerName == null &&
                                      _currentLocationName != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'You are here',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 3,
                  ),
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.directions_bus, size: 22),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                  label: const Text(
                    'See Bus Schedules',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BusSchedulePage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
