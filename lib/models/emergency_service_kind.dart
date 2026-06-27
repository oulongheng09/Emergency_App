import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

enum EmergencyServiceKind {
  hospital(
    title: 'Hospital',
    titleKm: 'មន្ទីរពេទ្យ',
    listTitle: 'HOSPITALS NEARBY',
    listTitleKm: 'មន្ទីរពេទ្យនៅជិត',
    nearbyTitle: 'Nearby Hospitals',
    nearbyTitleKm: 'មន្ទីរពេទ្យនៅជិត',
    navigationTitle: 'Hospital',
    navigationTitleKm: 'មន្ទីរពេទ្យ',
    description: 'Find emergency facilities in your radius.',
    descriptionKm: 'ស្វែងរកមណ្ឌលសង្គ្រោះបន្ទាន់នៅជុំវិញអ្នក។',
    quickCallNumber: '24/7',
    icon: Icons.local_hospital_rounded,
    color: AppColors.hospitalRed,
  ),
  police(
    title: 'Police Department',
    titleKm: 'នគរបាល',
    listTitle: 'POLICE DEPARTMENT',
    listTitleKm: 'នគរបាលជិតខាង',
    nearbyTitle: 'Nearby Stations',
    nearbyTitleKm: 'ប៉ុស្តិ៍ជិតខាង',
    navigationTitle: 'Police Department',
    navigationTitleKm: 'នគរបាល',
    description: 'Immediate response support and city safety assistance.',
    descriptionKm: 'ការឆ្លើយតបភ្លាមៗ និងជំនួយសុវត្ថិភាពទីក្រុង។',
    quickCallNumber: '117',
    icon: Icons.shield_rounded,
    color: AppColors.policeBlue,
  ),
  ambulance(
    title: 'Ambulance',
    titleKm: 'រថយន្តសង្គ្រោះ',
    listTitle: 'AMBULANCE',
    listTitleKm: 'រថយន្តសង្គ្រោះ',
    nearbyTitle: 'Nearby Services',
    nearbyTitleKm: 'សេវាជិតខាង',
    navigationTitle: 'Ambulance',
    navigationTitleKm: 'រថយន្តសង្គ្រោះ',
    description: 'Emergency medical transport for life-threatening situations.',
    descriptionKm:
        'ដឹកជញ្ជូនវេជ្ជសាស្ត្របន្ទាន់សម្រាប់ស្ថានការណ៍គ្រោះថ្នាក់ដល់ជីវិត។',
    quickCallNumber: '119',
    icon: Icons.emergency_rounded,
    color: AppColors.ambulanceRed,
  ),
  fireDepartment(
    title: 'Fire Department',
    titleKm: 'អគ្គិភ័យ',
    listTitle: 'FIRE DEPARTMENT',
    listTitleKm: 'អគ្គិភ័យជិតខាង',
    nearbyTitle: 'Nearby Stations',
    nearbyTitleKm: 'ស្ថានីយជិតខាង',
    navigationTitle: 'Fire Department',
    navigationTitleKm: 'អគ្គិភ័យ',
    description:
        'Immediate response for fire suppression, search and rescue, and hazardous material containment.',
    descriptionKm:
        'ការឆ្លើយតបភ្លាមៗសម្រាប់ពន្លត់អគ្គិភ័យ ស្វែងរក និងសង្គ្រោះ និងការទប់ស្កាត់វត្ថុគ្រោះថ្នាក់។',
    quickCallNumber: '118',
    icon: Icons.local_fire_department_rounded,
    color: AppColors.fireOrange,
  );

  const EmergencyServiceKind({
    required this.title,
    required this.titleKm,
    required this.listTitle,
    required this.listTitleKm,
    required this.nearbyTitle,
    required this.nearbyTitleKm,
    required this.navigationTitle,
    required this.navigationTitleKm,
    required this.description,
    required this.descriptionKm,
    required this.quickCallNumber,
    required this.icon,
    required this.color,
  });

  final String title;
  final String titleKm;
  final String listTitle;
  final String listTitleKm;
  final String nearbyTitle;
  final String nearbyTitleKm;
  final String navigationTitle;
  final String navigationTitleKm;
  final String description;
  final String descriptionKm;
  final String quickCallNumber;
  final IconData icon;
  final Color color;

  bool get usesListFlow => this == EmergencyServiceKind.hospital;

  String get localizedTitle => AppLocaleState.isKhmer ? titleKm : title;

  String get localizedListTitle =>
      AppLocaleState.isKhmer ? listTitleKm : listTitle;

  String get localizedNearbyTitle =>
      AppLocaleState.isKhmer ? nearbyTitleKm : nearbyTitle;

  String get localizedNavigationTitle =>
      AppLocaleState.isKhmer ? navigationTitleKm : navigationTitle;

  String get localizedDescription =>
      AppLocaleState.isKhmer ? descriptionKm : description;

  String get homeLabel {
    switch (this) {
      case EmergencyServiceKind.hospital:
        return AppLocaleState.isKhmer ? 'មន្ទីរពេទ្យ' : 'HOSPITAL';
      case EmergencyServiceKind.police:
        return AppLocaleState.isKhmer ? 'នគរបាល' : 'POLICE';
      case EmergencyServiceKind.ambulance:
        return AppLocaleState.isKhmer ? 'រថយន្តសង្គ្រោះ' : 'AMBULANCE';
      case EmergencyServiceKind.fireDepartment:
        return AppLocaleState.isKhmer ? 'អគ្គិភ័យ' : 'FIRE DEPT';
    }
  }

  String get homeSubtitle {
    switch (this) {
      case EmergencyServiceKind.hospital:
        return AppLocaleState.isKhmer
            ? 'វេជ្ជសាស្ត្របន្ទាន់'
            : 'Emergency Medical';
      case EmergencyServiceKind.police:
        return AppLocaleState.isKhmer ? 'នគរបាលបន្ទាន់' : 'Emergency Police';
      case EmergencyServiceKind.ambulance:
        return AppLocaleState.isKhmer
            ? 'សេវារថយន្តសង្គ្រោះ'
            : 'Ambulance Service';
      case EmergencyServiceKind.fireDepartment:
        return AppLocaleState.isKhmer ? 'អគ្គិភ័យបន្ទាន់' : 'Fire Emergency';
    }
  }
}
