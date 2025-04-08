import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/cities_temp.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/main_temp.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.weather, required this.cityName});

  final Weather weather;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 56),
          MainTempWidget(
            temp: weather.current.temp.toStringAsFixed(0),
            cityName: cityName,
          ),
          SizedBox(height: 62),
          Expanded(
            child: CitiesTempWidget(dailies: weather.daily).animate().slideY(
              begin: 1.0,
              end: 0.0,
              duration: 1300.ms,
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}
