import 'dart:async';
import 'dart:convert';

import 'package:emergency_front_end/core/utils/distance_utils.dart';
import 'package:emergency_front_end/core/utils/launcher_utils.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/theme/app_text_styles.dart';
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
  _EmergencyPlace? _selectedPlace;
  _RouteData? _activeRoute;

  bool _isLoadingLocation = true;
  bool _isLoadingRoute = false;
  bool _isLaunchingDirections = false;
  bool _isPanelExpanded = false;

  String? _locationMessage;
  String? _routeMessage;

  final List<_EmergencyPlace> _places = const [
    _EmergencyPlace(
      name: 'Road Traffic Police Station',
      type: EmergencyPlaceType.police,
      position: LatLng(11.567026688275075, 104.88993483957647),
      address: 'Toul kork, Phnom Penh',
    ),
    _EmergencyPlace(
      name: 'Teuk Laok 2 Police Station',
      type: EmergencyPlaceType.police,
      position: LatLng(11.563483167664263, 104.89847623289963),
      address: 'Teuk Laok 2, Phnom Penh',
    ),
    _EmergencyPlace(
      name: 'Calmette Hospital',
      type: EmergencyPlaceType.hospital,
      position: LatLng(11.581249846995929, 104.91659107340058),
      address: 'Daun Penh, Phnom Penh',
    ),
    _EmergencyPlace(
      name: 'Preah Kossomak Hospital',
      type: EmergencyPlaceType.hospital,
      position: LatLng(11.564278727369357, 104.88979557938497),
      address: 'Toul Kork, Phnom Penh',
    ),
    _EmergencyPlace(
      name: 'Preah Ket Mealea Hospital',
      type: EmergencyPlaceType.hospital,
      position: LatLng(11.580089610079789, 104.92175853518351),
      address: '7 Makara, Phnom Penh',
    ),
    _EmergencyPlace(
      name: 'Olympia City Fire Station',
      type: EmergencyPlaceType.fireStation,
      position: LatLng(11.560595328679938, 104.91573581716146),
      address: 'Olympic, Phnom Penh',
    ),
    _EmergencyPlace(
      name: 'Koh Pich Fire Station',
      type: EmergencyPlaceType.fireStation,
      position: LatLng(11.55096730920578, 104.94291523979894),
      address: 'Chamkar Mon, Phnom Penh',
    ),
  ];

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

  void _selectPlace(_EmergencyPlace place) {
    setState(() {
      _selectedPlace = place;
      _isPanelExpanded = true;
    });

    unawaited(_loadRouteToPlace(place));
  }

  Future<void> _loadRouteToPlace(
    _EmergencyPlace place, {
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
        _activeRoute = _RouteData(
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

  List<_EmergencyPlaceDistance> _sortedPlaces() {
    final user = _currentPosition;
    if (user == null) {
      return _places
          .map(
            (place) => _EmergencyPlaceDistance(place: place, distanceKm: null),
          )
          .toList();
    }

    final current = LatLng(user.latitude, user.longitude);
    final places = _places
        .map(
          (place) => _EmergencyPlaceDistance(
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
            const _MapHeader(),
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
                          ..._places.map(_buildServiceMarker),
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
                    child: _MapInfoCard(
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

  Marker _buildServiceMarker(_EmergencyPlace place) {
    final isSelected = _selectedPlace == place;

    return Marker(
      point: place.position,
      width: isSelected ? 54 : 44,
      height: isSelected ? 54 : 44,
      child: GestureDetector(
        onTap: () => _selectPlace(place),
        child: _ServiceMarker(place: place, isSelected: isSelected),
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

class _MapHeader extends StatelessWidget {
  const _MapHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.primaryRed,
            size: 18,
          ),
          const SizedBox(width: 6),
          const Text('KhmerSOS', style: AppTextStyles.appTitle),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightRed,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Cambodia',
              style: TextStyle(
                color: AppColors.primaryRed,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapInfoCard extends StatelessWidget {
  const _MapInfoCard({
    required this.isExpanded,
    required this.isLoadingLocation,
    required this.isLoadingRoute,
    required this.isLaunchingDirections,
    required this.locationMessage,
    required this.routeMessage,
    required this.currentPosition,
    required this.selectedPlace,
    required this.activeRoute,
    required this.places,
    required this.onRefreshLocation,
    required this.onPlaceSelected,
    required this.onOpenDirections,
    required this.onToggleExpanded,
  });

  final bool isExpanded;
  final bool isLoadingLocation;
  final bool isLoadingRoute;
  final bool isLaunchingDirections;
  final String? locationMessage;
  final String? routeMessage;
  final Position? currentPosition;
  final _EmergencyPlace? selectedPlace;
  final _RouteData? activeRoute;
  final List<_EmergencyPlaceDistance> places;
  final Future<void> Function() onRefreshLocation;
  final ValueChanged<_EmergencyPlace> onPlaceSelected;
  final Future<void> Function() onOpenDirections;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return _CollapsedMapPanel(
        selectedPlace: selectedPlace,
        activeRoute: activeRoute,
        isLoadingRoute: isLoadingRoute,
        onTap: onToggleExpanded,
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Emergency routes',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              IconButton(
                onPressed: onToggleExpanded,
                icon: const Icon(Icons.close_fullscreen, size: 18),
                visualDensity: VisualDensity.compact,
              ),
              TextButton.icon(
                onPressed: onRefreshLocation,
                icon: const Icon(Icons.gps_fixed, size: 16),
                label: const Text('Refresh'),
              ),
            ],
          ),
          if (isLoadingLocation)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: LinearProgressIndicator(
                minHeight: 4,
                color: AppColors.primaryRed,
                backgroundColor: AppColors.lightRed,
              ),
            )
          else if (locationMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(locationMessage!, style: AppTextStyles.body),
            )
          else if (currentPosition != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Your live location is active. Tap any emergency place to load a real road route.',
                style: AppTextStyles.body,
              ),
            ),
          if (routeMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(routeMessage!, style: AppTextStyles.body),
            ),
          if (selectedPlace != null) ...[
            _SelectedPlaceCard(
              place: selectedPlace!,
              currentPosition: currentPosition,
              activeRoute: activeRoute,
              isLoadingRoute: isLoadingRoute,
              onOpenDirections: onOpenDirections,
              isLaunchingDirections: isLaunchingDirections,
            ),
            const SizedBox(height: 12),
          ],
          const Text('Tap a place to route', style: AppTextStyles.label),
          const SizedBox(height: 8),
          ...places.map(
            (item) => _NearbyPlaceTile(
              item: item,
              isSelected: selectedPlace == item.place,
              onTap: () => onPlaceSelected(item.place),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedPlaceCard extends StatelessWidget {
  const _SelectedPlaceCard({
    required this.place,
    required this.currentPosition,
    required this.activeRoute,
    required this.isLoadingRoute,
    required this.onOpenDirections,
    required this.isLaunchingDirections,
  });

  final _EmergencyPlace place;
  final Position? currentPosition;
  final _RouteData? activeRoute;
  final bool isLoadingRoute;
  final Future<void> Function() onOpenDirections;
  final bool isLaunchingDirections;

  @override
  Widget build(BuildContext context) {
    final distanceLabel = activeRoute != null
        ? '${activeRoute!.distanceKm.toStringAsFixed(1)} km road route'
        : currentPosition == null
        ? 'Waiting for your location'
        : '${DistanceUtils.kilometersBetween(LatLng(currentPosition!.latitude, currentPosition!.longitude), place.position).toStringAsFixed(1)} km away';

    final durationLabel = activeRoute == null
        ? null
        : '${activeRoute!.durationMinutes.round()} min estimated drive';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: place.type.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: place.type.color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: place.type.color,
                child: Icon(place.type.icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, style: AppTextStyles.label),
                    const SizedBox(height: 2),
                    Text(place.address, style: AppTextStyles.small),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isLoadingRoute
                ? 'Loading the road route to this emergency place...'
                : 'Road-following route loaded for this emergency place.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 4),
          Text(
            distanceLabel,
            style: TextStyle(
              color: place.type.color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (durationLabel != null) ...[
            const SizedBox(height: 2),
            Text(durationLabel, style: AppTextStyles.small),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  currentPosition == null ||
                      isLaunchingDirections ||
                      isLoadingRoute
                  ? null
                  : onOpenDirections,
              style: ElevatedButton.styleFrom(
                backgroundColor: place.type.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: isLaunchingDirections
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.navigation),
              label: Text(
                isLaunchingDirections ? 'Opening...' : 'Live Navigation',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyPlaceTile extends StatelessWidget {
  const _NearbyPlaceTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _EmergencyPlaceDistance item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? item.place.type.color.withValues(alpha: 0.08)
              : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: item.place.type.color.withValues(alpha: 0.35))
              : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: item.place.type.color.withValues(alpha: 0.12),
              child: Icon(
                item.place.type.icon,
                size: 18,
                color: item.place.type.color,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.place.name, style: AppTextStyles.label),
                  const SizedBox(height: 2),
                  Text(item.place.address, style: AppTextStyles.small),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.distanceKm == null
                      ? 'Nearby'
                      : '${item.distanceKm!.toStringAsFixed(1)} km',
                  style: TextStyle(
                    color: item.place.type.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSelected ? 'Selected' : 'Route',
                  style: TextStyle(
                    color: item.place.type.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CollapsedMapPanel extends StatelessWidget {
  const _CollapsedMapPanel({
    required this.selectedPlace,
    required this.activeRoute,
    required this.isLoadingRoute,
    required this.onTap,
  });

  final _EmergencyPlace? selectedPlace;
  final _RouteData? activeRoute;
  final bool isLoadingRoute;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = selectedPlace?.name ?? 'Emergency routes';
    final subtitle = isLoadingRoute
        ? 'Loading road route...'
        : activeRoute != null
        ? '${activeRoute!.distanceKm.toStringAsFixed(1)} km | ${activeRoute!.durationMinutes.round()} min'
        : 'Tap to show routes and directions';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.alt_route, color: AppColors.primaryRed),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.small),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.keyboard_arrow_up, color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceMarker extends StatelessWidget {
  const _ServiceMarker({required this.place, required this.isSelected});

  final _EmergencyPlace place;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: place.type.color,
        borderRadius: BorderRadius.circular(isSelected ? 18 : 14),
        border: Border.all(
          color: isSelected ? AppColors.primaryRed : Colors.white,
          width: isSelected ? 3.5 : 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        place.type.icon,
        color: Colors.white,
        size: isSelected ? 24 : 20,
      ),
    );
  }
}

enum EmergencyPlaceType {
  police(AppColors.policeBlue, Icons.shield_outlined),
  hospital(AppColors.hospitalRed, Icons.local_hospital),
  fireStation(AppColors.fireOrange, Icons.local_fire_department);

  const EmergencyPlaceType(this.color, this.icon);

  final Color color;
  final IconData icon;
}

class _EmergencyPlace {
  const _EmergencyPlace({
    required this.name,
    required this.type,
    required this.position,
    required this.address,
  });

  final String name;
  final EmergencyPlaceType type;
  final LatLng position;
  final String address;
}

class _EmergencyPlaceDistance {
  const _EmergencyPlaceDistance({
    required this.place,
    required this.distanceKm,
  });

  final _EmergencyPlace place;
  final double? distanceKm;
}

class _RouteData {
  const _RouteData({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    required this.origin,
  });

  final List<LatLng> points;
  final double distanceKm;
  final double durationMinutes;
  final LatLng origin;
}
