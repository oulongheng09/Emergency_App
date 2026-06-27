import 'package:flutter/material.dart';

class QuickActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String callLabel;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.callLabel,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.75),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkMode ? 0.18 : 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          iconColor.withValues(alpha: 0.16),
                          iconColor.withValues(alpha: 0.04),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withValues(alpha: 0.16),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: iconColor, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.onSurface,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.68,
                              ),
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(
                            alpha: isDarkMode ? 0.14 : 0.10,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call_rounded,
                              color: iconColor,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              callLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.44),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
