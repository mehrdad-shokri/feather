import 'package:client/utils/hex_color.dart';
import 'package:flutter/widgets.dart';

class BottomSheetScrollIndicator extends StatelessWidget {
  const BottomSheetScrollIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 3,
      margin: const EdgeInsets.only(bottom: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: HexColor.fromHex('#cccccc')),
    );
  }
}
