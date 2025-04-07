import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/common/presentation/screens/loading.dart';
import 'package:weather_app/gen/assets.gen.dart';

void main() {
  group('LoadingPage', () {
    testWidgets('should display loading image with correct dimensions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      // Find the SizedBox containing the image
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(96));
      expect(sizedBox.height, equals(96));

      // Verify the image is using the correct asset
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals(Assets.images.icLoading.path));
    });

    testWidgets('should center the loading widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      // Verify the Center widget is present
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should animate continuously', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

      // Verify RotationTransition is present
      expect(find.byType(RotationTransition), findsOneWidget);

      // Pump frames to verify animation is running
      final initialRotation =
          tester
              .widget<RotationTransition>(find.byType(RotationTransition))
              .turns
              .value;

      await tester.pump(const Duration(milliseconds: 500));
      final newRotation =
          tester
              .widget<RotationTransition>(find.byType(RotationTransition))
              .turns
              .value;

      expect(newRotation, isNot(equals(initialRotation)));
    });

    // testWidgets('should not throw when disposed', (WidgetTester tester) async {
    //   await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

    //   // Verify widget can be disposed without errors
    //   await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    // });
  });
}
