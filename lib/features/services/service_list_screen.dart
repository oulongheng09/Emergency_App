import 'package:emergency_front_end/data/service_catalog.dart';
import 'package:emergency_front_end/models/emergency_service_kind.dart';
import 'package:emergency_front_end/features/services/service_detail_screen.dart';
import 'package:emergency_front_end/widgets/nearby_service_card.dart';
import 'package:emergency_front_end/widgets/service_screen_shell.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key, required this.kind});

  final EmergencyServiceKind kind;

  @override
  Widget build(BuildContext context) {
    final items = locationsForKind(kind);

    return ServiceScreenShell(
      title: kind.navigationTitle,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 20),
        children: [
          Text(
            kind.listTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryRed,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Found emergency facilities in your radius.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 16),
          for (final item in items) ...[
            NearbyServiceCard(
              location: item,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ServiceDetailScreen(location: item),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
