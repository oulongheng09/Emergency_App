import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum EmergencyPlaceType {
  police(AppColors.policeBlue, Icons.shield_outlined),
  hospital(AppColors.hospitalRed, Icons.local_hospital),
  fireStation(AppColors.fireOrange, Icons.local_fire_department);

  const EmergencyPlaceType(this.color, this.icon);

  final Color color;
  final IconData icon;
}

class EmergencyPlace {
  const EmergencyPlace({
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
