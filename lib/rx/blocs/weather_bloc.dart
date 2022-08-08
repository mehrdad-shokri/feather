import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/managers/weather_api.dart';
import 'package:client/rx/managers/weather_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/constants.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends RxBloc {
  final SharedPrefsService _sharedPrefsService;
  final EnvService _envService;
  final _currentForecast = BehaviorSubject<WeatherForecast>();
  final _citiesWeatherForecast = BehaviorSubject<List<WeatherForecast>>();
  final _dailyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _hourlyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _weatherApi = BehaviorSubject<WeatherApi>();
  final _weatherApiProvider = BehaviorSubject<WeatherApiProvider>();
  final _weatherApiUnits = BehaviorSubject<WeatherUnits>();
  final _isUpdating = BehaviorSubject<bool>();

  Stream<bool> get isUpdating => _isUpdating.stream;

  Stream<WeatherUnits> get units => _weatherApiUnits.stream;

  Stream<WeatherApiProvider> get apiProvider => _weatherApiProvider.stream;

  Stream<WeatherForecast> get currentForecast => _currentForecast.stream;

  Stream<List<WeatherForecast>> get citiesWeatherForecast =>
      _citiesWeatherForecast.stream;

  Stream<List<WeatherForecast>> get dailyForecast => _dailyForecast.stream;

  Stream<List<WeatherForecast>> get hourlyForecast => _hourlyForecast.stream;

  WeatherBloc(this._sharedPrefsService, this._envService, {GeoBloc? geoBloc}) {
    String? weatherApiProviderPrefs = _sharedPrefsService.instance
        .getString(Constants.WEATHER_API_PROVIDER_PREFS);
    String? weatherUnitsPrefs =
        _sharedPrefsService.instance.getString(Constants.WEATHER_UNITS_PREFS);
    WeatherUnits weatherApiUnits = weatherUnitsPrefs != null
        ? EnumToString.fromString(WeatherUnits.values, weatherUnitsPrefs)!
        : Constants.DEFAULT_WEATHER_API_UNITS;
    WeatherApiProvider weatherApiProvider = weatherApiProviderPrefs != null
        ? EnumToString.fromString(
            WeatherApiProvider.values, weatherApiProviderPrefs)!
        : Constants.DEFAULT_WEATHER_API_PROVIDER;
    _weatherApiUnits.add(weatherApiUnits);
    _weatherApiProvider.add(weatherApiProvider);
    _weatherApi
        .add(_instantiateWeatherApi(weatherApiProvider, weatherApiUnits));
    _weatherApiProvider.listen((value) {
      _weatherApi.add(_instantiateWeatherApi(value, _weatherApiUnits.value));
    });
    _weatherApiUnits.listen((value) {
      _weatherApi.add(_instantiateWeatherApi(_weatherApiProvider.value, value));
    });
    if (geoBloc != null) {
      geoBloc.searchedLocations.listen((event) {
        getCitiesForecast(event);
      });
    }
  }

  WeatherApi _instantiateWeatherApi(
      WeatherApiProvider provider, WeatherUnits unit) {
    switch (provider) {
      case WeatherApiProvider.openWeatherMap:
        return OpenWeatherMapWeatherApi(
            _envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV] ?? '',
            unit);
      default:
        return OpenWeatherMapWeatherApi(
            _envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV] ?? '',
            unit);
    }
  }

  void onWeatherApiProviderChanged(WeatherApiProvider provider) {
    _weatherApiProvider.add(provider);
    addFutureSubscription(
        _sharedPrefsService.instance.setString(
            Constants.WEATHER_API_PROVIDER_PREFS,
            EnumToString.convertToString(provider)),
        (data) {},
        (e) {});
  }

  void onUnitsChanged(WeatherUnits unit) {
    _weatherApiUnits.add(unit);
    addFutureSubscription(
      _sharedPrefsService.instance.setString(
          Constants.WEATHER_UNITS_PREFS, EnumToString.convertToString(unit)),
    );
  }

  void getCurrentForecast(double lat, double lon) {
    addFutureSubscription(_weatherApi.value.current(lat, lon),
        (WeatherForecast event) {
      _currentForecast.add(event);
    });
  }

  void getHourlyForecast(double lat, double lon) {
    addFutureSubscription(_weatherApi.value.hourlyForecast(lat, lon),
        (List<WeatherForecast>? event) {
      if (event != null) _hourlyForecast.add(event);
    }, (e) {});
  }

  void getDailyForecast(double lat, double lon) {
    addFutureSubscription(_weatherApi.value.dailyForecast(lat, lon),
        (List<WeatherForecast>? event) {
      if (event != null) _dailyForecast.add(event);
    }, (e) {});
  }

  void getCitiesForecast(List<Location> locations) {
    List<WeatherForecast> forecasts = [];
    addFutureSubscription((() async {
      await Future.forEach(locations, (Location element) async {
        WeatherForecast forecast =
            await _weatherApi.value.current(element.lat, element.lon);
        forecasts.add(forecast);
      });
      return forecasts;
    })(),
        (List<WeatherForecast> forecasts) =>
            _citiesWeatherForecast.add(forecasts));
  }
}
