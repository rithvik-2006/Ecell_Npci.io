import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/company.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseURL = 'https://tqrxxx81-3003.inc1.devtunnels.ms/api';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> post(String endpoint, dynamic body) async {
    try {
      log('token: ${_authService.authToken}');
      final response = await http.post(Uri.parse(baseURL + endpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_authService.authToken}'
          },
          body: json.encode(body));

      log('Response: $response');

      return {
        'statusCode': response.statusCode,
        'body': json.decode(response.body),
      };
    } catch (e) {
      log('Error while posting: $e');
      return null;
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> authenticateStandaloneLoginAPI(
      String email, String password) async {
    String? token = await _authService.loginUsingEmailAndPassword(email, password);

    if (token != null) {
      return ApiResponse.standaloneLoginType(statusCode: 200);
    } else {
      log('Error: Unable to authenticate since no token found');
      return ApiResponse.standaloneLoginType(statusCode: 401, error: 'Unable to authenticate');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> authenticateRegisterAPI(
      String email, String password) async {
    try {
      final response = await post('/customer/create', {'email': email, 'password': password});

      if (response == null) {
        return ApiResponse(statusCode: 500, error: 'An unexpected error occurred.');
      }

      final int statusCode = response['statusCode'] as int;
      final Map<String, dynamic> body = response['body'] as Map<String, dynamic>;

      log('Responseee: $statusCode');

      if (statusCode == 200) {
        try {
          await _authService.loginUsingEmailAndPassword(email, password);
          return ApiResponse<Map<String, dynamic>>(statusCode: 200);
        } catch (e) {
          log('Error: $e');
          return ApiResponse<Map<String, dynamic>>(
              statusCode: 500, error: 'An unexpected error occurred while logging in client-side');
        }
      } else {
        return ApiResponse<Map<String, dynamic>>(
            statusCode: statusCode, error: body['error'] ?? 'An unexpected error occurred.');
      }
    } catch (error) {
      log('Error during registration: $error');
      return ApiResponse<Map<String, dynamic>>(
          statusCode: 500, error: 'An unexpected error occurred.');
    }
  }

  Future<List<Company>> fetchCompanies() async {
    final response = await http.get(Uri.parse('$baseURL/companies'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Company.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<Map<String, dynamic>> fetchCustomer() async {
    final response = await post('/customer', {
      'uid': _authService.auth.currentUser?.uid,
    });

    if (response == null) {
      throw Exception('Failed to load user data');
    }

    final int statusCode = response['statusCode'] as int;
    final Map<String, dynamic> body = response['body'] as Map<String, dynamic>;

    if (statusCode == 200) {
      log('message: $body');
      return body;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> fetchOffers() async {
    final response = await post('/customer/redeem', {
      'uid': _authService.auth.currentUser?.uid,
    });

    if (response == null) {
      throw Exception('Failed to load user data');
    }

    final int statusCode = response['statusCode'] as int;
    final Map<String, dynamic> body = response['body'] as Map<String, dynamic>;

    if (statusCode == 200) {
      log('message: $body');
      return body;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> transferPoints(String partnerName, double points) async {
    final response = await post('/customer/transfer', {
      "uid": _authService.auth.currentUser?.uid,
      "points": points,
      "partner_name": partnerName,
    });

    if (response == null) {
      throw Exception('Failed to transfer points');
    }

    final int statusCode = response['statusCode'] as int;
    final Map<String, dynamic> body = response['body'] as Map<String, dynamic>;

    log('mssage: ${response}');

    if (statusCode == 200) {
      log('message: $body');
      return body;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> fetchCustomerStatistics() async {
    final response = await post('/customer/statistics', {
      'uid': _authService.auth.currentUser?.uid,
    });

    if (response == null) {
      throw Exception('Failed to load user data');
    }

    final int statusCode = response['statusCode'] as int;
    final Map<String, dynamic> body = response['body'] as Map<String, dynamic>;

    if (statusCode == 200) {
      log('message: $body');
      return body;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
