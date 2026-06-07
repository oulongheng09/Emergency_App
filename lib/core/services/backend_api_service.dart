import 'dart:convert';
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
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
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
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    final user = _readUser(data);
    if (user == null) {
      throw const BackendApiException(500, 'Update response missing user.');
    }
    return user;
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

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}$path');
    late final http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
              ...?headers,
            },
            body: jsonEncode(body ?? <String, dynamic>{}),
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
              ...?headers,
            },
            body: jsonEncode(body ?? <String, dynamic>{}),
          );
          break;
        default:
          throw const BackendApiException(500, 'Unsupported request method.');
      }
    } catch (error) {
      throw BackendApiException(503, 'Unable to connect to the backend: $error');
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
      return BackendUser.fromJson(json);
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
}
