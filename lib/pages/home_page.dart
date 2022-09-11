import 'package:client/components/forecast_hero_card.dart';
import 'package:client/components/home_appbar.dart';
import 'package:client/components/hourly_forecasts.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/types/home_page_arguments.dart';
import 'package:client/types/next_days_arguments.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/utils/colors.dart';
import 'package:flutter/cupertino.dart';
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
    ServiceProvider provider = ServiceProvider.getInstance();
    settingsBloc = SettingsBloc(provider.sharedPrefsService);
    weatherBloc = WeatherBloc(provider.sharedPrefsService, provider.envService);
    weatherBloc.getCurrentForecast(widget.arguments.location,
        initialForecast: widget.arguments.location.forecast);
    weatherBloc.getHourlyForecast(widget.arguments.location);
    weatherBloc.getDailyForecast(widget.arguments.location);
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
      iosContentPadding: true,
      backgroundColor: backgroundColor(context),
      body: PlatformWidgetBuilder(
        material: (context, child, __) => RefreshIndicator(
          onRefresh: () async {
            await weatherBloc.refresh(widget.arguments.location);
          },
          child: child ?? Container(),
        ),
        cupertino: (context, child, _) => child,
        child: CustomScrollView(
          slivers: [
            PlatformWidget(
              cupertino: (_, __) => CupertinoSliverRefreshControl(
                refreshTriggerPullDistance: 250,
                refreshIndicatorExtent: 50,
                onRefresh: () async {
                  await weatherBloc.refresh(widget.arguments.location);
                },
              ),
              material: (_, __) => const SliverToBoxAdapter(),
            ),
            HomeAppbar(
                weatherUnit: weatherBloc.weatherUnit,
                onWeatherUnitChanged: (unit) {
                  weatherBloc.onUnitsChanged(unit);
                },
                onApiProviderChanged: (provider) {
                  weatherBloc.onWeatherApiProviderChanged(provider);
                },
                locale: settingsBloc.locale,
                currentForecast: weatherBloc.currentForecast,
                apiProvider: weatherBloc.weatherApiProvider,
                apiProviders: WeatherApiProvider.values,
                theme: settingsBloc.themeMode,
                themes: ThemeMode.values,
                locales: AppLocalizations.supportedLocales,
                onLocaleChange: (Locale locale) {
                  settingsBloc.onLocaleChanged(locale);
                  if (ServiceProvider.getInstance().localeChangeCallback !=
                      null) {
                    ServiceProvider.getInstance().localeChangeCallback!(locale);
                  }
                },
                onThemeChange: (ThemeMode themeMode) {
                  settingsBloc.onThemeChanged(themeMode);
                  if (ServiceProvider.getInstance().themeChangeCallback !=
                      null) {
                    ServiceProvider.getInstance()
                        .themeChangeCallback!(themeMode);
                  }
                },
                t: appLocalizations!),
            SliverToBoxAdapter(
              child: ForecastHeroCard(
                  location: settingsBloc.activeLocation,
                  onLocationChangeRequest: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  isUpdating: weatherBloc.isUpdating,
                  currentForecast: weatherBloc.currentForecast,
                  weatherUnit: weatherBloc.weatherUnit,
                  hourlyForecast: weatherBloc.hourlyForecast,
                  dailyForecast: weatherBloc.dailyForecast,
                  t: appLocalizations!),
            ),
            SliverToBoxAdapter(
              child: HourlyForecasts(
                  t: appLocalizations!,
                  isUpdating: weatherBloc.isUpdating,
                  onNextDaysClick: () => Navigator.pushNamed(context, '/7days',
                      arguments: NextDaysArguments(widget.arguments.location)),
                  hourlyForecast: weatherBloc.hourlyForecast),
            )
          ],
        ),
      ),
    );
  }
}
