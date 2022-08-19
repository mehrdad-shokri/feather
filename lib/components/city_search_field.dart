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
  final Stream<bool> loadingCurrentPosition;

  const SearchField(
      {Key? key,
      required this.onGetCurrentPosition,
      required this.onSearchCity,
      required this.cities,
      required this.loadingCurrentPosition,
      required this.onAutoCompleteCity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: isCupertino(context)
              ? CupertinoTheme.of(context).barBackgroundColor
              : Theme.of(context).appBarTheme.backgroundColor,
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
                autocorrect: false,
              ),
              material: (_, __) => TextField(
                expands: true,
                textInputAction: TextInputAction.search,
                onSubmitted: onSearchCity,
                onChanged: onAutoCompleteCity,
              ),
            )),
            StreamBuilder(
              stream: loadingCurrentPosition,
              builder: (context, snapshot) {
                bool? loading = snapshot.data as bool?;
                return Container(
                  width: 32,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    alignment: Alignment.center,
                    crossFadeState: (loading != null && loading)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    secondChild: PlatformCircularProgressIndicator(),
                    firstChild: PlatformIconButton(
                      padding: EdgeInsets.zero,
                      cupertino: (_, __) => CupertinoIconButtonData(
                          alignment: Alignment.center,
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
                    ),
                  ),
                );
              },
            )
          ],
        ));
  }
}
