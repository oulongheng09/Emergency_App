import 'dart:async';
import 'dart:convert';

import 'package:emergency_front_end/core/utils/distance_utils.dart';
import 'package:emergency_front_end/core/utils/launcher_utils.dart';
import 'package:emergency_front_end/features/map/data/emergency_places.dart';
import 'package:emergency_front_end/features/map/models/emergency_place.dart';
import 'package:emergency_front_end/features/map/models/emergency_place_distance.dart';
import 'package:emergency_front_end/features/map/models/route_data.dart';
import 'package:emergency_front_end/features/map/widgets/map_header.dart';
import 'package:emergency_front_end/features/map/widgets/map_info_card.dart';
import 'package:emergency_front_end/features/map/widgets/service_marker.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static final LatLng _cambodiaCenter = LatLng(11.5564, 104.9282);
  static const double _defaultZoom = 13.2;

  final MapController _mapController = MapController();

  StreamSubscription<Position>? _positionSubscription;
  Position? _currentPosition;
  EmergencyPlace? _selectedPlace;
  RouteData? _activeRoute;

  bool _isLoadingLocation = true;
  bool _isLoadingRoute = false;
  bool _isLaunchingDirections = false;
  bool _isPanelExpanded = false;

  String? _locationMessage;
  String? _routeMessage;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocationTracking() async {
    setState(() {
      _isLoadingLocation = true;
      _locationMessage = null;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoadingLocation = false;
        _locationMessage =
            'Turn on location services to track your live position.';
      });
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() {
        _isLoadingLocation = false;
        _locationMessage = 'Location permission was denied.';
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoadingLocation = false;
        _locationMessage =
            'Location permission is permanently denied. Please enable it in settings.';
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      _updateCurrentPosition(position, moveCamera: true);

      _positionSubscription?.cancel();
      _positionSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 15,
            ),
          ).listen((position) {
            _updateCurrentPosition(position);
          });
    } catch (_) {
      setState(() {
        _isLoadingLocation = false;
        _locationMessage = 'Unable to read your current location right now.';
      });
    }
  }

  void _updateCurrentPosition(Position position, {bool moveCamera = false}) {
    if (!mounted) {
      return;
    }

    final target = LatLng(position.latitude, position.longitude);
    final previousOrigin = _activeRoute?.origin;

    setState(() {
      _currentPosition = position;
      _isLoadingLocation = false;
      _locationMessage = null;
    });

    final selectedPlace = _selectedPlace;
    if (selectedPlace != null &&
        previousOrigin != null &&
        DistanceUtils.kilometersBetween(previousOrigin, target) >= 0.04) {
      unawaited(_loadRouteToPlace(selectedPlace, fitRoute: false));
    }

    if (moveCamera) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(target, 14.8);
        }
      });
    }
  }

  void _centerOnUser() {
    final position = _currentPosition;
    if (position == null) {
      _initLocationTracking();
      return;
    }

    _mapController.move(LatLng(position.latitude, position.longitude), 15.2);
  }

  void _togglePanel() {
    setState(() {
      _isPanelExpanded = !_isPanelExpanded;
    });
  }

  void _selectPlace(EmergencyPlace place) {
    setState(() {
      _selectedPlace = place;
      _isPanelExpanded = true;
    });

    unawaited(_loadRouteToPlace(place));
  }

  Future<void> _loadRouteToPlace(
    EmergencyPlace place, {
    bool fitRoute = true,
  }) async {
    final user = _currentPosition;
    if (user == null) {
      setState(() {
        _activeRoute = null;
        _routeMessage = 'Enable your location to calculate a real road route.';
      });
      return;
    }

    setState(() {
      _isLoadingRoute = true;
      _routeMessage = null;
    });

    final origin = LatLng(user.latitude, user.longitude);
    final uri = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${origin.longitude},${origin.latitude};'
      '${place.position.longitude},${place.position.latitude}'
      '?overview=full&geometries=geojson&steps=false',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Routing request failed');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = body['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) {
        throw Exception('No route found');
      }

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>;
      final coordinates = geometry['coordinates'] as List<dynamic>;

      final points = coordinates
          .map((item) => item as List<dynamic>)
          .map(
            (item) => LatLng(
              (item[1] as num).toDouble(),
              (item[0] as num).toDouble(),
            ),
          )
          .toList();

      if (!mounted || _selectedPlace != place) {
        return;
      }

      setState(() {
        _activeRoute = RouteData(
          points: points,
          distanceKm: ((route['distance'] as num?)?.toDouble() ?? 0) / 1000,
          durationMinutes: ((route['duration'] as num?)?.toDouble() ?? 0) / 60,
          origin: origin,
        );
        _isLoadingRoute = false;
        _routeMessage = null;
      });

      if (fitRoute && points.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }

          final bounds = LatLngBounds.fromPoints(points);
          _mapController.fitCamera(
            CameraFit.bounds(
              bounds: bounds,
              padding: EdgeInsets.fromLTRB(
                42,
                72,
                42,
                _isPanelExpanded ? 240 : 110,
              ),
            ),
          );
        });
      }
    } catch (_) {
      if (!mounted || _selectedPlace != place) {
        return;
      }

      setState(() {
        _activeRoute = null;
        _isLoadingRoute = false;
        _routeMessage =
            'Could not load a road route right now. Live navigation still opens in Google Maps.';
      });
    }
  }

  Future<void> _openDirections() async {
    final place = _selectedPlace;
    final user = _currentPosition;
    if (place == null || user == null || _isLaunchingDirections) {
      return;
    }

    setState(() {
      _isLaunchingDirections = true;
    });

    final opened = await LauncherUtils.openMapDirections(
      origin: LatLng(user.latitude, user.longitude),
      destination: place.position,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLaunchingDirections = false;
    });

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open directions right now.')),
      );
    }
  }

  List<EmergencyPlaceDistance> _sortedPlaces() {
    final user = _currentPosition;
    if (user == null) {
      return emergencyPlaces
          .map(
            (place) => EmergencyPlaceDistance(place: place, distanceKm: null),
          )
          .toList();
    }

    final current = LatLng(user.latitude, user.longitude);
    final places = emergencyPlaces
        .map(
          (place) => EmergencyPlaceDistance(
            place: place,
            distanceKm: DistanceUtils.kilometersBetween(
              current,
              place.position,
            ),
          ),
        )
        .toList();

    places.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
    return places;
  }

  @override
  Widget build(BuildContext context) {
    final sortedPlaces = _sortedPlaces();
    final routePoints = _activeRoute?.points ?? const <LatLng>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const MapHeader(),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _cambodiaCenter,
                      initialZoom: _defaultZoom,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.emergency_front_end',
                      ),
                      if (routePoints.length >= 2)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              strokeWidth: 6,
                              color: AppColors.primaryRed,
                              borderStrokeWidth: 2,
                              borderColor: Colors.white,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          ...emergencyPlaces.map(_buildServiceMarker),
                          if (_currentPosition != null)
                            _buildUserMarker(_currentPosition!),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'center_location',
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryRed,
                          onPressed: _centerOnUser,
                          child: const Icon(Icons.my_location),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton.small(
                          heroTag: 'toggle_panel',
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.textDark,
                          onPressed: _togglePanel,
                          child: Icon(
                            _isPanelExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: MapInfoCard(
                      isExpanded: _isPanelExpanded,
                      isLoadingLocation: _isLoadingLocation,
                      isLoadingRoute: _isLoadingRoute,
                      isLaunchingDirections: _isLaunchingDirections,
                      locationMessage: _locationMessage,
                      routeMessage: _routeMessage,
                      currentPosition: _currentPosition,
                      selectedPlace: _selectedPlace,
                      activeRoute: _activeRoute,
                      places: sortedPlaces.take(3).toList(),
                      onRefreshLocation: _initLocationTracking,
                      onPlaceSelected: _selectPlace,
                      onOpenDirections: _openDirections,
                      onToggleExpanded: _togglePanel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker _buildServiceMarker(EmergencyPlace place) {
    final isSelected = _selectedPlace == place;

    return Marker(
      point: place.position,
      width: isSelected ? 54 : 44,
      height: isSelected ? 54 : 44,
      child: GestureDetector(
        onTap: () => _selectPlace(place),
        child: ServiceMarker(place: place, isSelected: isSelected),
      ),
    );
  }

  Marker _buildUserMarker(Position position) {
    return Marker(
      point: LatLng(position.latitude, position.longitude),
      width: 52,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryRed.withValues(alpha: 0.18),
        ),
        child: Center(
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryRed,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
      ),
    );
  }
}
