import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NextDaysPage extends StatelessWidget {
  const NextDaysPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('7 Days'),
      ),
      body: Column(),
    );
  }
}
