import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/position_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class PositionBloc extends RxBloc {
  final _lastPosition = BehaviorSubject<Position>();
  final _locationPermission = BehaviorSubject<LocationPermission>();
  final _requestingCurrentLocation = BehaviorSubject<bool>();
  final _requestingLocationPermission = BehaviorSubject<bool>();
  final PositionService _positionService;

  Stream<Position> get position => _lastPosition.stream;

  Stream<bool> get requestingLocationPermission =>
      _requestingLocationPermission.stream;

  Stream<bool> get requestingCurrentLocation =>
      _requestingCurrentLocation.stream;

  Stream<LocationPermission> get locationPermission =>
      _locationPermission.stream;

  PositionBloc(this._positionService) {
    checkPermission();
  }

  void getCurrentPosition(
      {required Function onPermissionDenied,
      required Function onPermissionDeniedForever,
      required Function(Position) onPositionReceived,
      required Function onError}) {
    _requestingCurrentLocation.add(false);
    _requestingLocationPermission.add(true);
    addFutureSubscription(_positionService.requestPermission(),
        (LocationPermission permission) {
      _requestingLocationPermission.add(false);
      if (permission == LocationPermission.deniedForever) {
        onPermissionDeniedForever();
        return;
      } else if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        onPermissionDenied();
        return;
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        _requestingCurrentLocation.add(true);
        addFutureSubscription(_positionService.getCurrentPosition(),
            (Position position) {
          _requestingCurrentLocation.add(false);
          onPositionReceived(position);
        }, (e) {
          _requestingCurrentLocation.add(false);
          onError(e);
        });
      }
    }, (e) {
      _requestingLocationPermission.add(false);
      onError(e);
    });
  }

  void checkPermission() {
    addFutureSubscription(_positionService.checkPermission(),
        (LocationPermission permission) => _locationPermission.add(permission));
  }

  void openAppSettings() {
    _positionService.openAppSettings();
  }
}
