import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 320),
            const SizedBox(
              height: 16,
            ),
            PlatformCircularProgressIndicator(
              cupertino: (_, __) => CupertinoProgressIndicatorData(radius: 16),
              material: (_, __) => MaterialProgressIndicatorData(),
            )
          ],
        ),
      ),
    );
  }
}
