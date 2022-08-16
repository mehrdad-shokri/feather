import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/managers/weather_api.dart';
import 'package:client/types/weather_units.dart';

class MockWeatherApi extends WeatherApi {
  MockWeatherApi() : super('', WeatherUnits.metric);

  @override
  Future<WeatherForecast> current(double lat, double lon) {
    throw UnimplementedError();
  }

  @override
  Future<List<WeatherForecast>> dailyForecast(double lat, double lon) {
    throw UnimplementedError();
  }

  @override
  Future<List<WeatherForecast>> hourlyForecast(double lat, double lon) {
    throw UnimplementedError();
  }
}
