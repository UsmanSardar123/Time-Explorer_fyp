import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:timeexplorer/core/config/app_config.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  bool get isUnauthorized => statusCode == 401;
  bool get isServerError => statusCode >= 500;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiNetworkException implements Exception {
  final String message;
  const ApiNetworkException(this.message);
  @override
  String toString() => 'ApiNetworkException: $message';
}

class ApiService {
  final String _baseUrl;
  final FirebaseAuth _auth;

  ApiService({String? baseUrl, FirebaseAuth? auth})
      : _baseUrl = baseUrl ?? AppConfig.backendBaseUrl,
        _auth = auth ?? FirebaseAuth.instance;

  Future<String?> _getToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      return await user.getIdToken();
    } catch (_) {
      return null;
    }
  }

  Map<String, String> _headers(String? token) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  dynamic _parse(http.Response response) {
    if (response.statusCode == 401) {
      throw const ApiException(401, 'Unauthorized — please sign in again.');
    }
    if (response.statusCode >= 500) {
      throw ApiException(response.statusCode, 'Server error. Please try again later.');
    }
    if (response.statusCode == 404) {
      throw ApiException(404, 'Resource not found.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String msg = 'Request failed (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map;
        msg = body['error']?.toString() ?? msg;
      } catch (_) {}
      throw ApiException(response.statusCode, msg);
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> get(String path) async {
    final token = await _getToken();
    debugPrint('[ApiService] GET $_baseUrl$path');
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token),
      ).timeout(const Duration(seconds: 15));
      return _parse(response);
    } on SocketException {
      throw const ApiNetworkException('No internet connection.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiNetworkException('Network error: $e');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final token = await _getToken();
    debugPrint('[ApiService] POST $_baseUrl$path');
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));
      return _parse(response);
    } on SocketException {
      throw const ApiNetworkException('No internet connection.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiNetworkException('Network error: $e');
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final token = await _getToken();
    debugPrint('[ApiService] PUT $_baseUrl$path');
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));
      return _parse(response);
    } on SocketException {
      throw const ApiNetworkException('No internet connection.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiNetworkException('Network error: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    final token = await _getToken();
    debugPrint('[ApiService] DELETE $_baseUrl$path');
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token),
      ).timeout(const Duration(seconds: 15));
      return _parse(response);
    } on SocketException {
      throw const ApiNetworkException('No internet connection.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiNetworkException('Network error: $e');
    }
  }

  Future<bool> healthCheck() async {
    try {
      // Health route is at /health, one level up from /api
      final base = _baseUrl.replaceAll(RegExp(r'/api$'), '');
      final response = await http
          .get(Uri.parse('$base/api/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
