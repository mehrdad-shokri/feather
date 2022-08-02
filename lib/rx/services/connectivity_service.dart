import 'package:client/rx/services/rx_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityService extends RxService {
  final BehaviorSubject<bool> _connectedToInternet = BehaviorSubject<bool>();

  Stream<bool> get connectedToInternet => _connectedToInternet.stream;

  @override
  Future<void> onCreate() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      _connectedToInternet.add(true);
    } else {
      _connectedToInternet.add(false);
    }
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        _connectedToInternet
            .add(await InternetConnectionChecker().hasConnection);
      } else {
        _connectedToInternet.add(false);
      }
    });
  }

  @override
  Future<void> onTerminate() async {}
}
