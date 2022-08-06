class WeatherForecast {
  final String weatherTitle;
  final String weatherDescription;
  final double? tempFeelsLike;
  final double maxTemp;
  final double minTemp;
  final int humidityPercent;
  final int cloudsPercent;
  final int? visibility;
  final double windSpeed;
  final int windDegree;
  final double windGust;
  final int timezone;
  final DateTime date;
  final double? temp;
  final int? pressureSeaLevel;
  final int? pressureGroundLevel;
  final DateTime? sunrise;
  final DateTime? sunset;
  final String? cityName;
  final double? rainVolume1h;
  final double? rainVolume3h;
  final double? snowVolume1h;
  final double? snowVolume3h;
  final double? rainForecast;
  final double? snowForecast;
  final double? dayTemp;
  final double? nightTemp;
  final double? eveTemp;
  final double? mornTemp;
  final double? dayFeelsLikeTemp;
  final double? nightFeelsLikeTemp;
  final double? eveFeelsLikeTemp;
  final double? mornFeelsLikeTemp;
  final double lat;
  final double lon;
  final double? pop;

  // final int weatherCode;

  WeatherForecast(
      {required this.maxTemp,
      required this.minTemp,
      required this.weatherTitle,
      required this.weatherDescription,
      required this.humidityPercent,
      required this.windSpeed,
      required this.windDegree,
      required this.windGust,
      required this.timezone,
      required this.date,
      required this.cloudsPercent,
      required this.lat,
      required this.lon,
      this.temp,
      this.tempFeelsLike,
      this.visibility,
      this.pressureSeaLevel,
      this.sunrise,
      this.sunset,
      this.cityName,
      this.rainVolume1h,
      this.rainVolume3h,
      this.snowVolume1h,
      this.snowVolume3h,
      this.mornTemp,
      this.eveTemp,
      this.nightTemp,
      this.dayTemp,
      this.mornFeelsLikeTemp,
      this.dayFeelsLikeTemp,
      this.nightFeelsLikeTemp,
      this.eveFeelsLikeTemp,
      this.pressureGroundLevel,
      this.rainForecast,
      this.snowForecast,
      this.pop});

  factory WeatherForecast.fromOpenWeatherMapCurrentJson(
          Map<String, dynamic> data, double lat, double lon) =>
      WeatherForecast(
          lat: lat,
          lon: lon,
          temp: double.parse(data['main']['temp'].toString()),
          maxTemp: double.parse(data['main']['temp_max'].toString()),
          minTemp: double.parse(data['main']['temp_min'].toString()),
          weatherTitle: (data['weather'] as List).first['main'],
          weatherDescription: (data['weather'] as List).first['description'],
          tempFeelsLike: double.parse(data['main']['feels_like'].toString()),
          humidityPercent: data['main']['humidity'],
          pressureSeaLevel:
              data['main']['sea_level'] ?? data['main']['pressure'],
          pressureGroundLevel: data['main']['grnd_level'],
          visibility: data['visibility'],
          windDegree: data['wind']?['deg'] != null ? data['wind']['deg'] : -1,
          windGust: data['wind']?['gust'] != null
              ? double.parse(data['wind']['gust'].toString())
              : -1,
          windSpeed: data['wind']?['speed'] != null
              ? double.parse(data['wind']['speed'].toString())
              : -1,
          timezone: data['timezone'],
          sunrise: DateTime.fromMillisecondsSinceEpoch(
              data['sys']['sunrise'] * 1000,
              isUtc: true),
          sunset: DateTime.fromMillisecondsSinceEpoch(
              data['sys']['sunset'] * 1000,
              isUtc: true),
          cityName: data['name'],
          cloudsPercent: data['clouds']['all'],
          rainVolume1h: data['rain'] != null
              ? double.parse(data['rain']['1h'].toString())
              : null,
          rainVolume3h: data['rain'] != null
              ? double.parse(data['rain']['3h'].toString())
              : null,
          snowVolume1h: data['snow']?['1h'] != null
              ? double.parse(data['snow']['1h'].toString())
              : null,
          snowVolume3h: data['snow']?['3h'] != null
              ? double.parse(data['snow']['3h'])
              : null,
          date: DateTime.now().toUtc());

  factory WeatherForecast.fromOpenWeatherMapDailyForecastJson(
          Map<String, dynamic> data,
          int timezone,
          double lat,
          double lon,
          String cityName) =>
      WeatherForecast(
          lat: lat,
          lon: lon,
          maxTemp: double.parse(data['temp']['max'].toString()),
          minTemp: double.parse(data['temp']['min'].toString()),
          weatherTitle: (data['weather'] as List).first['main'],
          weatherDescription: (data['weather'] as List).first['description'],
          humidityPercent: data['humidity'],
          pressureSeaLevel: data['pressure'],
          windDegree: data['deg'] ?? -1,
          windGust:
              data['gust'] != null ? double.parse(data['gust'].toString()) : -1,
          windSpeed: data['speed'] != null
              ? double.parse(data['speed'].toString())
              : -1,
          cityName: cityName,
          timezone: timezone,
          sunrise: DateTime.fromMillisecondsSinceEpoch(data['sunrise'] * 1000,
              isUtc: true),
          sunset: DateTime.fromMillisecondsSinceEpoch(data['sunset'] * 1000,
              isUtc: true),
          cloudsPercent: data['clouds'],
          dayTemp: double.parse(data['temp']['day'].toString()),
          nightTemp: double.parse(data['temp']['night'].toString()),
          mornTemp: double.parse(data['temp']['morn'].toString()),
          eveTemp: double.parse(
              double.parse(data['temp']['eve'].toString()).toString()),
          mornFeelsLikeTemp:
              double.parse(data['feels_like']['morn'].toString()),
          eveFeelsLikeTemp: double.parse(data['feels_like']['eve'].toString()),
          dayFeelsLikeTemp: double.parse(data['feels_like']['day'].toString()),
          nightFeelsLikeTemp:
              double.parse(data['feels_like']['night'].toString()),
          rainForecast: data['rain'],
          snowForecast: data['snow'],
          pop: double.parse(data['pop'].toString()),
          date: DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000,
              isUtc: true));

  factory WeatherForecast.fromOpenWeatherMapHourlyForecastJson(
          Map<String, dynamic> data,
          int timezone,
          double lat,
          double lon,
          String cityName,
          int sunrise,
          int sunset) =>
      WeatherForecast(
          lat: lat,
          lon: lon,
          temp: double.parse(data['main']['temp'].toString()),
          maxTemp: double.parse(data['main']['temp_max'].toString()),
          minTemp: double.parse(data['main']['temp_min'].toString()),
          weatherTitle: (data['weather'] as List).first['main'],
          weatherDescription: (data['weather'] as List).first['description'],
          tempFeelsLike: double.parse(data['main']['feels_like'].toString()),
          humidityPercent: data['main']['humidity'],
          pressureSeaLevel: data['main']['pressure'],
          pressureGroundLevel: data['main']['grnd_level'],
          visibility: data['visibility'],
          windDegree: data['wind']?['deg'] != null ? data['wind']['deg'] : -1,
          windGust: data['wind']?['gust'] != null
              ? double.parse(data['wind']['gust'].toString())
              : -1,
          windSpeed: data['wind']?['speed'] != null
              ? double.parse(data['wind']['speed'].toString())
              : -1,
          timezone: timezone,
          sunrise:
              DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true),
          sunset:
              DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true),
          cityName: cityName,
          cloudsPercent: data['clouds']['all'],
          rainVolume1h: data['rain']?['1h'] != null
              ? double.parse(data['rain']['1h'].toString())
              : null,
          rainVolume3h: data['rain']?['3h'] != null
              ? double.parse(data['rain']['3h'].toString())
              : null,
          snowVolume1h: data['snow']?['1h'] != null
              ? double.parse(data['snow']['1h'].toString())
              : null,
          snowVolume3h: data['snow']?['3h'] != null
              ? double.parse(data['snow']['3h'].toString())
              : null,
          pop: data['pop'],
          date: DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000,
              isUtc: true));
}
