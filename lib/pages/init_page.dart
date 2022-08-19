import 'package:client/models/location.dart';
import 'package:client/pages/home_page.dart';
import 'package:client/pages/intro_page.dart';
import 'package:client/pages/loading_page.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/types/home_page_arguments.dart';
import 'package:flutter/widgets.dart';

class InitPage extends StatelessWidget {
  final Future<void> future;

  const InitPage({Key? key, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          SettingsBloc settingsBloc =
              SettingsBloc(ServiceProvider.getInstance().sharedPrefsService);
          return StreamBuilder(
            stream: settingsBloc.isFirstVisit,
            builder: (contest, snapshot) {
              bool? isFirstVisit = snapshot.data as bool?;
              print('isFirstVisit ${isFirstVisit}');
              if (isFirstVisit == null) return const LoadingPage();
              if (isFirstVisit) {
                return const IntroPage();
              }
              return StreamBuilder(
                stream: settingsBloc.activeLocation,
                builder: (context, snapshot) {
                  Location? location = snapshot.data as Location?;
                  print('location ${location}');
                  if (location == null) {
                    return const LoadingPage();
                  }
                  return HomePage(HomePageArguments(location));
                },
              );
            },
          );
        }
        return const LoadingPage();
      },
      future: future,
    );
  }
}
