import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/app.dart';
import 'package:weather_app/core/services/env_service.dart';

void main() {
  late EnvService envService;

  setUp(() async {
    dotenv.testLoad(
      fileInput: '''
      TEST_KEY=test_value
    ''',
    );
    envService = EnvService();
  });

  group('Env Service', () {
    test('should load .env file and return value for TEST_KEY', () async {
      expect(envService.get('TEST_KEY'), equals('test_value'));
    });

    test('should throw Failure when environment variable is not found', () {
      expect(
        () => envService.get('NON_EXISTING_KEY'),
        throwsA(
          isA<Failure>().having(
            (f) => f.message,
            'message',
            equals('Environment variable NON_EXISTING_KEY not found'),
          ),
        ),
      );
    });
  });
}
