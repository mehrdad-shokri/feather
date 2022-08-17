import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/managers/weather_api.dart';
import 'package:client/rx/managers/weather_providers/mock.dart';
import 'package:client/rx/managers/weather_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends RxBloc {
  final EnvService _envService;
  final _currentForecast = BehaviorSubject<WeatherForecast>();
  // final _searchedCitiesForecasts = BehaviorSubject<List<WeatherForecast>>();
  // final _loadingCitiesForecasts = BehaviorSubject<bool>();
  final _dailyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _hourlyForecast = BehaviorSubject<List<WeatherForecast>>();
  final _isUpdating = BehaviorSubject<bool>();
  WeatherApiProvider _weatherApiProvider = WeatherApiProvider.openWeatherMap;
  WeatherUnits _weatherUnit = WeatherUnits.metric;
  WeatherApi _weatherApi = MockWeatherApi();

  Stream<bool> get isUpdating => _isUpdating.stream;

  Stream<WeatherForecast> get currentForecast => _currentForecast.stream;

  // Stream<bool> get loadingCitiesForecasts => _loadingCitiesForecasts.stream;

  // Stream<List<WeatherForecast>> get citiesWeatherForecast =>
  //     _searchedCitiesForecasts.stream;

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

  void activeLocationForecast(Location location) {
    addFutureSubscription(_weatherApi.current(location.lat, location.lon),
        (WeatherForecast event) {
      _currentForecast.add(event);
    });
  }

  void getCurrentForecast(double lat, double lon, Function? onData) {
    addFutureSubscription(_weatherApi.current(lat, lon),
        (WeatherForecast event) {
      if (onData != null) onData(event);
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

/*
  void getCitiesForecast(List<Location> locations) {
    addFutureSubscription((() async {
      _loadingCitiesForecasts.add(true);
      List<WeatherForecast> forecasts = [];
      await Future.forEach(locations, (Location element) async {
        WeatherForecast forecast =
            await _weatherApi.current(element.lat, element.lon);
        forecasts.add(forecast);
      });
      return forecasts;
    })(), (List<WeatherForecast> forecasts) {
      _loadingCitiesForecasts.add(false);
      _searchedCitiesForecasts.add(forecasts);
    }, (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: Constants.TOAST_DEFAULT_LOCATION,
          timeInSecForIosWeb: 3,
          backgroundColor: Constants.ERROR_COLOR,
          textColor: Colors.white,
          fontSize: 16.0);
      _loadingCitiesForecasts.add(false);
    });
  }
*/
}
