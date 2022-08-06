import 'package:client/pages/home_page.dart';
import 'package:client/pages/loading_page.dart';
import 'package:flutter/widgets.dart';

class InitPage extends StatelessWidget {
  final Future<void> future;

  const InitPage({Key? key, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const HomePage();
        }
        return const LoadingPage();
      },
      future: future,
    );
  }
}
