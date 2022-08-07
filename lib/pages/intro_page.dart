import 'package:client/rx/app_provider.dart';
import 'package:client/rx/blocs/position_bloc.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late PositionBloc positionBloc;

  @override
  void initState() {
    super.initState();
    positionBloc = PositionBloc(AppProvider.getInstance().positionService);
  }

  @override
  Widget build(BuildContext context) {
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
                child: Lottie.asset('assets/lottie/sunny.json',
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
                          positionBloc.requestPermission();
                        },
                        child: StreamBuilder(
                          stream: positionBloc.requestingLocationPermission,
                          builder: (context, snapshot) {
                            bool? requesting = snapshot.data as bool?;
                            if (requesting != null && requesting) {
                              return PlatformCircularProgressIndicator();
                            }
                            return const Text('Get started');
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
