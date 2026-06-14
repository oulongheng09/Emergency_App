import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PersonalContactModel {
  const PersonalContactModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    required this.icon,
    required this.iconColor,
  });

  final String id;
  final String name;
  final String relationship;
  final String phone;
  final IconData icon;
  final Color iconColor;

  factory PersonalContactModel.fromJson(Map<String, dynamic> json) {
    return PersonalContactModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      relationship: json['relationship'] ?? '',
      phone: json['phone_number']?.toString() ?? '',
      icon: Icons.person_rounded,
      iconColor: AppColors.policeBlue,
    );
  }

  PersonalContactModel copyWith({
    String? id,
    String? name,
    String? relationship,
    String? phone,
    IconData? icon,
    Color? iconColor,
  }) {
    return PersonalContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}
