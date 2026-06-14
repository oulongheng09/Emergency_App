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
    // Fallback to mock data if there's an error
    final items = _error != null ? locationsForKind(widget.kind) : _services;
    final hasError = _error != null;

    return ServiceScreenShell(
      title: widget.kind.navigationTitle,
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
                  widget.kind.listTitle,
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
                      ? 'Using local data. Backend connection failed.'
                      : 'Found ${items.length} emergency facilities in your radius.',
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
                        'No services available',
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
