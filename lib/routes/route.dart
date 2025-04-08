import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../features/weather/weather.dart';

@singleton
class AppRoutes {
  final List<GoRoute> routes = [
    GoRoute(
      path: '/weather',
      builder: (context, state) => const WeatherScreen(),
    ),
  ];
  late final GoRouter router;

  AppRoutes() {
    router = GoRouter(initialLocation: '/weather', routes: routes);
  }
}
