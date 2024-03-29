import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late SettingsBloc settingsBloc;
  AppLocalizations? appLocalizations;

  @override
  void initState() {
    super.initState();
    settingsBloc =
        SettingsBloc(ServiceProvider.getInstance().sharedPrefsService);
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations ??= AppLocalizations.of(context);

    return PlatformScaffold(
      body: SafeArea(
        bottom: true,
        top: false,
        child: Padding(
          padding: Constants.PAGE_PADDING,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 32,
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Image.asset('assets/images/logo.png',
                    width: double.maxFinite),
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      Text(
                        'Find the sun in your city!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: Constants.BOLD_FONT_WEIGHT,
                            color: Constants.SECONDARY_COLOR_DARK,
                            fontSize: Constants.H3_FONT_SIZE),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                          'Feather is an open source, free weather app powered by various weather forecast providers.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.3,
                              color: secondaryTextColor(context),
                              fontSize: Constants.S1_FONT_SIZE)),
                      const Spacer(
                        flex: 1,
                      ),
                      PlatformElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/search', (route) => true);
                        },
                        color: Constants.PRIMARY_COLOR,
                        material: (_, __) => MaterialElevatedButtonData(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(145, 45),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16))),
                        child: Text(
                          appLocalizations!.getStarted,
                          style: const TextStyle(
                              fontSize: Constants.S1_FONT_SIZE,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    settingsBloc.dispose();
  }
}
