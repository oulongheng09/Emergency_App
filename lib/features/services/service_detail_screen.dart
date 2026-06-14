import 'package:emergency_front_end/core/utils/launcher_utils.dart';
import 'package:emergency_front_end/models/service_location.dart';
import 'package:emergency_front_end/widgets/service_action_button.dart';
import 'package:emergency_front_end/widgets/service_detail_section.dart';
import 'package:emergency_front_end/widgets/service_screen_shell.dart';
import 'package:emergency_front_end/models/backend_user.dart';
import 'package:emergency_front_end/features/profile/profile_screen.dart';
import 'package:emergency_front_end/features/map/map_screen.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({
    super.key,
    required this.location,
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
  });

  final ServiceLocation location;
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return ServiceScreenShell(
      title: '${location.kind.navigationTitle} Details',
      onSettingsTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              user: user,
              token: token,
              onSaved: onUserUpdated,
              onLogout: onLogout,
            ),
          ),
        );
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 20),
        children: [
          _HeroPanel(location: location),
          const SizedBox(height: 14),
          Text(
            location.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.primaryRed,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location.address,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          _DirectLineCard(location: location),
          const SizedBox(height: 16),
          ServiceDetailSection(
            title: location.summaryTitle,
            children: [
              for (final item in location.detailHighlights) ...[
                _DetailFeatureRow(
                  label: item,
                  color: location.kind.color,
                  icon: location.kind.icon,
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 14),
          _DirectionsPreview(location: location),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => LauncherUtils.makePhoneCall(location.phone),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.call_rounded, size: 18),
              label: const Text(
                'CALL NOW',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.location});

  final ServiceLocation location;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [location.kind.color.withValues(alpha: 0.25), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: 10,
            child: Icon(
              location.kind.icon,
              size: 120,
              color: location.kind.color.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: location.kind.color.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(
                    location.kind.icon,
                    color: location.kind.color,
                    size: 34,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    location.statusLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectLineCard extends StatelessWidget {
  const _DirectLineCard({required this.location});

  final ServiceLocation location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DIRECT LINE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryRed,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  location.phone,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => LauncherUtils.makePhoneCall(location.phone),
              icon: const Icon(
                Icons.call_outlined,
                color: AppColors.primaryRed,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailFeatureRow extends StatelessWidget {
  const _DetailFeatureRow({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: AppColors.textGrey,
          ),
        ],
      ),
    );
  }
}

class _DirectionsPreview extends StatelessWidget {
  const _DirectionsPreview({required this.location});

  final ServiceLocation location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.textDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFF0F0F0), Color(0xFFD8D8D8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.map_rounded, size: 52, color: Colors.white70),
                Positioned(
                  bottom: 10,
                  child: ServiceActionButton.outlined(
                    label: 'GET DIRECTIONS',
                    icon: Icons.route_outlined,
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
          ),
        ],
      ),
    );
  }
}
