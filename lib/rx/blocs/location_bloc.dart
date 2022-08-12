import 'package:client/models/location.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc extends RxBloc {
  final SharedPrefsService _sharedPrefsService;
  final _activeLocation = BehaviorSubject<Location>();
  final _updatingCurrentLocation = BehaviorSubject<bool>();

  Stream<Location> get activeLocation => _activeLocation.stream;

  Stream<bool> get updatingCurrentLocation => _updatingCurrentLocation.stream;

  LocationBloc(this._sharedPrefsService) {
    String? lastCityPrefs =
        _sharedPrefsService.instance.getString(Constants.ACTIVE_CITY_PREFS);
    if (strNotEmpty(lastCityPrefs)) {
      _activeLocation.add(Location.fromPrefsJson(lastCityPrefs!));
    }
  }

  void onLoadingCurrentLocation() {
    _updatingCurrentLocation.add(true);
  }

  void onLocationUpdated(Location location) {
    _activeLocation.add(location);
    _updatingCurrentLocation.add(false);
    addFutureSubscription(
      _sharedPrefsService.instance
          .setString(location.toJson(), Constants.ACTIVE_CITY_PREFS),
    );
  }
}
