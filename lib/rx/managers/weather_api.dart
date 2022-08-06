import 'package:client/rx/managers/api_client.dart';
import 'package:client/types/weather_forecast.dart';

abstract class WeatherApi {
  final ApiClient apiClient;
  final String unit;

  WeatherApi(String baseUrl, this.unit) : apiClient = ApiClient(baseUrl);

  Future<List<WeatherForecast>> dailyForecast(double lat, double lon);

  Future<List<WeatherForecast>> hourlyForecast(double lat, double lon);

  Future<WeatherForecast> current(double lat, double lon);
}
