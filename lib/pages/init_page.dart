import 'package:client/pages/home_page.dart';
import 'package:client/pages/intro_page.dart';
import 'package:client/pages/loading_page.dart';
import 'package:client/rx/app_provider.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
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
              SettingsBloc(AppProvider.getInstance().sharedPrefsService);
          return StreamBuilder(
            stream: settingsBloc.isFirstVisit,
            builder: (contest, snapshot) {
              bool? isFirstVisit = snapshot.data as bool?;
              if (isFirstVisit != null && isFirstVisit) {
                return const IntroPage();
              }
              return const HomePage();
            },
          );
        }
        return const LoadingPage();
      },
      future: future,
    );
  }
}
