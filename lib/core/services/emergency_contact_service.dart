import 'dart:convert';
import 'package:http/http.dart' as http;

class EmergencyContactService {
  static const String baseUrl = 'http://localhost:3001';

  Future<List<dynamic>> getContacts(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-emergency-contacts/user/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load contacts');
  }

  Future<void> createContact({
    required String userId,
    required String name,
    required String relationship,
    required String phone,
  }) async {
    await http.post(
      Uri.parse('$baseUrl/user-emergency-contacts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'name': name,
        'relationship': relationship,
        'phone_number': int.parse(phone),
      }),
    );
  }

  Future<void> updateContact({
    required String id,
    required String name,
    required String relationship,
    required String phone,
  }) async {
    await http.patch(
      Uri.parse('$baseUrl/user-emergency-contacts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'relationship': relationship,
        'phone_number': int.parse(phone),
      }),
    );
  }

  Future<void> deleteContact(String id) async {
    await http.delete(Uri.parse('$baseUrl/user-emergency-contacts/$id'));
  }
}
