import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FirstAidCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double radius;
  final double iconSize;
  final double height;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment alignment;

  const FirstAidCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    this.backgroundColor = AppColors.card,
    this.foregroundColor = AppColors.textDark,
    this.borderColor = AppColors.border,
    this.radius = 16,
    this.iconSize = 28,
    this.height = 120,
    this.padding = const EdgeInsets.all(16),
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: foregroundColor, size: iconSize),
          if (subtitle != null) const SizedBox(height: 8),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(color: foregroundColor),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: foregroundColor),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
