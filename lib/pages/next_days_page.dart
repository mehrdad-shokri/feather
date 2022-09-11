import 'package:client/components/daily_forecast_row.dart';
import 'package:client/components/forecast_secondary_card.dart';
import 'package:client/components/next_days_page_appbar.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/types/next_days_arguments.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NextDaysPage extends StatefulWidget {
  final NextDaysArguments arguments;

  const NextDaysPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<NextDaysPage> createState() => _NextDaysPageState();
}

class _NextDaysPageState extends State<NextDaysPage> {
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
      backgroundColor: backgroundColor(context),
      iosContentPadding: true,
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
                refreshIndicatorExtent: 150,
                onRefresh: () async {
                  await weatherBloc.refresh(widget.arguments.location);
                },
              ),
              material: (_, __) => const SliverToBoxAdapter(),
            ),
            NextDaysPageAppbar(
                dailyForecast: weatherBloc.dailyForecast, t: appLocalizations!),
            SliverToBoxAdapter(
              child: ForecastSecondaryCard(
                  location: settingsBloc.activeLocation,
                  onLocationChangeRequest: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  isUpdating: weatherBloc.isUpdating,
                  dailyForecast: weatherBloc.dailyForecast,
                  weatherUnit: weatherBloc.weatherUnit,
                  hourlyForecast: weatherBloc.hourlyForecast,
                  t: appLocalizations!),
            ),
            StreamBuilder(
              stream: weatherBloc.dailyForecast,
              builder: (context, snapshot) {
                List<WeatherForecast>? forecasts =
                    snapshot.data as List<WeatherForecast>?;
                if (forecasts == null || forecasts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: LoadingAnimationWidget.bouncingBall(
                        color: Constants.SECONDARY_COLOR,
                        size: Constants.ICON_LARGE_SIZE),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => DailyForecastRow(
                      forecast: forecasts.elementAt(index),
                      animationDelay: Duration(milliseconds: 60 * index),
                    ),
                    childCount: forecasts.length,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
