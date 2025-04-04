// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:weather_app/core/di/di.dart' as _i689;
import 'package:weather_app/core/services/dio_service.dart' as _i405;
import 'package:weather_app/core/services/env_service.dart' as _i924;
import 'package:weather_app/core/services/permission_service.dart' as _i968;
import 'package:weather_app/routes/route.dart' as _i701;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i361.Dio>(() => registerModule.dio);
    gh.singleton<_i701.AppRoutes>(() => _i701.AppRoutes());
    gh.singleton<_i968.PermissionService>(() => _i968.PermissionService());
    await gh.lazySingletonAsync<_i924.EnvService>(() {
      final i = _i924.EnvService();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.singleton<_i405.DioService>(
      () => _i405.DioService(gh<_i924.EnvService>(), gh<_i361.Dio>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i689.RegisterModule {}
