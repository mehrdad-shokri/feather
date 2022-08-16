import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForecastHeroCard extends StatelessWidget {
  final Stream<Location> location;
  final Function onLocationChangeRequest;
  final Stream<bool> isUpdating;
  final Stream<WeatherForecast> weatherForecast;

  const ForecastHeroCard(
      {Key? key,
      required this.location,
      required this.onLocationChangeRequest,
      required this.isUpdating,
      required this.weatherForecast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Constants.PAGE_PADDING,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                HexColor.fromHex('#06c7f1'),
                HexColor.fromHex('#07b9e0'),
                HexColor.fromHex('#0648f1')
              ],
              begin: const FractionalOffset(0.5, 0),
              end: const FractionalOffset(0.5, 1.0),
              stops: const [0.0, .31, .95],
              tileMode: TileMode.clamp)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Feather.pin_drop),
              const SizedBox(
                width: 8,
              ),
              StreamBuilder(
                stream: location,
                builder: (context, snapshot) {
                  Location? location = snapshot.data as Location?;
                  return Text(location?.cityName ?? '');
                },
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          StreamBuilder(
            stream: isUpdating,
            builder: (context, snapshot) {
              bool? updating = snapshot.data as bool?;
              if (updating != null && updating) {
                return Container(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      LoadingAnimationWidget.inkDrop(
                          color: Colors.white, size: 16),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text(
                        'Loading',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                            fontSize: Constants.CAPTION_FONT_SIZE),
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
