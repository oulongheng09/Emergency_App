import 'dart:async';

import 'package:emergency_front_end/core/services/backend_api_service.dart';
import 'package:emergency_front_end/features/nearby/nearby_screen.dart';
import 'package:emergency_front_end/features/profile/profile_screen.dart';
import 'package:emergency_front_end/features/services/models/emergency_service_kind.dart';
import 'package:emergency_front_end/models/backend_user.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/theme/app_text_styles.dart';
import 'package:emergency_front_end/widgets/emergency_sos_button.dart';
import 'package:emergency_front_end/widgets/quick_action_tile.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
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

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Duration _locationTimeout = Duration(seconds: 12);
  static const services = [
    EmergencyServiceKind.police,
    EmergencyServiceKind.hospital,
    EmergencyServiceKind.fireDepartment,
    EmergencyServiceKind.ambulance,
  ];

  bool _servicesUnlocked = false;
  bool _isTriggeringSos = false;
  Position? _lastSosPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 900 ? 28.0 : 18.0;
            final isTablet = constraints.maxWidth >= 720;
            final crossAxisCount = constraints.maxWidth >= 980
                ? 4
                : constraints.maxWidth >= 640
                ? 2
                : 2;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LocationHeader(
                    user: widget.user,
                    token: widget.token,
                    onUserUpdated: widget.onUserUpdated,
                    onLogout: widget.onLogout,
                  ),
                  const SizedBox(height: 22),
                  _HeroPanel(
                    user: widget.user,
                    servicesUnlocked: _servicesUnlocked,
                    lastSosPosition: _lastSosPosition,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        EmergencySosButton(
                          enabled: widget.user != null,
                          activated: _servicesUnlocked,
                          isBusy: _isTriggeringSos,
                          onTriggered: _handleSosTriggered,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _servicesUnlocked
                              ? 'Nearby emergency access is active.'
                              : 'Hold the SOS button continuously for 3 seconds.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white70
                                : AppColors.textGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_servicesUnlocked) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _confirmResetSos,
                            icon: const Icon(
                              Icons.restart_alt_rounded,
                              size: 18,
                            ),
                            label: const Text('Reset SOS'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              side: BorderSide(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.28,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surface,
                          colorScheme.surface.withValues(
                            alpha: isDarkMode ? 0.86 : 0.96,
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: _servicesUnlocked
                            ? colorScheme.primary.withValues(alpha: 0.24)
                            : theme.dividerColor.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Emergency Services',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: colorScheme.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _servicesUnlocked
                                        ? 'Tap any service to open nearby results around your SOS location.'
                                        : 'These nearby service shortcuts unlock after a successful SOS hold.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      height: 1.4,
                                      color: isDarkMode
                                          ? Colors.white60
                                          : AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (_servicesUnlocked
                                            ? colorScheme.primary
                                            : Colors.grey)
                                        .withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _servicesUnlocked ? 'ACTIVE' : 'LOCKED',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: _servicesUnlocked
                                      ? colorScheme.primary
                                      : isDarkMode
                                      ? Colors.white60
                                      : AppColors.textGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: services.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: isTablet ? 1.56 : 1.32,
                              ),
                          itemBuilder: (context, index) {
                            final item = services[index];
                            final tile = QuickActionTile(
                              title: item.homeLabel,
                              subtitle: item.homeSubtitle,
                              callLabel: 'Call ${item.quickCallNumber}',
                              icon: item.icon,
                              iconColor: item.color,
                              onTap: () => _handleServiceTap(item),
                            );

                            if (_servicesUnlocked) {
                              return tile;
                            }

                            return Opacity(
                              opacity: 0.52,
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                                child: tile,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleSosTriggered() async {
    final currentUser = widget.user;
    if (currentUser == null) {
      _showMessage('Please sign in before triggering SOS.', error: true);
      return;
    }

    setState(() => _isTriggeringSos = true);

    try {
      final position = await _fetchCurrentPosition();
      await BackendApiService.instance.logSosEvent(
        userId: currentUser.id,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _servicesUnlocked = true;
        _lastSosPosition = position;
      });
      _showMessage(
        'SOS logged successfully. Nearby services are now unlocked.',
      );
    } catch (error) {
      _showMessage(error.toString(), error: true);
    } finally {
      if (mounted) {
        setState(() => _isTriggeringSos = false);
      }
    }
  }

  Future<Position> _fetchCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Turn on location services before sending an SOS.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission was denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Enable it in system settings.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(_locationTimeout);
    } on TimeoutException {
      final lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        return lastKnownPosition;
      }
      throw Exception(
        'Location lookup took too long. Move to an open area or check GPS/network and try again.',
      );
    }
  }

  Future<void> _confirmResetSos() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset SOS'),
          content: const Text(
            'This will end emergency mode and lock the nearby service shortcuts again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true || !mounted) {
      return;
    }

    setState(() {
      _servicesUnlocked = false;
      _lastSosPosition = null;
    });
    _showMessage('SOS has been reset. Nearby services are locked again.');
  }

  void _handleServiceTap(EmergencyServiceKind kind) {
    if (!_servicesUnlocked) {
      _showMessage(
        'Please hold the SOS button for 3 seconds first.',
        error: true,
      );
      return;
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => NearbyScreen(kind: kind)));
  }

  void _showMessage(String message, {bool error = false}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red.shade700 : AppColors.primaryRed,
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.user,
    required this.servicesUnlocked,
    required this.lastSosPosition,
  });

  final BackendUser? user;
  final bool servicesUnlocked;
  final Position? lastSosPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final fullName = user?.fullName.trim() ?? '';
    final firstName = fullName.isEmpty
        ? 'Responder'
        : fullName.split(' ').first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? const [Color(0xFF25151A), Color(0xFF151B23)]
              : const [Color(0xFFFFE7EB), Color(0xFFF7F5F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(
              alpha: isDarkMode ? 0.18 : 0.12,
            ),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stay Ready, $firstName',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hold SOS only in a real emergency to unlock nearby help fast.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.35,
                        color: isDarkMode ? Colors.white70 : AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatusChip(
                icon: servicesUnlocked
                    ? Icons.lock_open_rounded
                    : Icons.lock_outline_rounded,
                label: servicesUnlocked
                    ? 'Services Unlocked'
                    : 'Services Locked',
                color: servicesUnlocked ? Colors.green : colorScheme.primary,
              ),
              _StatusChip(
                icon: Icons.my_location_rounded,
                label: lastSosPosition == null
                    ? 'Location Pending'
                    : '${lastSosPosition!.latitude.toStringAsFixed(4)}, ${lastSosPosition!.longitude.toStringAsFixed(4)}',
                color: AppColors.policeBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
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
    final theme = Theme.of(context);
    final location = (user?.location ?? user?.address ?? '').trim();
    final displayLocation = location.isEmpty ? 'Set location' : location;

    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 210),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  displayLocation,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Text('KhmerSOS', style: AppTextStyles.appTitle),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            size: 22,
            color: theme.colorScheme.onSurface,
          ),
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
