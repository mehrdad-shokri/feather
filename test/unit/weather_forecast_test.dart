import 'dart:convert';
import 'dart:io';

import 'package:client/models/weather_forecast.dart';
import 'package:client/types/weather_units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Openweathermap test', () {
    test('it constructors from Openweathermap current forecast', () {
      Map<String, dynamic> json = jsonDecode(
          File('test/fixtures/open_weather_map_current_forecast.json')
              .readAsStringSync()) as Map<String, dynamic>;
      WeatherForecast forecast = WeatherForecast.fromOpenWeatherMapCurrentJson(
          json, 35, 139, WeatherUnits.metric);
      expect(forecast.temp, equals(26.84));
      expect(forecast.lat, equals(35));
      expect(forecast.lon, equals(139));
      expect(forecast.tempFeelsLike, equals(29.91));
      expect(forecast.minTemp, equals(26.84));
      expect(forecast.maxTemp, equals(26.84));
      expect(forecast.pressureSeaLevel, equals(1004));
      expect(forecast.humidityPercent, equals(86));
      expect(forecast.visibility, equals(10000));
      expect(forecast.windSpeed, equals(5.47 * 3.6));
      expect(forecast.windDegree, equals(55));
      expect(forecast.windGust, equals(9.73 * 3.6));
      expect(forecast.cloudsPercent, equals(94));
      expect(forecast.timezone, equals(32400));
      expect(forecast.date.day, equals(DateTime.now().toUtc().day));
      expect(forecast.date.month, equals(DateTime.now().toUtc().month));
      expect(forecast.date.year, equals(DateTime.now().toUtc().year));
      expect(forecast.cityName, equals('Shuzenji'));
      expect(forecast.countryCode, equals('jp'));
      expect(forecast.unit, equals(WeatherUnits.metric));
      expect(
          forecast.sunrise,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659556511000, isUtc: true)));
      expect(
          forecast.sunset,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659606302000, isUtc: true)));
      expect(forecast.timezone, equals(32400));
    });
    test('it constructors from Openweathermap daily forecast', () {
      Map<String, dynamic> json = jsonDecode(
          File('test/fixtures/open_weather_map_daily_forecast.json')
              .readAsStringSync()) as Map<String, dynamic>;
      Map<String, dynamic> data = (json['list'] as List).first;
      WeatherForecast forecast =
          WeatherForecast.fromOpenWeatherMapDailyForecastJson(
              data, 32400, 35, 139, 'Shuzenji', 'jp', WeatherUnits.metric);
      expect(forecast.unit, equals(WeatherUnits.metric));
      expect(forecast.countryCode, equals('jp'));
      expect(forecast.temp, equals(null));
      expect(forecast.tempFeelsLike, equals(null));
      expect(forecast.lat, equals(35));
      expect(forecast.lon, equals(139));
      expect(forecast.cityName, equals('Shuzenji'));
      expect(forecast.dayTemp, equals(32.45));
      expect(forecast.mornTemp, equals(24.43));
      expect(forecast.nightTemp, equals(26.29));
      expect(forecast.eveTemp, equals(32.5));
      expect(forecast.mornFeelsLikeTemp, equals(25.46));
      expect(forecast.dayFeelsLikeTemp, equals(36.02));
      expect(forecast.nightFeelsLikeTemp, equals(26.29));
      expect(forecast.eveFeelsLikeTemp, equals(37));
      expect(forecast.pressureSeaLevel, equals(1009));
      expect(forecast.humidityPercent, equals(53));
      expect(forecast.weatherTitle, equals("Clouds"));
      expect(forecast.weatherDescription, equals("few clouds"));
      expect(forecast.minTemp, equals(24.43));
      expect(forecast.maxTemp, equals(34.9));
      expect(
          forecast.sunrise,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659470065000, isUtc: true)));
      expect(
          forecast.sunset,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659519956000, isUtc: true)));
      expect(
          forecast.date,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659492000000, isUtc: true)));
      expect(forecast.windSpeed, equals(3.14));
      expect(forecast.windGust, equals(6.3));
      expect(forecast.windDegree, equals(270));
      expect(forecast.cloudsPercent, equals(13));
      expect(forecast.timezone, equals(32400));
      expect(forecast.pop, equals(0.16));
      expect(forecast.snowForecast, equals(null));
      expect(forecast.rainForecast, equals(27.58));
    });
    test('it constructors from Openweathermap hourly forecast', () {
      Map<String, dynamic> json = jsonDecode(
          File('test/fixtures/open_weather_map_hourly_forecast.json')
              .readAsStringSync()) as Map<String, dynamic>;
      Map<String, dynamic> data = (json['list'] as List).first;
      WeatherForecast forecast =
          WeatherForecast.fromOpenWeatherMapHourlyForecastJson(
              data,
              32400,
              35,
              139,
              'Shuzenji',
              1659470065,
              1659519956,
              'jp',
              WeatherUnits.metric);
      expect(forecast.temp, equals(26.29));
      expect(forecast.unit, equals(WeatherUnits.metric));
      expect(forecast.countryCode, equals('jp'));
      expect(forecast.tempFeelsLike, equals(26.29));
      expect(forecast.lat, equals(35));
      expect(forecast.lon, equals(139));
      expect(forecast.cityName, equals('Shuzenji'));
      expect(forecast.dayTemp, equals(null));
      expect(forecast.mornTemp, equals(null));
      expect(forecast.nightTemp, equals(null));
      expect(forecast.eveTemp, equals(null));
      expect(forecast.mornFeelsLikeTemp, equals(null));
      expect(forecast.dayFeelsLikeTemp, equals(null));
      expect(forecast.nightFeelsLikeTemp, equals(null));
      expect(forecast.eveFeelsLikeTemp, equals(null));
      expect(forecast.pressureSeaLevel, equals(1005));
      expect(forecast.pressureGroundLevel, equals(980));
      expect(forecast.humidityPercent, equals(87));
      expect(forecast.weatherTitle, equals("Clouds"));
      expect(forecast.weatherDescription, equals("overcast clouds"));
      expect(forecast.minTemp, equals(26.29));
      expect(forecast.maxTemp, equals(27.22));
      expect(
          forecast.sunrise,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659470065000, isUtc: true)));
      expect(
          forecast.sunset,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659519956000, isUtc: true)));
      expect(
          forecast.date,
          equals(
              DateTime.fromMillisecondsSinceEpoch(1659538800000, isUtc: true)));
      expect(forecast.windSpeed, equals(2.12));
      expect(forecast.windGust, equals(3.13));
      expect(forecast.windDegree, equals(76));
      expect(forecast.cloudsPercent, equals(100));
      expect(forecast.timezone, equals(32400));
      expect(forecast.pop, equals(0.28));
      expect(forecast.rainVolume1h, equals(null));
      expect(forecast.rainVolume3h, equals(1.38));
      expect(forecast.snowVolume3h, equals(null));
      expect(forecast.snowVolume1h, equals(null));
      expect(forecast.snowForecast, equals(null));
      expect(forecast.rainForecast, equals(null));
    });
  });
}
