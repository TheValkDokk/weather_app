import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();
  @lazySingleton
  GeolocatorPlatform get geolocator => GeolocatorPlatform.instance;
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
