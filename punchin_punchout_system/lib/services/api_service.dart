import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/time_log.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl = 'http://localhost:8080/api';

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.responseType = ResponseType.json;

    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => developer.log(object.toString()),
    ));
  }

  Future<User> createAccount(String username, String password) async {
    try {
      developer.log('Creating account for username: $username');
      final response = await _dio.post('/users', data: {
        'username': username,
        'password': password,
      });

      if (response.data is String) {
        developer.log('Invalid response format: ${response.data}');
        throw Exception('Invalid response format from server');
      }

      developer.log('Account created successfully: ${response.data}');
      return User.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      developer.log('Failed to create account: $e', error: e);
      throw Exception('Failed to create account: $e');
    }
  }

  Future<TimeLog> punchIn(String userId) async {
    try {
      developer.log('Punching in user: $userId');
      final response = await _dio.post('/time-logs/punch-in/$userId');
      developer.log('Punch in successful: ${response.data}');
      return TimeLog.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // User is already punched in, get current time log
        final currentLog = await getCurrentTimeLog(userId);
        if (currentLog != null) {
          return currentLog;
        }
      }
      developer.log('Failed to punch in: $e', error: e);
      throw Exception('Failed to punch in: ${e.message}');
    }
  }

  Future<TimeLog> punchOut(String userId) async {
    try {
      developer.log('Punching out user: $userId');
      final response = await _dio.post('/time-logs/punch-out/$userId');
      developer.log('Punch out successful: ${response.data}');
      return TimeLog.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      developer.log('Failed to punch out: $e', error: e);
      throw Exception('Failed to punch out: $e');
    }
  }

  Future<TimeLog?> getCurrentTimeLog(String userId) async {
    try {
      final response = await _dio.get(
        '/time-logs/active/$userId',
      );
      return response.data != null ? TimeLog.fromJson(response.data) : null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to get current time log: ${e.message}');
    }
  }
}
