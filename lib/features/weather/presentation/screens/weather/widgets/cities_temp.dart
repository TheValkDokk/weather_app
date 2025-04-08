import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/daily.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/city_temp_tile.dart';

class CitiesTempWidget extends StatelessWidget {
  const CitiesTempWidget({super.key, required this.dailies});

  final List<Daily> dailies;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 16),
      width: double.infinity,
      child: Column(
        children: dailies.take(4).map((e) => CityTempTile(daily: e)).toList(),
      ),
    );
  }
}
