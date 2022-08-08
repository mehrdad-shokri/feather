import 'package:client/models/location.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc extends RxBloc {
  final SharedPrefsService _sharedPrefsService;
  final _activeLocation = BehaviorSubject<Location>();
  Stream<Location> get activeLocation => _activeLocation.stream;

  LocationBloc(this._sharedPrefsService) {
    String? lastCityPrefs =
        _sharedPrefsService.instance.getString(Constants.LAST_CITY_PREFS);
    if (strNotEmpty(lastCityPrefs)) {
      _activeLocation.add(Location.fromPrefsJson(lastCityPrefs!));
    }
  }

  void onLocationUpdated(Location location) {
    _activeLocation.add(location);
    addFutureSubscription(
      _sharedPrefsService.instance
          .setString(location.toJson(), Constants.LAST_CITY_PREFS),
    );
  }

  void setActiveLocation(Location location) {
    _activeLocation.add(location);
  }
}
