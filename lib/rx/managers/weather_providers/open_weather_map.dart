import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/managers/weather_api.dart';
import 'package:client/types/weather_units.dart';

class OpenWeatherMapWeatherApi extends WeatherApi {
  final String appId;

  OpenWeatherMapWeatherApi(this.appId, WeatherUnits unit)
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
            'units': _unitToQueryParam()
          },
        ))
            .data,
        lat,
        lon,
        unit);
  }

  @override
  Future<List<WeatherForecast>> dailyForecast(double lat, double lon) async {
    Map<String, dynamic> data = (await apiClient.instance.get(
      '/forecast/daily',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': appId,
        'units': _unitToQueryParam()
      },
    ))
        .data as Map<String, dynamic>;
    int timezone = data['city']['timezone'];
    String cityName = data['city']['name'];
    String countryCode = data['city']['country'];
    return (data['list'] as List)
        .map((e) => WeatherForecast.fromOpenWeatherMapDailyForecastJson(
            e, timezone, lat, lon, cityName, countryCode, unit))
        .toList();
  }

  @override
  Future<List<WeatherForecast>> hourlyForecast(double lat, double lon) async {
    Map<String, dynamic> data = (await apiClient.instance.get('/forecast',
            queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': appId,
          'units': _unitToQueryParam()
        }))
        .data as Map<String, dynamic>;
    int timezone = data['city']['timezone'];
    int sunrise = data['city']['sunrise'];
    int sunset = data['city']['sunset'];
    String cityName = data['city']['name'];
    String countryCode = data['city']['country'];
    return (data['list'] as List)
        .map((e) => WeatherForecast.fromOpenWeatherMapHourlyForecastJson(e,
            timezone, lat, lon, cityName, sunrise, sunset, countryCode, unit))
        .toList();
  }

  String _unitToQueryParam() =>
      unit == WeatherUnits.metric ? 'metric' : 'imperial';
}
