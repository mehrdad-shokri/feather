import 'package:client/models/location.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchField extends StatelessWidget {
  final Function onGetCurrentPosition;
  final Function(String? query) onSearchCity;
  final Function(String? query) onAutoCompleteCity;
  final Stream<List<Location>> cities;
  final Stream<bool> loadingCurrentPosition;
  final AppLocalizations t;

  const SearchField(
      {Key? key,
      required this.onGetCurrentPosition,
      required this.onSearchCity,
      required this.cities,
      required this.loadingCurrentPosition,
      required this.onAutoCompleteCity,
      required this.t})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: isCupertino(context)
            ? const EdgeInsets.only(right: 16, bottom: 8)
            : const EdgeInsets.only(right: 16, bottom: 16, left: 16),
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
                placeholder: t.searchLabel,
                style: TextStyle(
                    color: textColor(context),
                    fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                    fontSize: Constants.S1_FONT_SIZE),
                onChanged: onAutoCompleteCity,
                onSubmitted: onSearchCity,
                autocorrect: false,
              ),
              material: (_, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: inputBackgroundColor(context)),
                child: TextField(
                  expands: false,
                  minLines: null,
                  maxLines: null,
                  style: TextStyle(
                      color: textColor(context),
                      fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                      fontSize: Constants.S1_FONT_SIZE),
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: appbarBackIconColor(context),
                      size: Constants.ICON_MEDIUM_SIZE,
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                    ),
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                        color: placeholderColor(context),
                        fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                        fontSize: Constants.S1_FONT_SIZE),
                    hintText: t.searchLabel,
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: onSearchCity,
                  onChanged: onAutoCompleteCity,
                  autocorrect: false,
                ),
              ),
            )),
            StreamBuilder(
              stream: loadingCurrentPosition,
              builder: (context, snapshot) {
                bool? loading = snapshot.data as bool?;
                return Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(left: 4),
                  clipBehavior: Clip.none,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    alignment: Alignment.center,
                    crossFadeState: (loading != null && loading)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    secondChild: Container(
                      width: Constants.ICON_MEDIUM_SIZE,
                      height: Constants.ICON_MEDIUM_SIZE,
                      padding: const EdgeInsets.all(4),
                      child: PlatformCircularProgressIndicator(
                        material: (_, __) => MaterialProgressIndicatorData(
                          color: Constants.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    firstChild: PlatformIconButton(
                      cupertino: (_, __) => CupertinoIconButtonData(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minSize: Constants.ICON_MEDIUM_SIZE),
                      material: (_, __) => MaterialIconButtonData(
                        padding: EdgeInsets.zero,
                      ),
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
