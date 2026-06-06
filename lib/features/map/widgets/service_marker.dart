import 'package:emergency_front_end/features/map/models/emergency_place.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceMarker extends StatelessWidget {
  const ServiceMarker({
    super.key,
    required this.place,
    required this.isSelected,
  });

  final EmergencyPlace place;
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
