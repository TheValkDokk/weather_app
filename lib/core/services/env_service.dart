import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/errors/failure.dart';

@lazySingleton
class EnvService {
  @preResolve
  Future<void> init() async {
    await dotenv.load();
  }

  String get(String key) {
    try {
      return dotenv.get(key);
    } catch (e) {
      throw Failure(message: 'Environment variable $key not found');
    }
  }
}
