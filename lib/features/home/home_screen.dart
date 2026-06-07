import 'package:flutter/material.dart';

import 'package:emergency_front_end/features/nearby/nearby_screen.dart';
import 'package:emergency_front_end/features/profile/profile_screen.dart';
import 'package:emergency_front_end/features/services/models/emergency_service_kind.dart';
import 'package:emergency_front_end/features/services/service_list_screen.dart';
import 'package:emergency_front_end/models/backend_user.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/theme/app_text_styles.dart';
import 'package:emergency_front_end/widgets/emergency_sos_button.dart';
import 'package:emergency_front_end/widgets/quick_action_tile.dart';

class HomeScreen extends StatelessWidget {
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;

  const HomeScreen({
    super.key,
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
  });

  static const services = [
    EmergencyServiceKind.police,
    EmergencyServiceKind.hospital,
    EmergencyServiceKind.fireDepartment,
    EmergencyServiceKind.ambulance,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 90),
          child: Column(
            children: [
              _LocationHeader(
                user: user,
                token: token,
                onUserUpdated: onUserUpdated,
                onLogout: onLogout,
              ),
              const SizedBox(height: 58),
              EmergencySosButton(
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mock SOS activated')),
                  );
                },
              ),
              const SizedBox(height: 48),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final item = services[index];
                  return QuickActionTile(
                    title: item.homeLabel,
                    icon: item.icon,
                    iconColor: item.color,
                    onTap: () => _openServiceFlow(context, item),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openServiceFlow(BuildContext context, EmergencyServiceKind kind) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => kind.usesListFlow
            ? ServiceListScreen(kind: kind)
            : NearbyScreen(kind: kind),
      ),
    );
  }
}

class _LocationHeader extends StatelessWidget {
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;
  const _LocationHeader({
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final location = (user?.location ?? user?.address ?? '').trim();
    final displayLocation = location.isEmpty ? 'Set location' : location;

    return Row(
      children: [
        Container(
          height: 23,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  displayLocation,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 7),
        const Text('KhmerSOS', style: AppTextStyles.appTitle),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.settings_outlined, size: 20),
          onPressed: () {
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
        ),
      ],
    );
  }
}
