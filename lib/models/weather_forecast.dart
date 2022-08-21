import 'package:client/types/weather_units.dart';
import 'package:client/utils/date.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/material.dart';

class WeatherForecast {
  final String weatherTitle;
  final String weatherDescription;
  final String? countryCode;
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
  DateTime? _sunrise;
  DateTime? _sunset;
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
  final int weatherCode;
  String lottieAnimation;
  final WeatherUnits unit;
  List<Color> colorGradient;

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
      required this.weatherCode,
      required this.lottieAnimation,
      required this.unit,
      this.temp,
      this.tempFeelsLike,
      this.visibility,
      this.pressureSeaLevel,
      required DateTime? sunrise,
      required DateTime? sunset,
      this.cityName,
      this.countryCode,
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
      this.pop,
      required this.colorGradient})
      : _sunrise = sunrise,
        _sunset = sunset;

  factory WeatherForecast.fromOpenWeatherMapCurrentJson(
          Map<String, dynamic> data,
          double lat,
          double lon,
          WeatherUnits unit) =>
      WeatherForecast(
        unit: unit,
        lat: lat,
        lon: lon,
        temp: double.parse(data['main']['temp'].toString()),
        maxTemp: double.parse(data['main']['temp_max'].toString()),
        minTemp: double.parse(data['main']['temp_min'].toString()),
        weatherTitle: (data['weather'] as List).first['main'],
        weatherDescription: (data['weather'] as List).first['description'],
        lottieAnimation: _openWeatherMapWeatherCodeToLottieAnimation(
            (data['weather'] as List).first['id'],
            DateTime.now().toUtc(),
            DateTime.fromMillisecondsSinceEpoch(data['sys']['sunrise'] * 1000,
                isUtc: true),
            DateTime.fromMillisecondsSinceEpoch(data['sys']['sunset'] * 1000,
                isUtc: true)),
        colorGradient: _openWeatherMapWeatherCodeToColorGradients(
            (data['weather'] as List).first['id'],
            DateTime.now().toUtc(),
            DateTime.fromMillisecondsSinceEpoch(data['sys']['sunrise'] * 1000,
                isUtc: true),
            DateTime.fromMillisecondsSinceEpoch(data['sys']['sunset'] * 1000,
                isUtc: true)),
        weatherCode: (data['weather'] as List).first['id'],
        tempFeelsLike: double.parse(data['main']['feels_like'].toString()),
        humidityPercent: data['main']['humidity'],
        pressureSeaLevel: data['main']['sea_level'] ?? data['main']['pressure'],
        pressureGroundLevel: data['main']['grnd_level'],
        visibility: data['visibility'],
        windDegree: data['wind']?['deg'] != null ? data['wind']['deg'] : -1,
        windGust: data['wind']?['gust'] != null
            ? double.parse(data['wind']['gust'].toString()) *
                _openWeatherMapMetricCorrection(unit)
            : -1,
        windSpeed: data['wind']?['speed'] != null
            ? double.parse(data['wind']['speed'].toString()) *
                _openWeatherMapMetricCorrection(unit)
            : -1,
        timezone: data['timezone'],
        sunrise: DateTime.fromMillisecondsSinceEpoch(
            data['sys']['sunrise'] * 1000,
            isUtc: true),
        sunset: DateTime.fromMillisecondsSinceEpoch(
            data['sys']['sunset'] * 1000,
            isUtc: true),
        cityName: data['name'],
        countryCode: data['sys']['country'].toString().toLowerCase(),
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
            ? double.parse(data['snow']['3h'])
            : null,
        date: DateTime.now().toUtc(),
      );

  factory WeatherForecast.fromOpenWeatherMapDailyForecastJson(
          Map<String, dynamic> data,
          int timezone,
          double lat,
          double lon,
          String cityName,
          String countryCode,
          WeatherUnits unit) =>
      WeatherForecast(
          unit: unit,
          lat: lat,
          lon: lon,
          maxTemp: double.parse(data['temp']['max'].toString()),
          minTemp: double.parse(data['temp']['min'].toString()),
          weatherTitle: (data['weather'] as List).first['main'],
          weatherCode: (data['weather'] as List).first['id'],
          lottieAnimation: _openWeatherMapWeatherCodeToLottieAnimation(
              (data['weather'] as List).first['id'],
              DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000,
                  isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(data['sunrise'] * 1000,
                  isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(data['sunset'] * 1000,
                  isUtc: true)),
          colorGradient: _openWeatherMapWeatherCodeToColorGradients(
              (data['weather'] as List).first['id'],
              DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000,
                  isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(data['sunrise'] * 1000,
                  isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(data['sunset'] * 1000,
                  isUtc: true)),
          weatherDescription: (data['weather'] as List).first['description'],
          humidityPercent: data['humidity'],
          pressureSeaLevel: data['pressure'],
          windDegree: data['deg'] ?? -1,
          windGust: data['gust'] != null
              ? double.parse(data['gust'].toString()) *
                  _openWeatherMapMetricCorrection(unit)
              : -1,
          windSpeed: data['speed'] != null
              ? double.parse(data['speed'].toString()) *
                  _openWeatherMapMetricCorrection(unit)
              : -1,
          cityName: cityName,
          countryCode: countryCode.toLowerCase(),
          timezone: timezone,
          sunrise: DateTime.fromMillisecondsSinceEpoch(data['sunrise'] * 1000,
              isUtc: true),
          sunset: DateTime.fromMillisecondsSinceEpoch(data['sunset'] * 1000,
              isUtc: true),
          cloudsPercent: data['clouds'],
          dayTemp: double.parse(data['temp']['day'].toString()),
          nightTemp: double.parse(data['temp']['night'].toString()),
          mornTemp: double.parse(data['temp']['morn'].toString()),
          eveTemp: double.parse(data['temp']['eve'].toString()),
          mornFeelsLikeTemp:
              double.parse(data['feels_like']['morn'].toString()),
          eveFeelsLikeTemp: double.parse(data['feels_like']['eve'].toString()),
          dayFeelsLikeTemp: double.parse(data['feels_like']['day'].toString()),
          nightFeelsLikeTemp:
              double.parse(data['feels_like']['night'].toString()),
          rainForecast: data['rain'] != null
              ? double.parse(data['rain'].toString())
              : null,
          snowForecast: data['snow'] != null
              ? double.parse(data['snow'].toString())
              : null,
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
          int sunset,
          String countryCode,
          WeatherUnits unit) =>
      WeatherForecast(
          unit: unit,
          lat: lat,
          lon: lon,
          temp: double.parse(data['main']['temp'].toString()),
          maxTemp: double.parse(data['main']['temp_max'].toString()),
          minTemp: double.parse(data['main']['temp_min'].toString()),
          weatherTitle: (data['weather'] as List).first['main'],
          weatherDescription: (data['weather'] as List).first['description'],
          weatherCode: (data['weather'] as List).first['id'],
          lottieAnimation: _openWeatherMapWeatherCodeToLottieAnimation(
              (data['weather'] as List).first['id'],
              DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000,
                  isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)),
          colorGradient: _openWeatherMapWeatherCodeToColorGradients(
              (data['weather'] as List).first['id'],
              DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000,
                  isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true),
              DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)),
          tempFeelsLike: double.parse(data['main']['feels_like'].toString()),
          humidityPercent: data['main']['humidity'],
          pressureSeaLevel: data['main']['pressure'],
          pressureGroundLevel: data['main']['grnd_level'],
          visibility: data['visibility'],
          windDegree: data['wind']?['deg'] != null ? data['wind']['deg'] : -1,
          windGust: data['wind']?['gust'] != null
              ? double.parse(data['wind']['gust'].toString()) *
                  _openWeatherMapMetricCorrection(unit)
              : -1,
          windSpeed: data['wind']?['speed'] != null
              ? double.parse(data['wind']['speed'].toString()) *
                  _openWeatherMapMetricCorrection(unit)
              : -1,
          timezone: timezone,
          sunrise:
              DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true),
          sunset:
              DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true),
          cityName: cityName,
          countryCode: countryCode.toLowerCase(),
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
          pop:
              data['pop'] != null ? double.parse(data['pop'].toString()) : null,
          date: DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000,
              isUtc: true));

  static String _openWeatherMapWeatherCodeToLottieAnimation(
      int weatherCode, DateTime date, DateTime? sunrise, DateTime? sunset) {
    switch (weatherCode) {
      case 200:
      case 201:
      case 202:
      case 230:
      case 231:
      case 232:
        return 'thunderstorm_with_rain';
      case 210:
      case 211:
      case 212:
      case 221:
        return 'thunderstorm';
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
      case 520:
      case 521:
      case 522:
      case 523:
        return 'drizzle';
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return 'rain_night';
        }
        return 'rain_day';
      case 511:
      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return 'snow_night';
        }
        return 'snow_day';
      case 701:
      case 711:
      case 721:
      case 731:
      case 741:
      case 751:
      case 761:
      case 762:
      case 771:
      case 781:
        return 'mist';
      case 800:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return 'clear';
        }
        return 'sunny';
      case 801:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return 'cloud_night';
        }
        return 'cloud_day';
      case 802:
      case 803:
      case 804:
        return 'clouds';
      default:
        return 'sunny';
    }
  }

  static List<Color> _openWeatherMapWeatherCodeToColorGradients(
      int weatherCode, DateTime date, DateTime? sunrise, DateTime? sunset) {
    switch (weatherCode) {
      case 200:
      case 201:
      case 202:
      case 230:
      case 231:
      case 232:
        return [
          HexColor.fromHex('#6da5fa'),
          HexColor.fromHex('#4680f2'),
          HexColor.fromHex('#094bf4'),
        ];
      case 210:
      case 211:
      case 212:
      case 221:
        return [
          HexColor.fromHex('#6da5fa'),
          HexColor.fromHex('#4680f2'),
          HexColor.fromHex('#094bf4'),
        ];

      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
      case 520:
      case 521:
      case 522:
      case 523:
        return [
          HexColor.fromHex('#7bb2ff'),
          HexColor.fromHex('#628af1'),
          HexColor.fromHex('#1a5bbd'),
        ];

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return [
            HexColor.fromHex('#4456f4'),
            HexColor.fromHex('#2329cb'),
            HexColor.fromHex('#092795'),
          ];
        }
        return [
          HexColor.fromHex('#458af1'),
          HexColor.fromHex('#387EE8'),
          HexColor.fromHex('#0060c0'),
        ];

      case 511:
      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return [
            HexColor.fromHex('#4c97df'),
            HexColor.fromHex('#548bc1'),
            HexColor.fromHex('#03398b'),
          ];
        }
        return [
          HexColor.fromHex('95b7ff'),
          HexColor.fromHex('#45aefb'),
          HexColor.fromHex('#0185ff'),
        ];
      case 701:
      case 711:
      case 721:
      case 731:
      case 741:
      case 751:
      case 761:
      case 762:
      case 771:
      case 781:
        return [
          HexColor.fromHex('#b4c9f6'),
          HexColor.fromHex('#88b6d7'),
          HexColor.fromHex('#6796c0'),
        ];
      case 800:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return [
            HexColor.fromHex('#232B70'),
            HexColor.fromHex('#011098'),
            HexColor.fromHex('#080C72'),
          ];
        }
        return [
          HexColor.fromHex('#6dc2ff'),
          HexColor.fromHex('#5ea8fe'),
          HexColor.fromHex('#0f6ad6'),
        ];
      case 801:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return [
            HexColor.fromHex('#4650A9'),
            HexColor.fromHex('#3B438B'),
            HexColor.fromHex('#2C2A89'),
          ];
        }
        return [
          HexColor.fromHex('#7DCFFE'),
          HexColor.fromHex('#45A5FE'),
          HexColor.fromHex('#0085FF'),
        ];
      case 802:
      case 803:
      case 804:
        if (sunrise != null &&
            sunset != null &&
            isNight(date, sunrise, sunset)) {
          return [
            HexColor.fromHex('#1D3677'),
            HexColor.fromHex('#2F3F7B'),
            HexColor.fromHex('#08215C'),
          ];
        }
        return [
          HexColor.fromHex('#06c7f1'),
          HexColor.fromHex('#07b9e0'),
          HexColor.fromHex('#0648f1'),
        ];
      default:
        return [
          HexColor.fromHex('#0f6ad6'),
          HexColor.fromHex('#5ea8fe'),
          HexColor.fromHex('#6dc2ff')
        ];
    }
  }

  static double _openWeatherMapMetricCorrection(WeatherUnits unit) =>
      (unit == WeatherUnits.metric ? 3.6 : 1);

  @override
  bool operator ==(Object other) =>
      other is WeatherForecast &&
      lat == other.lat &&
      lon == other.lon &&
      date == other.date;

  @override
  int get hashCode => (lat * lon).toInt();

  String get id => '$lat-$lon';

  set sunrise(DateTime? value) {
    _sunrise = value;
    lottieAnimation = _openWeatherMapWeatherCodeToLottieAnimation(
        weatherCode, date, value, _sunset);
    colorGradient = _openWeatherMapWeatherCodeToColorGradients(
        weatherCode, date, value, _sunset);
  }

  set sunset(DateTime? value) {
    _sunset = value;
    lottieAnimation = _openWeatherMapWeatherCodeToLottieAnimation(
        weatherCode, date, _sunrise, value);
    colorGradient = _openWeatherMapWeatherCodeToColorGradients(
        weatherCode, date, _sunrise, value);
  }

  DateTime? get sunrise => _sunrise;

  DateTime? get sunset => _sunset;
}
