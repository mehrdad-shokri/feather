import 'package:client/components/temperature_icon.dart';
import 'package:client/models/location.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class CityCard extends StatelessWidget {
  final Location location;
  final bool shouldAddMargin;
  final VoidCallback onPress;

  const CityCard(
      {Key? key,
      required this.location,
      required this.shouldAddMargin,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: shouldAddMargin ? const EdgeInsets.only(top: 16) : null,
        key: key,
        child: PlatformElevatedButton(
            color: Colors.white,
            onPressed: onPress,
            padding: Constants.CARD_INNER_PADDING,
            material: (_, __) => MaterialElevatedButtonData(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )))),
            cupertino: (_, __) => CupertinoElevatedButtonData(
                borderRadius: BorderRadius.circular(16)),
            child: Stack(
              alignment: Alignment.topRight,
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                if (location.forecast != null)
                  Positioned(
                    top: 16,
                    right: -8,
                    child: Lottie.asset(
                        'assets/lottie/${location.forecast!.lottieAnimation}.json',
                        alignment: Alignment.center,
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.cityName,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: textColor(context),
                            fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                            fontSize: Constants.H6_FONT_SIZE)),
                    const SizedBox(
                      height: 4,
                    ),
                    if (strNotEmpty(location.country))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                              'icons/flags/png/${location.country.toLowerCase()}.png',
                              width: 24,
                              height: 16,
                              package: 'country_icons'),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(location.country.toUpperCase(),
                              style: TextStyle(
                                  color: placeholderColor(context),
                                  fontWeight: Constants.REGULAR_FONT_WEIGHT,
                                  fontSize: Constants.CAPTION_FONT_SIZE)),
                        ],
                      ),
                    Expanded(
                        child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: location.forecast == null
                          ? Container(
                              margin: EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingAnimationWidget.staggeredDotsWave(
                                      color: Constants.SECONDARY_COLOR,
                                      size: 32)
                                ],
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                if (location.forecast!.temp != null) ...[
                                  TemperatureIcon(
                                      unit: location.forecast!.unit,
                                      temperature:
                                          location.forecast!.temp.toString()),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                ],
                                Text(
                                  location.forecast!.weatherTitle,
                                  style: TextStyle(
                                      fontSize: Constants.S2_FONT_SIZE,
                                      fontWeight: Constants.REGULAR_FONT_WEIGHT,
                                      color: secondaryTextColor(context)),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/humidity.svg',
                                          width: Constants.ICON_SMALL_SIZE,
                                          height: Constants.ICON_SMALL_SIZE,
                                          fit: BoxFit.contain,
                                          color: Colors.blue.shade400,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '${location.forecast!.humidityPercent}%',
                                          style: TextStyle(
                                              color: textColor(context),
                                              fontSize: Constants.S2_FONT_SIZE,
                                              fontWeight: Constants
                                                  .REGULAR_FONT_WEIGHT),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/wind.svg',
                                          height: Constants.ICON_SMALL_SIZE,
                                          width: Constants.ICON_SMALL_SIZE,
                                          fit: BoxFit.contain,
                                          color: Colors.grey.shade500,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '${location.forecast!.humidityPercent.toStringAsFixed(0)}${windSpeedUnit(location.forecast!.unit)}',
                                          style: TextStyle(
                                              color: textColor(context),
                                              fontSize: Constants.S2_FONT_SIZE,
                                              fontWeight: Constants
                                                  .REGULAR_FONT_WEIGHT),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    )),
/*                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 250),
                      firstChild: Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.staggeredDotsWave(
                                color: Constants.SECONDARY_COLOR, size: 32)
                          ],
                        ),
                      ),
                      secondChild: Container(),
                      crossFadeState: location.forecast == null
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                    )*/
/*
                    if (location.forecast != null) ...[
                      const SizedBox(
                        height: 16,
                      ),
                      if (location.forecast!.temp != null) ...[
                        TemperatureIcon(
                            unit: location.forecast!.unit,
                            temperature: location.forecast!.temp.toString()),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                      Text(
                        location.forecast!.weatherTitle,
                        style: TextStyle(
                            fontSize: Constants.S2_FONT_SIZE,
                            fontWeight: Constants.REGULAR_FONT_WEIGHT,
                            color: secondaryTextColor(context)),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/humidity.svg',
                                width: Constants.ICON_SMALL_SIZE,
                                height: Constants.ICON_SMALL_SIZE,
                                fit: BoxFit.contain,
                                color: Colors.blue.shade400,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${location.forecast!.humidityPercent}%',
                                style: TextStyle(
                                    color: textColor(context),
                                    fontSize: Constants.S2_FONT_SIZE,
                                    fontWeight: Constants.REGULAR_FONT_WEIGHT),
                              )
                            ],
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/wind.svg',
                                height: Constants.ICON_SMALL_SIZE,
                                width: Constants.ICON_SMALL_SIZE,
                                fit: BoxFit.contain,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${location.forecast!.humidityPercent.toStringAsFixed(0)}${windSpeedUnit(location.forecast!.unit)}',
                                style: TextStyle(
                                    color: textColor(context),
                                    fontSize: Constants.S2_FONT_SIZE,
                                    fontWeight: Constants.REGULAR_FONT_WEIGHT),
                              )
                            ],
                          ),
                        ],
                      ),
                    ]
*/
                  ],
                ),
              ],
            )));
  }
}
