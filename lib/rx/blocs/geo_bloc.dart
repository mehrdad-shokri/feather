import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/managers/geo_api.dart';
import 'package:client/rx/managers/geo_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/types/geo_providers.dart';
import 'package:client/types/location.dart';
import 'package:client/utils/constants.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';

class GeoBloc extends RxBloc {
  final SharedPrefsService sharedPrefsService;
  final EnvService _envService;
  final _geoApiProvider = BehaviorSubject<GeoApiProviders>();
  final _geoApi = BehaviorSubject<GeoApi>();
  final _lang = BehaviorSubject<String>();
  final _reverseGeoLocation = BehaviorSubject<Location>();

  Stream<Location> get reverseGeoLocation => _reverseGeoLocation.stream;

  GeoBloc(this.sharedPrefsService, this._envService) {
    String? geoApiProvider =
        sharedPrefsService.instance.getString(Constants.GEO_API_PROVIDER_PREFS);
    String? lang =
        sharedPrefsService.instance.getString(Constants.USER_LOCALE_PREFS) ??
            'en';
    GeoApiProviders provider = geoApiProvider != null
        ? EnumToString.fromString(GeoApiProviders.values, geoApiProvider)!
        : Constants.DEFAULT_GEO_API_PROVIDER;
    _geoApiProvider.add(provider);
    _lang.add(lang);
    _lang.listen((value) {
      instantiateGeoApi(_geoApiProvider.value, value);
    });
    _geoApiProvider.listen((value) {
      _geoApi.add(instantiateGeoApi(value, _lang.value));
    });
    instantiateGeoApi(_geoApiProvider.value, _lang.value);
  }

  void reverseGeoCode(double lat, double lon) {
    addFutureSubscription(_geoApi.value.reverseGeocode(lat, lon), (location) {
      _reverseGeoLocation.add(location);
    }, (e) {});
  }

  void searchQuery(String query) {
    addFutureSubscription(_geoApi.value.searchByQuery(query), (location) {
      _reverseGeoLocation.add(location);
    }, (e) {});
  }

  void onGeoApiProviderChanged(GeoApiProviders geoApiProvider) {
    _geoApiProvider.add(geoApiProvider);
    addFutureSubscription(
        sharedPrefsService.instance.setString(Constants.GEO_API_PROVIDER_PREFS,
            EnumToString.convertToString(geoApiProvider)),
        () {},
        (e) {});
  }

  void onLangChanged(String lang) {
    _lang.add(lang);
  }

  GeoApi instantiateGeoApi(GeoApiProviders provider, String lang) {
    switch (provider) {
      case GeoApiProviders.openWeatherMap:
        return OpenWeatherMapGeoApi(
            _envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV] ?? '',
            lang);
      default:
        return OpenWeatherMapGeoApi(
            _envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV] ?? '',
            lang);
    }
  }
}
