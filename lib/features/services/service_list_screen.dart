import 'package:emergency_front_end/data/service_catalog.dart';
import 'package:emergency_front_end/models/emergency_service_kind.dart';
import 'package:emergency_front_end/features/services/service_detail_screen.dart';
import 'package:emergency_front_end/widgets/nearby_service_card.dart';
import 'package:emergency_front_end/widgets/service_screen_shell.dart';
import 'package:emergency_front_end/models/backend_user.dart';
import 'package:emergency_front_end/models/service_location.dart';
import 'package:emergency_front_end/features/profile/profile_screen.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/core/services/emergency_services_api.dart';
import 'package:emergency_front_end/l10n/app_text.dart';
import 'package:flutter/material.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({
    super.key,
    required this.kind,
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
  });

  final EmergencyServiceKind kind;
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
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
    final items = _error != null ? locationsForKind(widget.kind) : _services;
    final hasError = _error != null;

    return ServiceScreenShell(
      title: widget.kind.localizedNavigationTitle,
      onSettingsTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              user: widget.user,
              token: widget.token,
              onSaved: widget.onUserUpdated,
              onLogout: widget.onLogout,
            ),
          ),
        );
      },
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 20),
              children: [
                Text(
                widget.kind.localizedListTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryRed,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasError
                      ? AppText.t(
                          context,
                          en: 'Using local data. Backend connection failed.',
                          km: 'កំពុងប្រើទិន្នន័យមូលដ្ឋាន។ ការតភ្ជាប់ទៅម៉ាស៊ីនមេបរាជ័យ។',
                        )
                      : AppText.t(
                          context,
                          en: 'Found ${items.length} emergency facilities in your radius.',
                          km: 'រកឃើញមណ្ឌលសង្គ្រោះបន្ទាន់ ${items.length} កន្លែងនៅជុំវិញអ្នក។',
                        ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: hasError ? AppColors.primaryRed : AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        AppText.t(context, en: 'No services available', km: 'មិនមានសេវាទេ'),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  )
                else
                  for (final item in items) ...[
                    NearbyServiceCard(
                      location: item,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailScreen(
                              location: item,
                              user: widget.user,
                              token: widget.token,
                              onUserUpdated: widget.onUserUpdated,
                              onLogout: widget.onLogout,
                            ),
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
