import 'package:flutter/material.dart';
import 'package:weather_app/routes/route.dart';

import 'core/di/di.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRoutes>().router;
    return MaterialApp.router(routerConfig: router, theme: AppTheme.lightTheme);
  }
}
