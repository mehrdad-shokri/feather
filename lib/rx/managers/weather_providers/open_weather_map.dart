import 'package:client/rx/managers/weather_api.dart';
import 'package:client/types/weather_forecast.dart';

class OpenWeatherMapWeatherApi extends WeatherApi {
  final String appId;

  OpenWeatherMapWeatherApi(this.appId, String unit)
      : super('https://api.openweathermap.org/data/2.5', unit);

  @override
  Future<WeatherForecast> current(
    double lat,
    double lon,
  ) async {
    return WeatherForecast.fromOpenWeatherMapCurrentJson(
        (await apiClient.instance.get(
          '/weather',
          queryParameters: {
            'lat': lat,
            'lon': lon,
            'appid': appId,
            'units': unit
          },
        ))
            .data,
        lat,
        lon);
  }

  @override
  Future<List<WeatherForecast>> dailyForecast(double lat, double lon) async {
    Map<String, dynamic> data = (await apiClient.instance.get(
      '/forecast/daily',
      queryParameters: {'lat': lat, 'lon': lon, 'appid': appId, 'units': unit},
    ))
        .data as Map<String, dynamic>;
    int timezone = data['city']['timezone'];
    String cityName = data['city']['name'];
    return (data['list'] as List)
        .map((e) => WeatherForecast.fromOpenWeatherMapDailyForecastJson(
            e, timezone, lat, lon, cityName))
        .toList();
  }

  @override
  Future<List<WeatherForecast>> hourlyForecast(double lat, double lon) async {
    Map<String, dynamic> data = (await apiClient.instance.get('/forecast',
            queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': appId,
          'units': unit
        }))
        .data as Map<String, dynamic>;
    int timezone = data['city']['coord']['timezone'];
    int sunrise = data['city']['sunrise'];
    int sunset = data['city']['sunset'];
    String cityName = data['city']['name'];
    return (data['list'] as List)
        .map((e) => WeatherForecast.fromOpenWeatherMapHourlyForecastJson(
            e, timezone, lat, lon, cityName, sunrise, sunset))
        .toList();
  }
}
