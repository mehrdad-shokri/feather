import 'package:client/rx/managers/logger.dart';
import 'package:client/types/weather_forecast.dart';

class OpenWeatherMap extends WeatherApi {
  OpenWeatherMap(super.baseUrl);

  @override
  Future<WeatherForecast> current() async {
    return apiClient.in
  }

  @override
  Future<List<WeatherForecast>> next7Days() {
  }
}
