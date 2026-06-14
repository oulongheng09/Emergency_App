import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../models/service_location.dart';
import '../../models/emergency_service_kind.dart';

class EmergencyServicesApi {
  static const String baseUrl = 'http://localhost:3001';

  Future<List<ServiceLocation>> getAllServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/emergency-services'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        return data
            .map((item) => _parseServiceLocation(item as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load services: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ServiceLocation>> getNearbyServices({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/emergency-services/nearby?lat=$latitude&lng=$longitude',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((item) => _parseServiceLocation(item as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load nearby services: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceLocation> getServiceById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/emergency-services/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return _parseServiceLocation(data);
      }

      throw Exception('Failed to load service: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  ServiceLocation _parseServiceLocation(Map<String, dynamic> data) {
    final serviceTypeData = data['serviceType'] as Map<String, dynamic>?;
    final serviceTypeName = serviceTypeData?['name'] as String? ?? 'Hospital';
    final kind = _getServiceKindFromTypeName(serviceTypeName);

    final latitude = double.tryParse(data['latitude'].toString()) ?? 0.0;
    final longitude = double.tryParse(data['longitude'].toString()) ?? 0.0;

    debugPrint(
      '📍 Parsed service: ${data['name']} - Type: $serviceTypeName → Kind: ${kind.title}',
    );

    return ServiceLocation(
      id: data['id'] as String? ?? '',
      kind: kind,
      name: data['name'] as String? ?? 'Unknown Service',
      address: data['address'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      distanceLabel: 'Distance',
      badgeLabel: _getBadgeLabel(data),
      statusLabel: (data['is_active'] as bool? ?? true) ? 'OPEN' : 'CLOSED',
      summaryTitle: '${kind.listTitle} Services',
      summaryBody:
          data['description'] as String? ??
          'Professional emergency services available',
      detailHighlights: _parseHighlights(kind),
      position: LatLng(latitude, longitude),
    );
  }

  EmergencyServiceKind _getServiceKindFromTypeName(String typeName) {
    final typeNameLower = typeName.toLowerCase();

    if (typeNameLower.contains('police')) {
      return EmergencyServiceKind.police;
    } else if (typeNameLower.contains('fire')) {
      return EmergencyServiceKind.fireDepartment;
    } else if (typeNameLower.contains('ambulance')) {
      return EmergencyServiceKind.ambulance;
    } else if (typeNameLower.contains('hospital')) {
      return EmergencyServiceKind.hospital;
    }

    debugPrint('⚠️ Unknown service type: $typeName, defaulting to hospital');
    return EmergencyServiceKind.hospital;
  }

  String _getBadgeLabel(Map<String, dynamic> data) {
    final hours = data['opening_hours'] as String?;
    if (hours?.contains('24') ?? false) {
      return 'Available 24/7';
    }
    return 'Regular Hours';
  }

  List<String> _parseHighlights(EmergencyServiceKind kind) {
    switch (kind) {
      case EmergencyServiceKind.hospital:
        return [
          'Emergency Room (ER)',
          'Intensive Care Unit (ICU)',
          'Trauma Center',
        ];
      case EmergencyServiceKind.police:
        return ['Police Response', 'Emergency Assistance', 'Law Enforcement'];
      case EmergencyServiceKind.fireDepartment:
        return ['Fire Response', 'Rescue Operations', 'Emergency Dispatch'];
      case EmergencyServiceKind.ambulance:
        return ['Ambulance Transport', 'Medical Response', 'Emergency Care'];
    }
  }
}
