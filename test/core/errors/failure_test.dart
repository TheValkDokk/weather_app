import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/errors/failure.dart';

void main() {
  group('Failure', () {
    test(
      'should create a Failure with provided message and auto id generation',
      () {
        const message = 'Test error';
        final failure = Failure(message: message);
        expect(failure.message, equals(message));
        expect(failure.id, isNotEmpty);
      },
    );

    test('should create a Failure with custom id', () {
      const message = 'Test error';
      const testId = 'custom-id';
      final failure = Failure(message: message, id: testId);
      expect(failure.message, equals(message));
      expect(failure.id, equals(testId));
    });

    test(
      'should compare two Failures for equality when same message and id',
      () {
        const message = 'Same error';
        const testId = 'same-id';
        final failure1 = Failure(message: message, id: testId);
        final failure2 = Failure(message: message, id: testId);
        expect(failure1, equals(failure2));
      },
    );

    test('should not consider two Failures equal if ids differ', () {
      const message = 'Same error';
      final failure1 = Failure(message: message);
      final failure2 = Failure(message: message);
      expect(failure1, isNot(equals(failure2)));
    });
  });
}
