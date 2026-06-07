import 'package:latlong2/latlong.dart';

class DistanceUtils {
  static const Distance _distance = Distance();

  static double kilometersBetween(LatLng start, LatLng end) {
    return _distance.as(LengthUnit.Kilometer, start, end);
  }
}
