import 'package:client/components/forecast_hero_appbar.dart';
import 'package:client/components/forecast_hero_card.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/types/home_page_arguments.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatefulWidget {
  final HomePageArguments arguments;

  const HomePage(this.arguments, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SettingsBloc settingsBloc;
  late WeatherBloc weatherBloc;
  AppLocalizations? appLocalizations;

  @override
  void initState() {
    super.initState();
    ServiceProvider appProvider = ServiceProvider.getInstance();
    settingsBloc = SettingsBloc(appProvider.sharedPrefsService);
    weatherBloc = WeatherBloc(settingsBloc.weatherApiProvider,
        settingsBloc.weatherUnit, appProvider.envService);
    weatherBloc.getCurrentForecast(widget.arguments.location,
        initialForecast: widget.arguments.location.forecast);
  }

  @override
  void dispose() {
    super.dispose();
    weatherBloc.dispose();
    settingsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations ??= AppLocalizations.of(context);
    return PlatformScaffold(
      appBar: forecastHeroAppBar(
          context: context,
          weatherUnit: settingsBloc.weatherUnit,
          onWeatherUnitChanged: (unit) {
            settingsBloc.onUnitsChanged(unit);
          },
          onApiProviderChanged: (provider) {
            settingsBloc.onWeatherApiProviderChanged(provider);
            weatherBloc.getCurrentForecast(widget.arguments.location);
          },
          apiProvider: settingsBloc.weatherApiProvider,
          apiProviders: WeatherApiProvider.values,
          t: appLocalizations!),
      iosContentPadding: true,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ForecastHeroCard(
                location: settingsBloc.activeLocation,
                onLocationChangeRequest: () {
                  Navigator.pushNamed(context, '/search');
                },
                isUpdating: weatherBloc.isUpdating,
                weatherForecast: weatherBloc.currentForecast,
                weatherUnit: settingsBloc.weatherUnit,
                t: appLocalizations!),
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(minHeight: 200),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        appLocalizations!.today,
                        style: TextStyle(
                            color: headingColor(context),
                            fontWeight: Constants.BOLD_FONT_WEIGHT,
                            fontSize: Constants.H6_FONT_SIZE),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            appLocalizations!.next7Days,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: Constants.BOLD_FONT_WEIGHT,
                                fontSize: Constants.S1_FONT_SIZE),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
