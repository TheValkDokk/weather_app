// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:weather_app/core/services/dio_service.dart' as _i405;
import 'package:weather_app/core/services/env_service.dart' as _i924;
import 'package:weather_app/routes/route.dart' as _i701;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i701.AppRoutes>(() => _i701.AppRoutes());
    gh.lazySingleton<_i405.DioService>(() => _i405.DioService());
    gh.lazySingleton<_i924.EnvService>(() => _i924.EnvService());
    return this;
  }
}
