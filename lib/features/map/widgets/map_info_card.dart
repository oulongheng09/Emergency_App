import 'package:emergency_front_end/core/utils/distance_utils.dart';
import 'package:emergency_front_end/features/map/models/emergency_place.dart';
import 'package:emergency_front_end/features/map/models/emergency_place_distance.dart';
import 'package:emergency_front_end/features/map/models/route_data.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapInfoCard extends StatelessWidget {
  const MapInfoCard({
    super.key,
    required this.isExpanded,
    required this.isLoadingLocation,
    required this.isLoadingRoute,
    required this.isLaunchingDirections,
    required this.locationMessage,
    required this.routeMessage,
    required this.currentPosition,
    required this.selectedPlace,
    required this.activeRoute,
    required this.places,
    required this.onRefreshLocation,
    required this.onPlaceSelected,
    required this.onOpenDirections,
    required this.onToggleExpanded,
  });

  final bool isExpanded;
  final bool isLoadingLocation;
  final bool isLoadingRoute;
  final bool isLaunchingDirections;
  final String? locationMessage;
  final String? routeMessage;
  final Position? currentPosition;
  final EmergencyPlace? selectedPlace;
  final RouteData? activeRoute;
  final List<EmergencyPlaceDistance> places;
  final Future<void> Function() onRefreshLocation;
  final ValueChanged<EmergencyPlace> onPlaceSelected;
  final Future<void> Function() onOpenDirections;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return CollapsedMapPanel(
        selectedPlace: selectedPlace,
        activeRoute: activeRoute,
        isLoadingRoute: isLoadingRoute,
        onTap: onToggleExpanded,
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Emergency routes',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              IconButton(
                onPressed: onToggleExpanded,
                icon: const Icon(Icons.close_fullscreen, size: 18),
                visualDensity: VisualDensity.compact,
              ),
              TextButton.icon(
                onPressed: onRefreshLocation,
                icon: const Icon(Icons.gps_fixed, size: 16),
                label: const Text('Refresh'),
              ),
            ],
          ),
          if (isLoadingLocation)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: LinearProgressIndicator(
                minHeight: 4,
                color: AppColors.primaryRed,
                backgroundColor: AppColors.lightRed,
              ),
            )
          else if (locationMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(locationMessage!, style: AppTextStyles.body),
            )
          else if (currentPosition != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Your live location is active. Tap any emergency place to load a real road route.',
                style: AppTextStyles.body,
              ),
            ),
          if (routeMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(routeMessage!, style: AppTextStyles.body),
            ),
          if (selectedPlace != null) ...[
            SelectedPlaceCard(
              place: selectedPlace!,
              currentPosition: currentPosition,
              activeRoute: activeRoute,
              isLoadingRoute: isLoadingRoute,
              onOpenDirections: onOpenDirections,
              isLaunchingDirections: isLaunchingDirections,
            ),
            const SizedBox(height: 12),
          ],
          const Text('Tap a place to route', style: AppTextStyles.label),
          const SizedBox(height: 8),
          ...places.map(
            (item) => NearbyPlaceTile(
              item: item,
              isSelected: selectedPlace == item.place,
              onTap: () => onPlaceSelected(item.place),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedPlaceCard extends StatelessWidget {
  const SelectedPlaceCard({
    super.key,
    required this.place,
    required this.currentPosition,
    required this.activeRoute,
    required this.isLoadingRoute,
    required this.onOpenDirections,
    required this.isLaunchingDirections,
  });

  final EmergencyPlace place;
  final Position? currentPosition;
  final RouteData? activeRoute;
  final bool isLoadingRoute;
  final Future<void> Function() onOpenDirections;
  final bool isLaunchingDirections;

  @override
  Widget build(BuildContext context) {
    final distanceLabel = activeRoute != null
        ? '${activeRoute!.distanceKm.toStringAsFixed(1)} km road route'
        : currentPosition == null
        ? 'Waiting for your location'
        : '${DistanceUtils.kilometersBetween(LatLng(currentPosition!.latitude, currentPosition!.longitude), place.position).toStringAsFixed(1)} km away';

    final durationLabel = activeRoute == null
        ? null
        : '${activeRoute!.durationMinutes.round()} min estimated drive';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: place.type.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: place.type.color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: place.type.color,
                child: Icon(place.type.icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, style: AppTextStyles.label),
                    const SizedBox(height: 2),
                    Text(place.address, style: AppTextStyles.small),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isLoadingRoute
                ? 'Loading the road route to this emergency place...'
                : 'Road-following route loaded for this emergency place.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 4),
          Text(
            distanceLabel,
            style: TextStyle(
              color: place.type.color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (durationLabel != null) ...[
            const SizedBox(height: 2),
            Text(durationLabel, style: AppTextStyles.small),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  currentPosition == null ||
                      isLaunchingDirections ||
                      isLoadingRoute
                  ? null
                  : onOpenDirections,
              style: ElevatedButton.styleFrom(
                backgroundColor: place.type.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: isLaunchingDirections
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.navigation),
              label: Text(
                isLaunchingDirections ? 'Opening...' : 'Live Navigation',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NearbyPlaceTile extends StatelessWidget {
  const NearbyPlaceTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final EmergencyPlaceDistance item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? item.place.type.color.withValues(alpha: 0.08)
              : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: item.place.type.color.withValues(alpha: 0.35))
              : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: item.place.type.color.withValues(alpha: 0.12),
              child: Icon(
                item.place.type.icon,
                size: 18,
                color: item.place.type.color,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.place.name, style: AppTextStyles.label),
                  const SizedBox(height: 2),
                  Text(item.place.address, style: AppTextStyles.small),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.distanceKm == null
                      ? 'Nearby'
                      : '${item.distanceKm!.toStringAsFixed(1)} km',
                  style: TextStyle(
                    color: item.place.type.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSelected ? 'Selected' : 'Route',
                  style: TextStyle(
                    color: item.place.type.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CollapsedMapPanel extends StatelessWidget {
  const CollapsedMapPanel({
    super.key,
    required this.selectedPlace,
    required this.activeRoute,
    required this.isLoadingRoute,
    required this.onTap,
  });

  final EmergencyPlace? selectedPlace;
  final RouteData? activeRoute;
  final bool isLoadingRoute;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = selectedPlace?.name ?? 'Emergency routes';
    final subtitle = isLoadingRoute
        ? 'Loading road route...'
        : activeRoute != null
        ? '${activeRoute!.distanceKm.toStringAsFixed(1)} km | ${activeRoute!.durationMinutes.round()} min'
        : 'Tap to show routes and directions';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.alt_route, color: AppColors.primaryRed),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.small),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.keyboard_arrow_up, color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}
