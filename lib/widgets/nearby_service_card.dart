import 'package:emergency_front_end/core/utils/launcher_utils.dart';
import 'package:emergency_front_end/models/service_location.dart';
import 'package:emergency_front_end/widgets/service_action_button.dart';
import 'package:emergency_front_end/features/map/map_screen.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NearbyServiceCard extends StatelessWidget {
  const NearbyServiceCard({
    super.key,
    required this.location,
    this.onTap,
    this.showStatusDot = true,
  });

  final ServiceLocation location;
  final VoidCallback? onTap;
  final bool showStatusDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.75),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      location.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.policeBlue.withValues(alpha: 0.16)
                          : const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      location.distanceLabel,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.policeBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    showStatusDot ? Icons.star : Icons.pin_drop_outlined,
                    size: 12,
                    color: location.kind.color,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location.badgeLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: location.kind.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      location.address,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ServiceActionButton.primary(
                      label: 'CALL',
                      icon: Icons.call_rounded,
                      onPressed: () {
                        LauncherUtils.makePhoneCall(location.phone);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ServiceActionButton.outlined(
                      label: 'DIRECTIONS',
                      icon: Icons.near_me_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapScreen(
                              destination: location,
                              showBackButton: true,
                            ),
                          ),
                        );
                      },
                    ),
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
