import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/services/dio_service.dart';
import 'package:weather_app/core/services/env_service.dart';

class MockEnvService extends Mock implements EnvService {}

void main() {
  late DioService dioService;
  late Dio dio;
  late DioAdapter dioAdapter;
  late MockEnvService mockEnvService;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() async {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    dio.httpClientAdapter = dioAdapter;

    mockEnvService = MockEnvService();
    when(
      () => mockEnvService.get('BASE_URL'),
    ).thenReturn('https://api.example.com');

    dioService = DioService(mockEnvService, dio);
  });

  group('DioService Tests', () {
    group('Initialization', () {
      test('init sets up Dio with correct base URL', () async {
        expect(dioService.baseUrl, 'https://api.example.com');
        verify(() => mockEnvService.get('BASE_URL')).called(1);
      });

      test('init throws exception if BASE_URL is null', () async {
        final badEnvService = MockEnvService();
        when(
          () => badEnvService.get('BASE_URL'),
        ).thenThrow(Failure(message: 'BASE_URL is null'));
        expect(() => DioService(badEnvService, dio), throwsA(isA<Failure>()));
      });
    });

    group('GET Requests', () {
      test('successful GET request returns response', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onGet('/test', (request) {
          request.reply(200, responsePayload);
        });

        final result = await dioService.get('/test');

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });

      test('GET request with query parameters', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onGet('/test', (request) {
          request.reply(200, responsePayload);
        }, queryParameters: {'key': 'value'});

        final result = await dioService.get(
          '/test',
          queryParameters: {'key': 'value'},
        );

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });

      test('GET request with 404 error throws Failure', () async {
        dioAdapter.onGet('/test', (request) {
          request.reply(404, {'error': 'Not Found'});
        });

        expect(
          () => dioService.get('/test'),
          throwsA(
            isA<Failure>().having(
              (f) => f.message,
              'message',
              contains('GET request failed'),
            ),
          ),
        );
      });

      test('GET request with timeout throws Failure', () async {
        dioAdapter.onGet('/test', (request) {
          request.throws(
            500,
            DioException.connectionTimeout(
              requestOptions: RequestOptions(path: '/test'),
              timeout: const Duration(seconds: 3),
            ),
          );
        });

        expect(
          () => dioService.get('/test'),
          throwsA(
            isA<Failure>().having(
              (f) => f.message,
              'message',
              contains('GET request failed'),
            ),
          ),
        );
      });
    });

    group('POST Requests', () {
      test('successful POST request returns response', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onPost('/test', (request) {
          request.reply(200, responsePayload);
        }, data: {'param1': 'value1'});

        final result = await dioService.post(
          '/test',
          data: {'param1': 'value1'},
        );

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });

      test('POST request with null data', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onPost('/test', (request) {
          request.reply(200, responsePayload);
        });

        final result = await dioService.post('/test', data: null);

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });

      test('POST request with 400 error throws Failure', () async {
        dioAdapter.onPost('/test', (request) {
          request.reply(400, {'error': 'Bad Request'});
        }, data: {'param1': 'value1'});

        expect(
          () => dioService.post('/test', data: {'param1': 'value1'}),
          throwsA(
            isA<Failure>().having(
              (f) => f.message,
              'message',
              contains('POST request failed'),
            ),
          ),
        );
      });

      test('POST request with empty response', () async {
        dioAdapter.onPost('/test', (request) {
          request.reply(200, '');
        }, data: {'param1': 'value1'});

        final result = await dioService.post(
          '/test',
          data: {'param1': 'value1'},
        );

        expect(result.statusCode, 200);
        expect(result.data, '');
      });
    });

    group('PUT Requests', () {
      test('successful PUT request returns response', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onPut('/test', (request) {
          request.reply(200, responsePayload);
        }, data: {'param1': 'value1'});

        final result = await dioService.put(
          '/test',
          data: {'param1': 'value1'},
        );

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });

      test('PUT request with 500 error throws Failure', () async {
        dioAdapter.onPut('/test', (request) {
          request.reply(500, {'error': 'Server Error'});
        }, data: {'param1': 'value1'});

        expect(
          () => dioService.put('/test', data: {'param1': 'value1'}),
          throwsA(
            isA<Failure>().having(
              (f) => f.message,
              'message',
              contains('PUT request failed'),
            ),
          ),
        );
      });

      test('PUT request with no data', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onPut('/test', (request) {
          request.reply(200, responsePayload);
        });

        final result = await dioService.put('/test');

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });
    });

    group('DELETE Requests', () {
      test('successful DELETE request returns response', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onDelete('/test', (request) {
          request.reply(200, responsePayload);
        }, data: {'param1': 'value1'});

        final result = await dioService.delete(
          '/test',
          data: {'param1': 'value1'},
        );

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });

      test('DELETE request with 403 error throws Failure', () async {
        dioAdapter.onDelete('/test', (request) {
          request.reply(403, {'error': 'Forbidden'});
        }, data: {'param1': 'value1'});

        expect(
          () => dioService.delete('/test', data: {'param1': 'value1'}),
          throwsA(
            isA<Failure>().having(
              (f) => f.message,
              'message',
              contains('DELETE request failed'),
            ),
          ),
        );
      });

      test('DELETE request with null data', () async {
        final responsePayload = jsonEncode({"response_code": "1000"});
        dioAdapter.onDelete('/test', (request) {
          request.reply(200, responsePayload);
        });

        final result = await dioService.delete('/test', data: null);

        expect(result.statusCode, 200);
        expect(result.data, responsePayload);
      });
    });
  });
}
