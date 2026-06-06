import 'package:emergency_front_end/features/map/models/emergency_place.dart';

class EmergencyPlaceDistance {
  const EmergencyPlaceDistance({required this.place, required this.distanceKm});

  final EmergencyPlace place;
  final double? distanceKm;
}
