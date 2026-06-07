import 'package:latlong2/latlong.dart';

class RouteData {
  const RouteData({
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
