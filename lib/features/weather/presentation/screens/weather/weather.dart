import 'package:flutter/material.dart';
import 'package:weather_app/core/common/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:weather_app/core/common/presentation/screens/loading.dart';
import 'package:weather_app/features/location/presentation/bloc/location_service/location_service_bloc.dart';
import 'package:weather_app/core/common/presentation/bloc/permission/permission_bloc.dart';
import 'package:weather_app/core/common/presentation/screens/error.dart';
import 'package:weather_app/core/di/di.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/bloc/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/dialogs/permission_denied.dart';
import 'package:weather_app/features/weather/presentation/screens/weather/widgets/weather_page.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    getIt<WeatherBloc>().close();
    getIt<PermissionBloc>().close();
    getIt<ConnectivityBloc>().close();
    getIt<LocationServiceBloc>().close();
  }

  void _onRetry() {
    getIt<WeatherBloc>().add(const WeatherEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<WeatherBloc>()),
        BlocProvider(create: (context) => getIt<PermissionBloc>()),
        BlocProvider(create: (context) => getIt<ConnectivityBloc>()),
        BlocProvider(create: (context) => getIt<LocationServiceBloc>()),
      ],
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<PermissionBloc, PermissionState>(
              listener: (context, state) {
                if (state is PermanentlyDenied) {
                  showDialog(
                    context: context,
                    builder: (context) => PermissionDeniedDialog(),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoaded) {
                return WeatherPage(
                  weather: state.weather,
                  cityName: state.cityName,
                );
              } else if (state is WeatherError) {
                return ErrorPage(onRetry: _onRetry);
              }
              return const LoadingPage();
            },
          ),
        ),
      ),
    );
  }
}
