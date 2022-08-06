import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/types/location.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc extends RxBloc {
  final SharedPrefsService sharedPrefsService;
  final _activeLocation = BehaviorSubject<Location>();

  Stream<Location> get location => _activeLocation.stream;

  LocationBloc(this.sharedPrefsService) {
    String? lastCityPrefs =
        sharedPrefsService.instance.getString(Constants.LAST_CITY_PREFS);
    if (strNotEmpty(lastCityPrefs)) {
      _activeLocation.add(Location.fromJson(lastCityPrefs!));
    }
  }

  void onLocationUpdated(Location location) {
    _activeLocation.add(location);
    addFutureSubscription(
        sharedPrefsService.instance
            .setString(location.toJson(), Constants.LAST_CITY_PREFS),
        () {},
        (e) {});
  }

  void setActiveLocation(Location location) {
    _activeLocation.add(location);
  }

  void searchByQuery(String query, String locale) {}
}
