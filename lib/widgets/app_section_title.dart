import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry padding;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.padding = const EdgeInsets.symmetric(horizontal: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              letterSpacing: 0.1,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                height: 1.35,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
