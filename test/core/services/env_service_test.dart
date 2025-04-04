import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/services/env_service.dart';

class MockDotEnv extends Mock implements DotEnv {}

void main() {
  late EnvService envService;
  late MockDotEnv mockDotEnv;

  setUp(() {
    mockDotEnv = MockDotEnv();
    dotenv = mockDotEnv;
    envService = EnvService();
  });

  group('EnvService', () {
    test('init loads environment variables', () async {
      when(() => mockDotEnv.load()).thenAnswer((_) async => true);
      await envService.init();
      verify(() => mockDotEnv.load()).called(1);
    });

    test('get returns value when key exists', () {
      when(() => mockDotEnv.get('API_KEY')).thenReturn('test_value');
      final result = envService.get('API_KEY');
      expect(result, 'test_value');
    });

    test('get throws Failure when key is not found', () {
      when(() => mockDotEnv.get('API_KEY')).thenThrow(Exception());

      expect(
        () => envService.get('API_KEY'),
        throwsA(
          isA<Failure>().having(
            (f) => f.message,
            'message',
            'Environment variable API_KEY not found',
          ),
        ),
      );
    });
  });
}
