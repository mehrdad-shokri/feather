import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class PositionBloc extends RxBloc {
  final _lastPosition = BehaviorSubject<Position>();
  final LocationService _locationService;

  Stream<Position> get position => _lastPosition.stream;

  PositionBloc(this._locationService);

  void getCurrentPosition(Function onError) {
    addFutureSubscription(Geolocator.getCurrentPosition(),
        (Position event) => _lastPosition.add(event));
  }
}
