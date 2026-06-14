import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceActionButton extends StatelessWidget {
  const ServiceActionButton.primary({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  }) : outlined = false;

  const ServiceActionButton.outlined({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  }) : outlined = true;

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: outlined
          ? const BorderSide(color: AppColors.border)
          : BorderSide.none,
    );

    final textStyle = TextStyle(
      color: outlined ? AppColors.textDark : Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.2,
    );

    return SizedBox(
      height: 34,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                shape: shape,
                foregroundColor: AppColors.textDark,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              icon: Icon(icon, size: 13),
              label: Text(label, style: textStyle),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: shape,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              icon: Icon(icon, size: 13),
              label: Text(label, style: textStyle),
            ),
    );
  }
}
