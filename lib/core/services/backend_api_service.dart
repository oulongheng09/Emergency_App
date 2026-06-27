import 'dart:async';
import 'dart:convert';
import 'package:emergency_front_end/models/first_aid_category.dart';
import 'package:http/http.dart' as http;
import '../../models/backend_session.dart';
import '../../models/backend_user.dart';
import '../constants/app_constants.dart';

class BackendApiException implements Exception {
  final int statusCode;
  final String message;

  const BackendApiException(this.statusCode, this.message);

  @override
  String toString() => 'BackendApiException($statusCode): $message';
}

class BackendApiService {
  BackendApiService._();

  static final BackendApiService instance = BackendApiService._();
  static const Duration _requestTimeout = Duration(seconds: 15);
  String _languageCode = 'en';

  void setLanguageCode(String languageCode) {
    if (languageCode.trim().isEmpty) {
      _languageCode = 'en';
      return;
    }
    _languageCode = languageCode.toLowerCase();
  }

  Future<BackendSession> login({
    required String email,
    required String password,
  }) async {
    final data = await _postJson('/auth/login', <String, dynamic>{
      'email': email,
      'password': password,
    });
    final session = _readSession(data['session'] as Map<String, dynamic>?);
    final user = _readUser(data['user']);
    return BackendSession(token: session.token, user: user);
  }

