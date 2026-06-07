import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final sanitized = phoneNumber.replaceAll(' ', '');
    final uri = Uri.parse('tel:$sanitized');
    return launchUrl(uri);
  }

  static Future<bool> openMapDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&travelmode=driving',
    );

    return launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
  }

  static Future<bool> openGoogleMapSearch({required LatLng destination}) async {
    final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${destination.latitude},${destination.longitude}',
    );

    return launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
  }
}
