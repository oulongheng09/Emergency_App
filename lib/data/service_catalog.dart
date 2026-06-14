import 'package:emergency_front_end/models/emergency_service_kind.dart';
import 'package:emergency_front_end/models/service_location.dart';
import 'package:latlong2/latlong.dart';

class NearbyScreenContent {
  const NearbyScreenContent({
    required this.kind,
    required this.protocolTitle,
    required this.protocolBody,
    required this.nearbyItems,
    this.helpBullets = const <String>[],
    this.tags = const <String>[],
    this.footerNote,
  });

  final EmergencyServiceKind kind;
  final String protocolTitle;
  final String protocolBody;
  final List<ServiceLocation> nearbyItems;
  final List<String> helpBullets;
  final List<String> tags;
  final String? footerNote;
}

const List<ServiceLocation> hospitalLocations = [
  ServiceLocation(
    id: 'calmette-hospital',
    kind: EmergencyServiceKind.hospital,
    name: 'Calmette Hospital',
    address: '80 Preah Monivong Blvd',
    phone: '+855 23 426 948',
    distanceLabel: '0.8 KM',
    badgeLabel: 'Emergency 24/7',
    statusLabel: '24/7 OPEN',
    summaryTitle: 'Critical Services',
    summaryBody:
        'Full-service emergency department with trauma, ICU, and surgical support.',
    detailHighlights: [
      'Emergency Room (ER)',
      'Intensive Care Unit (ICU)',
      'Trauma Center',
    ],
    position: LatLng(11.581249846995929, 104.91659107340058),
  ),
  ServiceLocation(
    id: 'central-general-hospital',
    kind: EmergencyServiceKind.hospital,
    name: 'Central General Hospital',
    address: '900 University Ave, Downtown',
    phone: '+855 23 358 110',
    distanceLabel: '1.2 KM',
    badgeLabel: 'Trauma Level I',
    statusLabel: 'OPEN NOW',
    summaryTitle: 'Critical Services',
    summaryBody:
        'Advanced trauma care with emergency diagnostics and overnight observation.',
    detailHighlights: [
      'Emergency Room (ER)',
      'Radiology Unit',
      'Trauma Surgery',
    ],
    position: LatLng(11.5732, 104.9126),
  ),
  ServiceLocation(
    id: 'metro-childrens-clinic',
    kind: EmergencyServiceKind.hospital,
    name: "Metro Children's Clinic",
    address: '12 East Parkside Dr, West End',
    phone: '+855 12 562 104',
    distanceLabel: '2.5 KM',
    badgeLabel: 'Pediatric Specialists',
    statusLabel: 'OPEN NOW',
    summaryTitle: 'Critical Services',
    summaryBody:
        'Pediatric urgent care with child-focused emergency triage and treatment.',
    detailHighlights: ['Pediatric ER', 'Rapid Assessment', 'Observation Ward'],
    position: LatLng(11.5695, 104.9402),
  ),
  ServiceLocation(
    id: 'north-point-urgent-care',
    kind: EmergencyServiceKind.hospital,
    name: 'North Point Urgent Care',
    address: '677 Industrial Way, Suite B',
    phone: '+855 81 334 222',
    distanceLabel: '3.1 KM',
    badgeLabel: 'Wait Time: 15 min',
    statusLabel: 'OPEN NOW',
    summaryTitle: 'Critical Services',
    summaryBody:
        'Fast-response urgent care center for moderate injuries and acute illness.',
    detailHighlights: ['Urgent Care', 'Minor Procedures', 'X-Ray Support'],
    position: LatLng(11.5881, 104.9027),
  ),
  ServiceLocation(
    id: 'lakeside-rehab-center',
    kind: EmergencyServiceKind.hospital,
    name: 'Lakeside Rehab Center',
    address: '22 Shoreline Dr, Port Area',
    phone: '+855 95 401 776',
    distanceLabel: '4.5 KM',
    badgeLabel: 'Specialized Care',
    statusLabel: 'OPEN NOW',
    summaryTitle: 'Critical Services',
    summaryBody:
        'Rehabilitation and stabilization support for patients needing specialized recovery.',
    detailHighlights: [
      'Stabilization Unit',
      'Physical Rehab',
      'Specialist Referral',
    ],
    position: LatLng(11.5554, 104.9496),
  ),
];

