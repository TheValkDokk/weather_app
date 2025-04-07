import 'package:flutter/material.dart';
import 'package:weather_app/core/common/presentation/widgets/button.dart';
import 'package:weather_app/core/theme/pallet.dart';
import 'package:weather_app/core/theme/textstyle.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.errorMessage, required this.onRetry});

  final String? errorMessage;
  final Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: screenBgColorError,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 44,
        children: [
          Text(
            errorMessage ?? 'Something went wrong at our end!',
            textAlign: TextAlign.justify,
            style: errorTextStyle,
          ),
          AppButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
