import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/location/data/datasource/geocoding_datasource.dart';

void main() {
  late GeocodingServiceImpl geocodingService;

  setUp(() {
    geocodingService = GeocodingServiceImpl();
  });

  group('validateCoordinates', () {
    test('should throw error if latitude or longitude is out of range', () {
      // latitude out of range
      expect(
        () => geocodingService.validateCoordinates(100.0, 10.0),
        throwsA(
          isA<Failure>().having((f) => f.id, 'id', 'invalid_coordinates'),
        ),
      );

      // longitude out of range
      expect(
        () => geocodingService.validateCoordinates(10.0, 181.0),
        throwsA(
          isA<Failure>().having((f) => f.id, 'id', 'invalid_coordinates'),
        ),
      );
    });

    test('should pass if latitude and longitude are in range', () {
      expect(
        () => geocodingService.validateCoordinates(10.0, 10.0),
        isA<void>(),
      );
    });
  });

  group('placemarkFromCoordinates', () {
    test(
      'should throw Failure with id "invalid_coordinates" for out-of-range coordinates',
      () {
        expect(
          () => geocodingService.placemarkFromCoordinates(100.0, 200.0),
          throwsA(
            predicate((e) => e is Failure && e.id == 'invalid_coordinates'),
          ),
        );
      },
    );

    test(
      'should throw Failure with id "geocoding_error" if underlying geocoding call fails',
      () async {
        //TODO(valk): implement test when placemarkFromCoordinates is mockable
      },
      skip: 'placemarkFromCoordinates is package function not mockable',
    );

    test(
      'should return a list of Placemark for valid coordinates',
      () async {
        //TODO(valk): implement test when placemarkFromCoordinates is mockable
      },
      skip: 'placemarkFromCoordinates is package function not mockable',
    );
  });
}
