import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/managers/weather_api.dart';
import 'package:client/rx/managers/weather_providers/mock.dart';
import 'package:client/rx/managers/weather_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends RxBloc {
  WeatherApi _weatherApi;
  Location? _lastLocation;
  final EnvService _envService;
  final SharedPrefsService _sharedPrefsService;
  final _currentForecast = BehaviorSubject<WeatherForecast>();
  final _updatingCurrentForecast = BehaviorSubject<bool>();
  final _dailyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _updatingDailyForecast = BehaviorSubject<bool>();
  final _hourlyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _updatingHourlyForecast = BehaviorSubject<bool>();
  final _weatherApiProvider = BehaviorSubject<WeatherApiProvider>();
  final _weatherApiUnit = BehaviorSubject<WeatherUnits>();

  Stream<bool> get isUpdating => _updatingCurrentForecast.stream.mergeWith(
      [_updatingHourlyForecast.stream, _updatingDailyForecast.stream]);

  Stream<WeatherForecast> get currentForecast => _currentForecast.stream;

  Stream<List<WeatherForecast>> get dailyForecast => _dailyForecast.stream;

  Stream<List<WeatherForecast>> get hourlyForecast => _hourlyForecast.stream;

  Stream<WeatherUnits> get weatherUnit => _weatherApiUnit.stream;

  Stream<WeatherApiProvider> get weatherApiProvider =>
      _weatherApiProvider.stream;

  WeatherBloc(this._sharedPrefsService, this._envService)
      : _weatherApi = MockWeatherApi() {
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
    _weatherApiUnit.add(weatherApiUnits);
    _weatherApiProvider.add(weatherApiProvider);
    _weatherApi = _instantiateWeatherApi(weatherApiProvider, weatherApiUnits);
    _weatherApiProvider.listen((event) {
      _weatherApi = _instantiateWeatherApi(event, _weatherApiUnit.value);
      if (_lastLocation != null) getCurrentForecast(_lastLocation!);
    });
    _weatherApiUnit.listen((event) {
      _weatherApi = _instantiateWeatherApi(_weatherApiProvider.value, event);
      if (_lastLocation != null) getCurrentForecast(_lastLocation!);
    });
    _dailyForecast.listen((value) {
      if (_hourlyForecast.hasValue) {
        List<WeatherForecast> hourlyForecasts = _hourlyForecast.value.map((e) {
          WeatherForecast day =
              value.firstWhere((element) => isSameDay(e.date, element.date));
          e.sunset = day.sunset;
          e.sunrise = day.sunrise;
          return e;
        }).toList();
        _hourlyForecast.add(hourlyForecasts);
      }
    });
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

  void getCurrentForecast(Location location,
      {Function? onData, WeatherForecast? initialForecast}) {
    if (initialForecast != null) {
      _currentForecast.add(initialForecast);
    }
    _lastLocation = location;
    _updatingCurrentForecast.add(true);
    addFutureSubscription(_weatherApi.current(location.lat, location.lon),
        (WeatherForecast event) {
      _updatingCurrentForecast.add(false);
      _currentForecast.add(event);
      if (onData != null) onData(event);
    }, (e) {
      _updatingCurrentForecast.add(false);
    });
  }

  void getHourlyForecast(Location location) {
    _updatingHourlyForecast.add(true);
    addFutureSubscription(
        _weatherApi.hourlyForecast(location.lat, location.lon),
        (List<WeatherForecast> event) {
      _updatingHourlyForecast.add(false);
      if (_dailyForecast.hasValue) {
        _hourlyForecast.add(event.map((e) {
          WeatherForecast day = _dailyForecast.value
              .firstWhere((element) => isSameDay(element.date, e.date));
          e.sunrise = day.sunrise;
          e.sunset = day.sunset;
          return e;
        }).toList());
      } else {
        _hourlyForecast.add(event);
      }
    }, (e) {
      _updatingHourlyForecast.add(false);
    });
  }

  void getDailyForecast(Location location) {
    _updatingDailyForecast.add(true);
    addFutureSubscription(_weatherApi.dailyForecast(location.lat, location.lon),
        (List<WeatherForecast> event) {
      _updatingDailyForecast.add(false);
      _dailyForecast.add(event);
    }, (e) {
      _updatingDailyForecast.add(false);
    });
  }

  void onWeatherApiProviderChanged(WeatherApiProvider provider) {
    _weatherApiProvider.add(provider);
    addFutureSubscription(_sharedPrefsService.instance.setString(
        Constants.WEATHER_API_PROVIDER_PREFS,
        EnumToString.convertToString(provider)));
  }

  void onUnitsChanged(WeatherUnits unit) {
    _weatherApiUnit.add(unit);
    _sharedPrefsService.instance.setString(
        Constants.WEATHER_UNITS_PREFS, EnumToString.convertToString(unit));
  }

  Future<void> refresh(Location location) async {
    _lastLocation = location;
    _updatingCurrentForecast.add(true);
    WeatherForecast current =
        await _weatherApi.current(location.lat, location.lon);
    _currentForecast.add(current);
    List<WeatherForecast> hourly =
        await _weatherApi.hourlyForecast(location.lat, location.lon);
    _hourlyForecast.add(hourly);
    List<WeatherForecast> daily =
        await _weatherApi.dailyForecast(location.lat, location.lon);
    _dailyForecast.add(daily);
    _updatingCurrentForecast.add(false);
  }
}
