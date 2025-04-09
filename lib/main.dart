import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/bloc_observer.dart';
import 'package:weather_app/routes/route.dart';

import 'core/di/di.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  await configureDependencies();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

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
