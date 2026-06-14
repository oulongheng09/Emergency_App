import 'dart:convert';
import 'package:http/http.dart' as http;

class EmergencyContactService {
  static const String baseUrl = 'http://localhost:3001';

  Future<List<dynamic>> getContacts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-emergency-contacts/user/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data is List ? data : [];
      }

      throw Exception(
        'Failed to load contacts: ${response.statusCode} ${response.body}',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createContact({
    required String userId,
    required String name,
    required String relationship,
    required String phone,
  }) async {
    try {
      final body = {
        'user_id': userId,
        'name': name,
        'relationship': relationship,
        'phone_number': int.parse(phone),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/user-emergency-contacts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Failed to create contact: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateContact({
    required String id,
    required String name,
    required String relationship,
    required String phone,
  }) async {
    try {
      final body = {
        'name': name,
        'relationship': relationship,
        'phone_number': int.parse(phone),
      };
      final response = await http.patch(
        Uri.parse('$baseUrl/user-emergency-contacts/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update contact: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/user-emergency-contacts/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete contact: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
