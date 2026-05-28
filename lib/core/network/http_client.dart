import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpClient {
  final http.Client _client;
  final String baseUrl;
  String? _token;

  HttpClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  void setToken(String? token) {
    _token = token;
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    return _request(
      (uri, hdrs) => _client.get(uri, headers: hdrs),
      path,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _request(
      (uri, hdrs) => _client.post(uri, headers: hdrs, body: body != null ? jsonEncode(body) : null),
      path,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _request(
      (uri, hdrs) => _client.put(uri, headers: hdrs, body: body != null ? jsonEncode(body) : null),
      path,
      headers: headers,
    );
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? headers,
  }) async {
    final result = await _requestRaw(
      (uri, hdrs) => _client.get(uri, headers: hdrs),
      path,
      headers: headers,
    );
    return result as List<dynamic>;
  }

  Future<void> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    await _requestRaw(
      (uri, hdrs) => _client.delete(uri, headers: hdrs),
      path,
      headers: headers,
      includeContentType: false,
    );
  }

  Future<Map<String, dynamic>> _request(
    Future<http.Response> Function(Uri, Map<String, String>) requestFn,
    String path, {
    Map<String, String>? headers,
  }) async {
    final result = await _requestRaw(requestFn, path, headers: headers);
    return _asMap(result);
  }

  Future<dynamic> _requestRaw(
    Future<http.Response> Function(Uri, Map<String, String>) requestFn,
    String path, {
    Map<String, String>? headers,
    bool includeContentType = true,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final defaultHeaders = <String, String>{
        'Accept': 'application/json',
      };

      if (includeContentType) {
        defaultHeaders['Content-Type'] = 'application/json';
      }

      if (_token != null) {
        defaultHeaders['Authorization'] = 'Bearer $_token';
      }

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      final response = await requestFn(uri, defaultHeaders);

      return _handleResponse(response);
    } on SocketException {
      throw ServerException('No internet connection');
    } on http.ClientException {
      throw ServerException('Connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    final body = response.body.isNotEmpty ? jsonDecode(response.body) : <String, dynamic>{};
    final message = body is Map ? body['message'] as String? ?? 'Something went wrong' : 'Request failed';
    throw ServerException(message, statusCode: response.statusCode);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value == null) return <String, dynamic>{};
    if (value is Map<String, dynamic>) return value;
    throw ServerException('Unexpected response format');
  }

  void dispose() {
    _client.close();
  }
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
