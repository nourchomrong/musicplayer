import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/app.dart';

class AuthService {
  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Register failed: $e");
    }
  }

  static Future<Map<String, dynamic>> login(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body['message'] ?? 'Something went wrong. Please try again.');
    }
  }
}