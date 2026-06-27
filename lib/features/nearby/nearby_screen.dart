import 'package:emergency_front_end/core/utils/launcher_utils.dart';
import 'package:emergency_front_end/features/map/map_screen.dart';
import 'package:emergency_front_end/data/service_catalog.dart';
import 'package:emergency_front_end/models/emergency_service_kind.dart';
import 'package:emergency_front_end/features/services/service_detail_screen.dart';
import 'package:emergency_front_end/widgets/nearby_service_card.dart';
import 'package:emergency_front_end/widgets/service_screen_shell.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/core/services/emergency_services_api.dart';
import 'package:emergency_front_end/models/service_location.dart';
import 'package:emergency_front_end/l10n/app_text.dart';
import 'package:flutter/material.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key, required this.kind});

  final EmergencyServiceKind kind;

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  final EmergencyServicesApi _api = EmergencyServicesApi();

  List<ServiceLocation> _services = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final services = await _api.getAllServices();

      final filteredServices = services
          .where((service) => service.kind == widget.kind)
          .toList();

      setState(() {
        _services = filteredServices;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final content = nearbyContentFor(widget.kind);

    final displayServices = _error != null ? content.nearbyItems : _services;
    final hasError = _error != null;

    return ServiceScreenShell(
      title: widget.kind.localizedNavigationTitle,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 20),
              children: [
                _NearbyHero(kind: widget.kind),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    widget.kind.localizedListTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: widget.kind.color,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.kind.localizedDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white70 : AppColors.textGrey,
                      height: 1.35,
                    ),
                  ),
                ),
                if (hasError) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF3A2023)
                          : const Color(0xFFFFECEC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDarkMode
                            ? const Color(0xFF8D5058)
                            : const Color(0xFFFFCDD2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryRed,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppText.t(
                              context,
                              en: 'Using local data. Backend connection failed.',
                              km: 'កំពុងប្រើទិន្នន័យមូលដ្ឋាន។ ការតភ្ជាប់ទៅម៉ាស៊ីនមេបរាជ័យ។',
                            ),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (content.localizedFooterNote != null) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      content.localizedFooterNote!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white60 : AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => LauncherUtils.makePhoneCall(
                      widget.kind.quickCallNumber,
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: widget.kind.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.call_rounded, size: 18),
                    label: Text(
                      AppText.t(
                        context,
                        en: 'QUICK CALL (${widget.kind.quickCallNumber})',
                        km: 'ហៅរហ័ស (${widget.kind.quickCallNumber})',
                      ),
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
                        content.kind.localizedNearbyTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const MapScreen(showBackButton: true),
                          ),
                        );
                      },
                      child: Text(
                        AppText.t(context, en: 'VIEW MAP', km: 'មើលផែនទី'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                if (displayServices.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        AppText.t(
                          context,
                          en: 'No services available',
                          km: 'មិនមានសេវាទេ',
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  )
                else
                  for (final item in displayServices.take(3)) ...[
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
                if (content.localizedTags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    AppText.t(
                      context,
                      en: 'EMERGENCY TYPES',
                      km: 'ប្រភេទបន្ទាន់',
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final tag in content.localizedTags)
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.75),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 15,
                                color: widget.kind.color,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.75)),
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
                content.localizedProtocolTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: content.kind.color,
                ),
              ),
            ],
          ),
          if (content.localizedProtocolBody.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              content.localizedProtocolBody,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : AppColors.textGrey,
                height: 1.45,
              ),
            ),
          ],
          if (content.localizedHelpBullets.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final item in content.localizedHelpBullets) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
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