const List<ServiceLocation> policeLocations = [
  ServiceLocation(
    id: 'precinct-14-central',
    kind: EmergencyServiceKind.police,
    name: 'Precinct 14 - Central',
    address: '452 Industrial Way, Downtown District',
    phone: '117',
    distanceLabel: '0.8 KM',
    badgeLabel: '24/7 Patrol Hub',
    statusLabel: 'ACTIVE',
    summaryTitle: 'Emergency Protocol',
    summaryBody:
        'Report threats to public safety, theft, assault, accidents with injuries, or suspicious activity.',
    detailHighlights: [
      'Emergency Dispatch',
      'Public Incident Desk',
      'Traffic Response Unit',
    ],
    position: LatLng(11.567026688275075, 104.88993483957647),
  ),
  ServiceLocation(
    id: 'eastside-substation',
    kind: EmergencyServiceKind.police,
    name: 'Eastside Substation',
    address: '939 Harbor View Drive, East Gate',
    phone: '117',
    distanceLabel: '2.4 KM',
    badgeLabel: 'Community Outreach',
    statusLabel: 'ACTIVE',
    summaryTitle: 'Emergency Protocol',
    summaryBody:
        'Supports non-violent incident reporting, neighborhood patrol requests, and local coordination.',
    detailHighlights: [
      'Patrol Dispatch',
      'Incident Reports',
      'Community Support',
    ],
    position: LatLng(11.563483167664263, 104.89847623289963),
  ),
  ServiceLocation(
    id: 'police-training-center',
    kind: EmergencyServiceKind.police,
    name: 'Police Training Center',
    address: '10 Academy Rd, North Plains',
    phone: '117',
    distanceLabel: '5.1 KM',
    badgeLabel: 'Limited Public Access',
    statusLabel: 'ACTIVE',
    summaryTitle: 'Emergency Protocol',
    summaryBody:
        'Public support is limited here, but emergency transfer and dispatch can still be coordinated.',
    detailHighlights: [
      'Dispatch Support',
      'Training Unit',
      'Transfer Coordination',
    ],
    position: LatLng(11.5928, 104.8732),
  ),
];

const List<ServiceLocation> ambulanceLocations = [
  ServiceLocation(
    id: 'st-jude-urgent-care',
    kind: EmergencyServiceKind.ambulance,
    name: 'St. Jude Urgent Care',
    address: '1200 Carlton Drive, Sector 3',
    phone: '119',
    distanceLabel: '0.8 KM',
    badgeLabel: 'Ambulance Available',
    statusLabel: 'READY',
    summaryTitle: 'When to Call',
    summaryBody:
        'Call when someone is unconscious, has severe chest pain, trouble breathing, or major trauma.',
    detailHighlights: [
      'Emergency Pickup',
      'Paramedic Team',
      'Hospital Transfer',
    ],
    position: LatLng(11.5752, 104.9076),
  ),
  ServiceLocation(
    id: 'metro-paramedics-unit4',
    kind: EmergencyServiceKind.ambulance,
    name: 'Metro Paramedics Unit 4',
    address: '5 Stationed at 5th Main St.',
    phone: '119',
    distanceLabel: '1.2 KM',
    badgeLabel: 'Ambulance Dispatched',
    statusLabel: 'READY',
    summaryTitle: 'When to Call',
    summaryBody:
        'Use emergency medical transport for life-threatening injuries, collapse, or severe bleeding.',
    detailHighlights: ['Rapid Dispatch', 'Trauma Transport', 'On-Scene Triage'],
    position: LatLng(11.5719, 104.9204),
  ),
];

