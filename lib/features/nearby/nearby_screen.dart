import 'package:emergency_front_end/core/utils/launcher_utils.dart';
import 'package:emergency_front_end/features/map/map_screen.dart';
import 'package:emergency_front_end/features/services/data/service_catalog.dart';
import 'package:emergency_front_end/features/services/models/emergency_service_kind.dart';
import 'package:emergency_front_end/features/services/service_detail_screen.dart';
import 'package:emergency_front_end/features/services/widgets/nearby_service_card.dart';
import 'package:emergency_front_end/features/services/widgets/service_screen_shell.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key, required this.kind});

  final EmergencyServiceKind kind;

  @override
  Widget build(BuildContext context) {
    final content = nearbyContentFor(kind);

    return ServiceScreenShell(
      title: kind.navigationTitle,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 20),
        children: [
          _NearbyHero(kind: kind),
          const SizedBox(height: 10),
          Center(
            child: Text(
              kind.listTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: kind.color,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              kind.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textGrey,
                height: 1.35,
              ),
            ),
          ),
          if (content.footerNote != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                content.footerNote!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () =>
                  LauncherUtils.makePhoneCall(kind.quickCallNumber),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kind.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.call_rounded, size: 18),
              label: Text(
                'QUICK CALL (${kind.quickCallNumber})',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(content: content),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  content.kind.nearbyTitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const MapScreen()));
                },
                child: const Text(
                  'VIEW MAP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
          for (final item in content.nearbyItems.take(3)) ...[
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
          if (content.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'EMERGENCY TYPES',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final tag in content.tags)
                  Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 15,
                          color: kind.color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NearbyHero extends StatelessWidget {
  const _NearbyHero({required this.kind});

  final EmergencyServiceKind kind;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          color: kind.color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kind.color.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(kind.icon, color: Colors.white, size: 32),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.content});

  final NearbyScreenContent content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: content.kind.color,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                content.protocolTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: content.kind.color,
                ),
              ),
            ],
          ),
          if (content.protocolBody.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              content.protocolBody,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textGrey,
                height: 1.45,
              ),
            ),
          ],
          if (content.helpBullets.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final item in content.helpBullets) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ],
        ],
      ),
    );
  }
}
