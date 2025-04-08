import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_app/core/common/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:weather_app/core/services/connectivity_service.dart';

class MockConnectivityService extends Mock implements ConnectivityService {
  final BehaviorSubject<ConnectivityResult> _connectivitySubject;

  MockConnectivityService()
    : _connectivitySubject = BehaviorSubject<ConnectivityResult>();

  @override
  Stream<ConnectivityResult> connectivityStream() =>
      _connectivitySubject.stream;

  void emitConnectivityResult(ConnectivityResult result) {
    _connectivitySubject.add(result);
  }

  @override
  Future<void> dispose() async {
    await _connectivitySubject.close();
  }
}

void main() {
  late MockConnectivityService mockConnectivityService;
  late ConnectivityBloc connectivityBloc;

  setUp(() {
    mockConnectivityService = MockConnectivityService();
    connectivityBloc = ConnectivityBloc(mockConnectivityService);
  });

  tearDown(() async {
    await mockConnectivityService.dispose();
  });

  group('ConnectivityBloc', () {
    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [initial, connected] when connectivity is available',
      build: () {
        mockConnectivityService.emitConnectivityResult(ConnectivityResult.wifi);
        return connectivityBloc;
      },
      act: (bloc) => bloc.add(const ConnectivityEvent.started()),
      expect: () => [const ConnectivityState.connected()],
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [initial, noInternetConnection] when connectivity is not available',
      build: () {
        mockConnectivityService.emitConnectivityResult(ConnectivityResult.none);
        return connectivityBloc;
      },
      act: (bloc) => bloc.add(const ConnectivityEvent.started()),
      expect: () => [const ConnectivityState.noInternetConnection()],
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits multiple states when connectivity changes',
      build: () {
        mockConnectivityService.emitConnectivityResult(ConnectivityResult.wifi);
        mockConnectivityService.emitConnectivityResult(ConnectivityResult.none);
        mockConnectivityService.emitConnectivityResult(
          ConnectivityResult.mobile,
        );
        return connectivityBloc;
      },
      act: (bloc) => bloc.add(const ConnectivityEvent.started()),
      expect:
          () => [
            const ConnectivityState.connected(),
            const ConnectivityState.noInternetConnection(),
            const ConnectivityState.connected(),
          ],
    );
  });
}