const List<ServiceLocation> fireLocations = [
  ServiceLocation(
    id: 'station-42-downtown',
    kind: EmergencyServiceKind.fireDepartment,
    name: 'Station 42 - Downtown',
    address: '452 Pine St, Central Business District, Metro',
    phone: '118',
    distanceLabel: '0.8 KM',
    badgeLabel: 'Rescue Unit Active',
    statusLabel: 'ON DUTY',
    summaryTitle: 'Safety First',
    summaryBody:
        'Evacuate immediately before making an emergency call. Do not use elevators during a fire.',
    detailHighlights: ['Active Fire', 'Rescue', 'Hazmat Support'],
    position: LatLng(11.560595328679938, 104.91573581716146),
  ),
  ServiceLocation(
    id: 'station-19-northside',
    kind: EmergencyServiceKind.fireDepartment,
    name: 'Station 19 - Northside',
    address: '1320 North Blvd, Industrial Park, Metro City',
    phone: '118',
    distanceLabel: '2.4 KM',
    badgeLabel: 'Standby Mode',
    statusLabel: 'ON DUTY',
    summaryTitle: 'Safety First',
    summaryBody:
        'Fire crews coordinate rescue, structure fire response, and gas leak containment in the district.',
    detailHighlights: ['Gas Leak', 'Accident Rescue', 'Containment Crew'],
    position: LatLng(11.55096730920578, 104.94291523979894),
  ),
];

ServiceLocation? findServiceLocationById(String id) {
  for (final item in allServiceLocations) {
    if (item.id == id) {
      return item;
    }
  }
  return null;
}

List<ServiceLocation> get allServiceLocations => [
  ...hospitalLocations,
  ...policeLocations,
  ...ambulanceLocations,
  ...fireLocations,
];

List<ServiceLocation> locationsForKind(EmergencyServiceKind kind) {
  switch (kind) {
    case EmergencyServiceKind.hospital:
      return hospitalLocations;
    case EmergencyServiceKind.police:
      return policeLocations;
    case EmergencyServiceKind.ambulance:
      return ambulanceLocations;
    case EmergencyServiceKind.fireDepartment:
      return fireLocations;
  }
}

NearbyScreenContent nearbyContentFor(EmergencyServiceKind kind) {
  switch (kind) {
    case EmergencyServiceKind.hospital:
      return NearbyScreenContent(
        kind: kind,
        protocolTitle: 'Emergency Support',
        protocolBody:
            'Access hospital emergency rooms, critical care, and urgent treatment facilities in your area.',
        nearbyItems: hospitalLocations.take(3).toList(),
      );
    case EmergencyServiceKind.police:
      return NearbyScreenContent(
        kind: kind,
        protocolTitle: 'Emergency Protocol',
        protocolBody:
            'Contact the Police Department immediately for active crimes, threats to public safety, traffic accidents with injuries, or suspicious activity. For non-emergencies, use the nearby stations below.',
        nearbyItems: policeLocations,
        footerNote: 'Abuse of emergency lines is a punishable offense.',
      );
    case EmergencyServiceKind.ambulance:
      return NearbyScreenContent(
        kind: kind,
        protocolTitle: 'When to Call',
        protocolBody: '',
        nearbyItems: ambulanceLocations,
        helpBullets: const [
          'Unconsciousness or severe chest pain',
          'Difficulty breathing or severe bleeding',
          'Suspected stroke or major trauma',
        ],
      );
    case EmergencyServiceKind.fireDepartment:
      return NearbyScreenContent(
        kind: kind,
        protocolTitle: 'Safety First',
        protocolBody:
            'Evacuate immediately before making an emergency call. Do not use elevators during a fire.',
        nearbyItems: fireLocations,
        tags: const ['Active Fire', 'Rescue', 'Gas Leak', 'Accident'],
      );
  }
}
