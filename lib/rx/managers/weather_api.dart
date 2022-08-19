import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/managers/api_client.dart';
import 'package:client/types/weather_units.dart';

abstract class WeatherApi {
  final ApiClient apiClient;
  final WeatherUnits unit;

  WeatherApi(String baseUrl, this.unit) : apiClient = ApiClient(baseUrl);

  Future<List<WeatherForecast>> dailyForecast(double lat, double lon);

  Future<List<WeatherForecast>> hourlyForecast(double lat, double lon);

  Future<WeatherForecast> current(double lat, double lon);

  String unitToQueryParam() =>
      unit == WeatherUnits.metric ? 'metric' : 'imperial';
}
