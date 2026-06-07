import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EmergencySosButton extends StatelessWidget {
  final VoidCallback? onLongPress;

  const EmergencySosButton({super.key, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(31),
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SOS',
                style: TextStyle(
                  fontSize: 39,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'HOLD 3S',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
