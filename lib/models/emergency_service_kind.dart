import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum EmergencyServiceKind {
  hospital(
    title: 'Hospital',
    listTitle: 'HOSPITALS NEARBY',
    nearbyTitle: 'Nearby Hospitals',
    navigationTitle: 'Hospital',
    description: 'Find emergency facilities in your radius.',
    quickCallNumber: '24/7',
    icon: Icons.local_hospital_rounded,
    color: AppColors.hospitalRed,
  ),
  police(
    title: 'Police Department',
    listTitle: 'POLICE DEPARTMENT',
    nearbyTitle: 'Nearby Stations',
    navigationTitle: 'Police Department',
    description: 'Immediate response support and city safety assistance.',
    quickCallNumber: '117',
    icon: Icons.shield_rounded,
    color: AppColors.policeBlue,
  ),
  ambulance(
    title: 'Ambulance',
    listTitle: 'AMBULANCE',
    nearbyTitle: 'Nearby Services',
    navigationTitle: 'Ambulance',
    description: 'Emergency medical transport for life-threatening situations.',
    quickCallNumber: '119',
    icon: Icons.emergency_rounded,
    color: AppColors.ambulanceRed,
  ),
  fireDepartment(
    title: 'Fire Department',
    listTitle: 'FIRE DEPARTMENT',
    nearbyTitle: 'Nearby Stations',
    navigationTitle: 'Fire Department',
    description:
        'Immediate response for fire suppression, search and rescue, and hazardous material containment.',
    quickCallNumber: '118',
    icon: Icons.local_fire_department_rounded,
    color: AppColors.fireOrange,
  );

  const EmergencyServiceKind({
    required this.title,
    required this.listTitle,
    required this.nearbyTitle,
    required this.navigationTitle,
    required this.description,
    required this.quickCallNumber,
    required this.icon,
    required this.color,
  });

  final String title;
  final String listTitle;
  final String nearbyTitle;
  final String navigationTitle;
  final String description;
  final String quickCallNumber;
  final IconData icon;
  final Color color;

  bool get usesListFlow => this == EmergencyServiceKind.hospital;

  String get homeLabel {
    switch (this) {
      case EmergencyServiceKind.hospital:
        return 'HOSPITAL';
      case EmergencyServiceKind.police:
        return 'POLICE';
      case EmergencyServiceKind.ambulance:
        return 'AMBULANCE';
      case EmergencyServiceKind.fireDepartment:
        return 'FIRE DEPT';
    }
  }

  String get homeSubtitle {
    switch (this) {
      case EmergencyServiceKind.hospital:
        return 'Emergency Medical';
      case EmergencyServiceKind.police:
        return 'Emergency Police';
      case EmergencyServiceKind.ambulance:
        return 'Ambulance Service';
      case EmergencyServiceKind.fireDepartment:
        return 'Fire Emergency';
    }
  }
}
