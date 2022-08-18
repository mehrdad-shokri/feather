import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/managers/weather_api.dart';
import 'package:client/rx/managers/weather_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends RxBloc {
  late WeatherApi _weatherApi;

  final EnvService _envService;
  final _currentForecast = BehaviorSubject<WeatherForecast>();
  final _updatingCurrentForecast = BehaviorSubject<bool>();
  final _dailyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _updatingDailyForecast = BehaviorSubject<bool>();
  final _hourlyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _updatingHourlyForecast = BehaviorSubject<bool>();
  final _isUpdating = BehaviorSubject<bool>();
  WeatherApiProvider _weatherApiProvider =
      Constants.DEFAULT_WEATHER_API_PROVIDER;
  WeatherUnits _weatherUnit = Constants.DEFAULT_WEATHER_API_UNITS;

  Stream<bool> get isUpdating => _updatingCurrentForecast.stream
      .mergeWith([_updatingHourlyForecast.stream]);

  Stream<WeatherForecast> get currentForecast => _currentForecast.stream;

  Stream<List<WeatherForecast>> get dailyForecast => _dailyForecast.stream;

  Stream<List<WeatherForecast>> get hourlyForecast => _hourlyForecast.stream;

  WeatherBloc(
    Stream<WeatherApiProvider> weatherApiProvider,
    Stream<WeatherUnits> weatherUnits,
    this._envService,
  ) {
    _weatherApi = _instantiateWeatherApi(_weatherApiProvider, _weatherUnit);
    weatherApiProvider.listen((event) {
      _weatherApiProvider = event;
      _instantiateWeatherApi(event, _weatherUnit);
    });
    weatherUnits.listen((event) {
      _weatherUnit = event;
      _instantiateWeatherApi(_weatherApiProvider, event);
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

  void getCurrentForecast(double lat, double lon, {Function? onData}) {
    _updatingCurrentForecast.add(true);
    addFutureSubscription(_weatherApi.current(lat, lon),
        (WeatherForecast event) {
      _updatingCurrentForecast.add(false);
      if (onData != null) onData(event);
    }, (e) {
      _updatingCurrentForecast.add(false);
    });
  }

  void getHourlyForecast(double lat, double lon) {
    addFutureSubscription(_weatherApi.hourlyForecast(lat, lon),
        (List<WeatherForecast>? event) {
      if (event != null) _hourlyForecast.add(event);
    }, (e) {});
  }

  void getDailyForecast(double lat, double lon) {
    addFutureSubscription(_weatherApi.dailyForecast(lat, lon),
        (List<WeatherForecast>? event) {
      if (event != null) _dailyForecast.add(event);
    }, (e) {});
  }
}
