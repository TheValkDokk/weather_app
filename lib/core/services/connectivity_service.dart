import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class ConnectivityService {
  final Connectivity connectivity;
  final BehaviorSubject<ConnectivityResult> _connectivitySubject;

  @factoryMethod
  ConnectivityService({required this.connectivity})
    : _connectivitySubject = BehaviorSubject<ConnectivityResult>() {
    _init();
  }

  @visibleForTesting
  factory ConnectivityService.test({
    required Connectivity connectivity,
    required BehaviorSubject<ConnectivityResult> connectivitySubject,
  }) {
    return ConnectivityService._(
      connectivity: connectivity,
      connectivitySubject: connectivitySubject,
    );
  }

  ConnectivityService._({
    required this.connectivity,
    required BehaviorSubject<ConnectivityResult> connectivitySubject,
  }) : _connectivitySubject = connectivitySubject {
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

  Future<bool> isConnected() async {
    final status = await currentConnectivityStatus();
    return status.isNotEmpty && status.first != ConnectivityResult.none;
  }

  @disposeMethod
  Future<void> dispose() async {
    await _connectivitySubject.close();
  }
}
