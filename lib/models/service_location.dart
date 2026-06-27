import 'package:emergency_front_end/models/emergency_service_kind.dart';
import 'package:emergency_front_end/l10n/app_text.dart';
import 'package:latlong2/latlong.dart';

class ServiceLocation {
  const ServiceLocation({
    required this.id,
    required this.kind,
    required this.name,
    this.nameKm,
    required this.address,
    this.addressKm,
    required this.phone,
    required this.distanceLabel,
    required this.badgeLabel,
    this.badgeLabelKm,
    required this.statusLabel,
    this.statusLabelKm,
    required this.summaryTitle,
    this.summaryTitleKm,
    required this.summaryBody,
    this.summaryBodyKm,
    required this.detailHighlights,
    this.detailHighlightsKm = const [],
    required this.position,
  });

  final String id;
  final EmergencyServiceKind kind;
  final String name;
  final String? nameKm;
  final String address;
  final String? addressKm;
  final String phone;
  final String distanceLabel;
  final String badgeLabel;
  final String? badgeLabelKm;
  final String statusLabel;
  final String? statusLabelKm;
  final String summaryTitle;
  final String? summaryTitleKm;
  final String summaryBody;
  final String? summaryBodyKm;
  final List<String> detailHighlights;
  final List<String> detailHighlightsKm;
  final LatLng position;

  String get localizedName =>
      AppLocaleState.isKhmer && nameKm != null ? nameKm! : name;
  String get localizedAddress =>
      AppLocaleState.isKhmer && addressKm != null ? addressKm! : address;
  String get localizedBadgeLabel =>
      AppLocaleState.isKhmer && badgeLabelKm != null
      ? badgeLabelKm!
      : badgeLabel;
  String get localizedStatusLabel =>
      AppLocaleState.isKhmer && statusLabelKm != null
      ? statusLabelKm!
      : statusLabel;
  String get localizedSummaryTitle =>
      AppLocaleState.isKhmer && summaryTitleKm != null
      ? summaryTitleKm!
      : summaryTitle;
  String get localizedSummaryBody =>
      AppLocaleState.isKhmer && summaryBodyKm != null
      ? summaryBodyKm!
      : summaryBody;
  List<String> get localizedDetailHighlights =>
      AppLocaleState.isKhmer && detailHighlightsKm.isNotEmpty
      ? detailHighlightsKm
      : detailHighlights;
}
