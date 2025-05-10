import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/ClickyIconButton.dart';
import 'package:geolocator/geolocator.dart';
import 'BusSchedulePage.dart';
import 'LocationDetailedPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shimmer/shimmer.dart';

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

  // Fetched campus locations
  List<Map<String, dynamic>> _locations = [];
  // Fetched bus tabs (grouped by direction)
  List<Map<String, dynamic>> _busTabs = [];
  bool _loadingLocations = true;
  bool _loadingBus = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _fetchLocations();
    _fetchBusSchedules();
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

  Future<void> _fetchLocations() async {
    try {
      final response = await Supabase.instance.client
          .from('locations')
          .select()
          .order('name');
      setState(() {
        _locations = List<Map<String, dynamic>>.from(response);
        _loadingLocations = false;
      });
      _updateNearestLocation();
    } catch (e) {
      setState(() {
        _loadingLocations = false;
      });
      print('Error fetching locations: $e');
    }
  }

  Future<void> _fetchBusSchedules() async {
    try {
      final response =
          await Supabase.instance.client.from('bus_schedules').select();
      final toCampus =
          response.where((b) => b['direction'] == 'To Campus').toList();
      final fromCampus =
          response.where((b) => b['direction'] == 'From Campus').toList();
      setState(() {
        _busTabs = [
          {
            'label': 'To Campus',
            'icon': Icons.arrow_downward,
            'schedules': toCampus,
          },
          {
            'label': 'From Campus',
            'icon': Icons.arrow_upward,
            'schedules': fromCampus,
          },
        ];
        _loadingBus = false;
      });
    } catch (e) {
      setState(() {
        _loadingBus = false;
      });
      print('Error fetching bus schedules: $e');
    }
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
      final LatLng pos = LatLng(loc['lat'], loc['lng']);
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
          position: LatLng(loc['lat'], loc['lng']),
          infoWindow: InfoWindow(
            title: loc['name'],
            snippet: loc['description'],
          ),
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

  Widget _skeletonMapCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      margin: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _skeletonBusCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

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
              child:
                  _loadingLocations
                      ? _skeletonMapCard()
                      : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: GoogleMap(
                              onMapCreated:
                                  (controller) => _mapController = controller,
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
                                          _selectedMarkerName ??
                                          _currentLocationName;
                                      final Map<String, dynamic> loc =
                                          _locations.firstWhere(
                                            (l) => l['name'] == name,
                                            orElse: () => <String, dynamic>{},
                                          );
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                ),
                                                tooltip: 'See details',
                                                onPressed: () {
                                                  final Map<String, dynamic>
                                                  loc = _locations.firstWhere(
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
                                                          (
                                                            context,
                                                          ) => LocationDetailedPage(
                                                            name:
                                                                loc['name'] ??
                                                                '',
                                                            desc:
                                                                loc['description'] ??
                                                                '',
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              if (_selectedMarkerName != null)
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close_rounded,
                                                  ),
                                                  onPressed:
                                                      () => setState(() {
                                                        _selectedPath = null;
                                                        _selectedMarkerName =
                                                            null;
                                                        _updateNearestLocation();
                                                      }),
                                                ),
                                            ],
                                          ),
                                          if (loc.isNotEmpty &&
                                              loc['description'] != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
                                              child: Text(
                                                loc['description'],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          if (_selectedPath != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
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
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
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
              child:
                  _loadingBus
                      ? _skeletonBusCard()
                      : SizedBox(
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
