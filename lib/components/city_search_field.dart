import 'package:client/models/location.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SearchField extends StatelessWidget {
  final Function onGetCurrentPosition;
  final Function(String? query) onSearchCity;
  final Function(String? query) onAutoCompleteCity;
  final Stream<List<Location>> cities;
  final Stream<bool> loadingCurrentCity;

  const SearchField(
      {Key? key,
      required this.onGetCurrentPosition,
      required this.onSearchCity,
      required this.cities,
      required this.loadingCurrentCity,
      required this.onAutoCompleteCity})
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
              cupertino: (_, __) => CupertinoSearchTextField(
                placeholder: 'Search',
                onChanged: onAutoCompleteCity,
                onSubmitted: onSearchCity,
              ),
              material: (_, __) => TextField(
                expands: true,
                textInputAction: TextInputAction.search,
              ),
            )),
            StreamBuilder(
              stream: loadingCurrentCity,
              builder: (context, snapshot) {
                bool? loading = snapshot.data as bool?;
                if (loading != null && loading) {
                  return PlatformCircularProgressIndicator();
                }
                return PlatformIconButton(
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
                    onGetCurrentPosition();
                  },
                );
              },
            )
          ],
        ));
  }
}