  Future<BackendUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final data = await _postJson('/auth/register', <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'password': password,
    });
    final user = _readUser(data['user']);
    if (user == null) {
      throw const BackendApiException(500, 'Register response missing user.');
    }
    return user;
  }

  Future<BackendUser?> fetchCurrentUser(String token) async {
    final data = await _getJson(
      '/auth/me',
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );
    return _readUser(data);
  }

  Future<BackendUser> updateUser({
    required String token,
    required String userId,
    required Map<String, dynamic> payload,
  }) async {
    final data = await _patchJson(
      '/users/$userId',
      payload,
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );
    final user = _readUser(data);
    if (user == null) {
      throw const BackendApiException(500, 'Update response missing user.');
    }
    return user;
  }

  Future<Map<String, dynamic>> logSosEvent({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    final nearbyServices = await _requestList(
      'GET',
      '/emergency-services/nearby?lat=$latitude&lng=$longitude',
    );

    if (nearbyServices.isEmpty) {
      throw const BackendApiException(
        404,
        'No nearby emergency services were returned for this SOS event.',
      );
    }

    final nearestService = nearbyServices.first;
    final serviceId = nearestService['id']?.toString() ?? '';
    if (serviceId.isEmpty) {
      throw const BackendApiException(
        500,
        'Nearby emergency service response is missing an id.',
      );
    }

    return _postJson('/sos-logs', <String, dynamic>{
      'user_id': userId,
      'service_id': serviceId,
      'user_latitude': latitude,
      'user_longitude': longitude,
    });
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    Map<String, String>? headers,
  }) async {
    return _request('GET', path, headers: headers);
  }

  Future<Map<String, dynamic>> _postJson(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    return _request('POST', path, body: body, headers: headers);
  }

  Future<Map<String, dynamic>> _patchJson(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    return _request('PATCH', path, body: body, headers: headers);
  }

  Future<List<dynamic>> _requestList(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}$path');
    late final http.Response response;
    final requestHeaders = _buildHeaders(headers);

    try {
      switch (method) {
        case 'GET':
          response = await http
              .get(uri, headers: requestHeaders)
              .timeout(_requestTimeout);
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: requestHeaders,
                body: jsonEncode(body ?? <String, dynamic>{}),
              )
              .timeout(_requestTimeout);
          break;
        default:
          throw const BackendApiException(500, 'Unsupported request method.');
      }
    } on TimeoutException {
      throw const BackendApiException(
        504,
        'The backend request timed out. Please check the server or your network and try again.',
      );
    } catch (error) {
      throw BackendApiException(
        503,
        'Unable to connect to the backend: $error',
      );
    }

    final responseText = response.body;
    final decoded = responseText.isEmpty
        ? <dynamic>[]
        : jsonDecode(responseText);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendApiException(
        response.statusCode,
        _extractMessage(decoded, responseText),
      );
    }

    if (decoded is List<dynamic>) {
      return decoded;
    }

    throw const BackendApiException(
      500,
      'Expected a list response from the backend.',
    );
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}$path');
    late final http.Response response;
    final requestHeaders = _buildHeaders(headers);

    try {
      switch (method) {
        case 'GET':
          response = await http
              .get(uri, headers: requestHeaders)
              .timeout(_requestTimeout);
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: requestHeaders,
                body: jsonEncode(body ?? <String, dynamic>{}),
              )
              .timeout(_requestTimeout);
          break;
        case 'PATCH':
          response = await http
              .patch(
                uri,
                headers: requestHeaders,
                body: jsonEncode(body ?? <String, dynamic>{}),
              )
              .timeout(_requestTimeout);
          break;
        default:
          throw const BackendApiException(500, 'Unsupported request method.');
      }
    } on TimeoutException {
      throw const BackendApiException(
        504,
        'The backend request timed out. Please check the server or your network and try again.',
      );
    } catch (error) {
      throw BackendApiException(
        503,
        'Unable to connect to the backend: $error',
      );
    }

    final responseText = response.body;
    final decoded = responseText.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(responseText);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendApiException(
        response.statusCode,
        _extractMessage(decoded, responseText),
      );
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{'data': decoded};
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    return <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
      'Accept-Language': _languageCode,
      ...?headers,
    };
  }

  BackendSession _readSession(Map<String, dynamic>? sessionJson) {
    if (sessionJson == null) {
      throw const BackendApiException(500, 'Login response missing session.');
    }
    final token =
        (sessionJson['access_token'] ??
                sessionJson['accessToken'] ??
                sessionJson['token'] ??
                '')
            .toString();
    if (token.isEmpty) {
      throw const BackendApiException(
        500,
        'Login response missing access token.',
      );
    }
    final user = _readUser(sessionJson['user']);
    return BackendSession(token: token, user: user);
  }

  BackendUser? _readUser(dynamic json) {
    if (json is Map<String, dynamic>) {
      final user = BackendUser.fromJson(json);
      return user;
    }
    return null;
  }

  String _extractMessage(dynamic decoded, String fallback) {
    if (decoded is Map<String, dynamic>) {
      final message = decoded['message'];
      if (message is String) {
        return message;
      }
      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      }
    }
    return fallback.isEmpty ? 'Request failed.' : fallback;
  }

  Future<List<FirstAidCategory>> fetchFirstAidCategories() async {
    final json = await _requestList(
      'GET',
      '/first-aid-categories?lang=$_languageCode',
    );
    return json.map((e) => FirstAidCategory.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> fetchFirstAidCategory(String id) async {
    return _getJson('/first-aid-categories/$id?lang=$_languageCode');
  }

  Future<List<dynamic>> getEmergencyContacts(String userId) async {
    return _requestList('GET', '/user-emergency-contacts/user/$userId');
  }

  Future<void> createEmergencyContact({
    required String userId,
    required String name,
    required String relationship,
    required String phone,
  }) async {
    await _postJson('/user-emergency-contacts', {
      'user_id': userId,
      'name': name,
      'relationship': relationship,
      'phone_number': int.parse(phone),
    });
  }

  Future<void> updateEmergencyContact({
    required String id,
    required String name,
    required String relationship,
    required String phone,
  }) async {
    await _patchJson('/user-emergency-contacts/$id', {
      'name': name,
      'relationship': relationship,
      'phone_number': int.parse(phone),
    });
  }

  Future<void> _delete(String path) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}$path');

    final response = await http.delete(uri).timeout(_requestTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendApiException(response.statusCode, response.body);
    }
  }

  Future<void> deleteEmergencyContact(String id) async {
    await _delete('/user-emergency-contacts/$id');
  }

  Future<List<dynamic>> getEmergencyContacts(String userId) async {
    return _requestList(
      'GET',
      '/user-emergency-contacts/user/$userId',
    );
  }

  Future<void> createEmergencyContact({
    required String userId,
    required String name,
    required String relationship,
    required String phone,
    }) async {
    await _postJson(
      '/user-emergency-contacts',
      {
        'user_id': userId,
        'name': name,
        'relationship': relationship,
        'phone_number': int.parse(phone),
      },
    );
  }

  Future<void> updateEmergencyContact({
    required String id,
    required String name,
    required String relationship,
    required String phone,
    }) async {
    await _patchJson(
      '/user-emergency-contacts/$id',
      {
        'name': name,
        'relationship': relationship,
        'phone_number': int.parse(phone),
      },
    );
  }

  Future<void> _delete(String path) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}$path');

    final response = await http
        .delete(uri)
        .timeout(_requestTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendApiException(
        response.statusCode,
        response.body,
      );
    }
  }

  Future<void> deleteEmergencyContact(String id) async {
    await _delete('/user-emergency-contacts/$id');
  }
  
}