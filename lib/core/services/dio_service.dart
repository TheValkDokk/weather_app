import 'package:dio/dio.dart';
import 'package:dio_intercept_to_curl/dio_intercept_to_curl.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/services/env_service.dart';
import 'package:weather_app/core/errors/failure.dart';

@singleton
class DioService {
  final Dio _dio;
  final EnvService _envService;

  DioService(this._envService, this._dio) {
    final baseUrl = _envService.get('BASE_URL');

    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    _dio.options = baseOptions;
    _dio.interceptors.add(DioInterceptToCurl());
  }

  String get baseUrl => _dio.options.baseUrl;

  Future<Response> _handleRequest(
    Future<Response> Function() request,
    String method,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw Failure(message: '$method request failed: ${e.message}');
    } catch (e) {
      throw Failure(message: 'Unexpected error during $method request: $e');
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleRequest(
      () => _dio.get(path, queryParameters: queryParameters),
      'GET',
    );
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return _handleRequest(() => _dio.post(path, data: data), 'POST');
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return _handleRequest(() => _dio.put(path, data: data), 'PUT');
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    return _handleRequest(() => _dio.delete(path, data: data), 'DELETE');
  }
}
