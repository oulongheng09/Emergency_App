import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class MapHeader extends StatelessWidget {
  const MapHeader({super.key});

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
