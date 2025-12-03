import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_tourism_application/data/datasources/local/shared_prefs.dart';

class ApiClient {
  final String baseUrl;
  final Map<String, String> headers;

  ApiClient({
    required this.baseUrl,
    this.headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  Future<Map<String, String>> _getHeaders() async {
    final headersCopy = Map<String, String>.from(headers);
    
    // Check for auth token
    final sharedPrefs = SharedPrefs();
    final token = await sharedPrefs.getString('authToken');
    
    if (token != null && token.isNotEmpty) {
      headersCopy['Authorization'] = 'Bearer $token';
    }
    
    return headersCopy;
  }

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders();
    return await http.get(uri, headers: requestHeaders);
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders();
    return await http.post(
      uri,
      headers: requestHeaders,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders();
    return await http.put(
      uri,
      headers: requestHeaders,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders();
    return await http.delete(uri, headers: requestHeaders);
  }
}