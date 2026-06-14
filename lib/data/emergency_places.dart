import 'package:emergency_front_end/models/emergency_place.dart';
import 'package:latlong2/latlong.dart';

const List<EmergencyPlace> emergencyPlaces = [
  EmergencyPlace(
    name: 'Road Traffic Police Station',
    type: EmergencyPlaceType.police,
    position: LatLng(11.567026688275075, 104.88993483957647),
    address: 'Toul kork, Phnom Penh',
  ),
  EmergencyPlace(
    name: 'Teuk Laok 2 Police Station',
    type: EmergencyPlaceType.police,
    position: LatLng(11.563483167664263, 104.89847623289963),
    address: 'Teuk Laok 2, Phnom Penh',
  ),
  EmergencyPlace(
    name: 'Calmette Hospital',
    type: EmergencyPlaceType.hospital,
    position: LatLng(11.581249846995929, 104.91659107340058),
    address: 'Daun Penh, Phnom Penh',
  ),
  EmergencyPlace(
    name: 'Preah Kossomak Hospital',
    type: EmergencyPlaceType.hospital,
    position: LatLng(11.564278727369357, 104.88979557938497),
    address: 'Toul Kork, Phnom Penh',
  ),
  EmergencyPlace(
    name: 'Preah Ket Mealea Hospital',
    type: EmergencyPlaceType.hospital,
    position: LatLng(11.580089610079789, 104.92175853518351),
    address: '7 Makara, Phnom Penh',
  ),
  EmergencyPlace(
    name: 'Olympia City Fire Station',
    type: EmergencyPlaceType.fireStation,
    position: LatLng(11.560595328679938, 104.91573581716146),
    address: 'Olympic, Phnom Penh',
  ),
  EmergencyPlace(
    name: 'Koh Pich Fire Station',
    type: EmergencyPlaceType.fireStation,
    position: LatLng(11.55096730920578, 104.94291523979894),
    address: 'Chamkar Mon, Phnom Penh',
  ),
];
