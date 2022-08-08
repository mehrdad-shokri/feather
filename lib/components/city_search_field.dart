import 'package:client/models/location.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SearchField extends StatelessWidget {
  final Function onCityByLocationRequest;
  final Function(String query) onSearchCity;
  final Stream<List<Location>> cities;

  const SearchField(
      {Key? key,
      required this.onCityByLocationRequest,
      required this.onSearchCity,
      required this.cities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).barBackgroundColor,
          border: const Border(
              bottom: BorderSide(
                  color: CupertinoColors.lightBackgroundGray, width: 1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: PlatformWidget(
              cupertino: (_, __) => const CupertinoSearchTextField(
                placeholder: 'Search',
              ),
              material: (_, __) => TextField(
                expands: true,
                textInputAction: TextInputAction.search,
              ),
            )),
            PlatformIconButton(
              padding: EdgeInsets.zero,
              cupertino: (_, __) => CupertinoIconButtonData(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minSize: Constants.ICON_MEDIUM_SIZE),
              icon: Icon(
                Feather.my_location,
                color: Constants.PRIMARY_COLOR,
                size: Constants.ICON_MEDIUM_SIZE,
              ),
              onPressed: () {
                onCityByLocationRequest();
              },
            )
          ],
        ));
  }
}
