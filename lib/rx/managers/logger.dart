import 'package:client/rx/managers/api_client.dart';
import 'package:client/types/weather_forecast.dart';

abstract class WeatherApi {
  final ApiClient apiClient;

  WeatherApi(String baseUrl) : apiClient = ApiClient(baseUrl);

  Future<List<WeatherForecast>> next7Days();

  Future<WeatherForecast> current();
}
