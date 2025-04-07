import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class ConnectivityService {
  final Connectivity connectivity;
  final BehaviorSubject<ConnectivityResult> _connectivitySubject;

  ConnectivityService({
    required this.connectivity,
    BehaviorSubject<ConnectivityResult>? connectivitySubject,
  }) : _connectivitySubject =
           connectivitySubject ?? BehaviorSubject<ConnectivityResult>() {
    _init();
  }

  void _init() {
    connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _connectivitySubject.add(results.first);
      }
    });
  }

  Future<List<ConnectivityResult>> currentConnectivityStatus() async {
    return await connectivity.checkConnectivity();
  }

  Stream<ConnectivityResult> connectivityStream() {
    return _connectivitySubject.stream;
  }

  @disposeMethod
  Future<void> dispose() async {
    await _connectivitySubject.close();
  }
}
