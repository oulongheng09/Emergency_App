import 'package:emergency_front_end/models/emergency_service_kind.dart';
import 'package:latlong2/latlong.dart';

class ServiceLocation {
  const ServiceLocation({
    required this.id,
    required this.kind,
    required this.name,
    required this.address,
    required this.phone,
    required this.distanceLabel,
    required this.badgeLabel,
    required this.statusLabel,
    required this.summaryTitle,
    required this.summaryBody,
    required this.detailHighlights,
    required this.position,
  });

  final String id;
  final EmergencyServiceKind kind;
  final String name;
  final String address;
  final String phone;
  final String distanceLabel;
  final String badgeLabel;
  final String statusLabel;
  final String summaryTitle;
  final String summaryBody;
  final List<String> detailHighlights;
  final LatLng position;
}
