import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/managers/weather_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EnvService envService;
  late String openWeatherMapApiKey;
  List<double> lats = [
    35,
    35.7219,
    40.7128,
    37.773972,
    52.520008,
    52.3676,
    51.9244
  ];
  List<double> lons = [
    139,
    51.3347,
    -74.0060,
    -122.431297,
    13.404954,
    4.9041,
    4.4777
  ];
  setUp(() async {
    envService = EnvService('.env.test', true);
    await envService.onCreate();
    openWeatherMapApiKey =
        envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV]!;
  });
  group('OpenWeatherMap Weather test', () {
    test('It gets current weather info', () async {
      for (int i = 0; i < lats.length; i++) {
        double lat = lats[i];
        double lon = lons[i];
        OpenWeatherMapWeatherApi openWeatherMap =
            OpenWeatherMapWeatherApi(openWeatherMapApiKey, 'metric');
        WeatherForecast forecast = await openWeatherMap.current(lat, lon);
        expect(forecast.lat, equals(lat));
        expect(forecast.lon, equals(lon));
        expect(forecast.temp, isNot(null));
        expect(forecast.tempFeelsLike, isNot(equals(null)));
        expect(forecast.cityName, isNot(null));
        expect(forecast.humidityPercent, greaterThanOrEqualTo(0));
        expect(forecast.visibility, greaterThanOrEqualTo(0));
        expect(forecast.cloudsPercent, greaterThanOrEqualTo(0));
        expect(forecast.windDegree, anyOf(null, greaterThanOrEqualTo(-1)));
        expect(forecast.windGust, anyOf(null, greaterThanOrEqualTo(-1)));
        expect(forecast.windSpeed, anyOf(null, greaterThanOrEqualTo(-1)));
        expect(forecast.timezone, isInstanceOf<int>());
        expect(forecast.sunrise, isNot(equals(null)));
        expect(forecast.sunset, isNot(equals(null)));
        expect(forecast.weatherTitle, isNot(""));
        expect(forecast.weatherDescription, isNot(""));
      }
    });
    test('It gets daily forecast', () async {
      for (int i = 0; i < lats.length; i++) {
        double lat = lats[i];
        double lon = lats[i];
        OpenWeatherMapWeatherApi openWeatherMap =
            OpenWeatherMapWeatherApi(openWeatherMapApiKey, 'metric');
        List<WeatherForecast> forecasts =
            await openWeatherMap.dailyForecast(lat, lon);
        expect(forecasts.length, greaterThan(0));
        expect(forecasts.first.windGust, greaterThan(0));
        expect(forecasts.first.windSpeed, greaterThan(0));
        expect(forecasts.first.windDegree, greaterThan(0));
        expect(forecasts.first.humidityPercent, greaterThan(0));
        expect(forecasts.first.cloudsPercent, greaterThanOrEqualTo(0));
        expect(forecasts.first.lat, lat);
        expect(forecasts.first.lon, lon);
        expect(forecasts.first.temp, equals(null));
        expect(forecasts.first.tempFeelsLike, equals(null));
        expect(forecasts.first.mornTemp, isNot(equals(null)));
        expect(forecasts.first.mornFeelsLikeTemp, isNot(equals(null)));
        expect(forecasts.first.dayTemp, isNot(equals(null)));
        expect(forecasts.first.dayFeelsLikeTemp, isNot(equals(null)));
        expect(forecasts.first.eveTemp, isNot(equals(null)));
        expect(forecasts.first.eveFeelsLikeTemp, isNot(equals(null)));
        expect(forecasts.first.nightTemp, isNot(equals(null)));
        expect(forecasts.first.nightFeelsLikeTemp, isNot(equals(null)));
        expect(forecasts.first.cityName, isNot(null));
        expect(forecasts.first.pressureSeaLevel, isNot(null));
        expect(forecasts.first.pop, isNot(null));
        expect(forecasts.first.timezone, isNot(null));
        expect(forecasts.first.sunrise, isNot(null));
        expect(forecasts.first.sunset, isNot(null));
        expect(forecasts.first.weatherTitle, isNot(null));
        expect(forecasts.first.weatherDescription, isNot(null));
      }
    });
  });
}
