import 'package:client/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Color headingColor(BuildContext context) {
  return isDark(context)
      ? Constants.TEXT_BLACK_COLOR_DARK
      : Constants.TEXT_BLACK_COLOR;
}

Color textColor(BuildContext context) {
  return isDark(context)
      ? Constants.TEXT_BODY_COLOR_DARK
      : Constants.TEXT_BODY_COLOR;
}

Color secondaryTextColor(BuildContext context) {
  return isDark(context)
      ? Constants.TEXT_LABEL_COLOR_DARK
      : Constants.TEXT_LABEL_COLOR;
}

Color dividerColor(BuildContext context) {
  return isDark(context) ? Constants.LINE_COLOR_DARK : Constants.LINE_COLOR;
}

Color borderColor(BuildContext context) {
  return isDark(context) ? Constants.LINE_COLOR : Constants.LINE_COLOR_DARK;
}

Color backgroundColor(BuildContext context) {
  return isDark(context)
      ? Constants.BACKGROUND_COLOR_DARK
      : Constants.BACKGROUND_COLOR;
}

Color modalSheetBackgroundColor(BuildContext context) {
  return isDark(context)
      ? Constants.BACKGROUND_COLOR_MODAL_SHEET_DARK
      : Constants.BACKGROUND_COLOR_MODAL_SHEET;
}

Color placeholderColor(BuildContext context) {
  return isDark(context)
      ? Constants.PLACEHOLDER_COLOR_DARK
      : Constants.PLACEHOLDER_COLOR;
}

Color appbarBackIconColor(BuildContext context) {
  return isDark(context)
      ? const Color.fromRGBO(148, 148, 158, 1)
      : const Color.fromRGBO(115, 115, 119, 1);
}

bool isDark(BuildContext context) {
  if (isCupertino(context)) {
    return CupertinoTheme.of(context).brightness == Brightness.dark;
  }
  return Theme.of(context).brightness == Brightness.dark;
}

Color cardColor(BuildContext context) {
  return isDark(context) ? Constants.CARD_COLOR_DARK : Constants.CARD_COLOR;
}

Color inputBackgroundColor(BuildContext context) {
  return isDark(context)
      ? Constants.INPUT_BACKGROUND_COLOR_DARK
      : Constants.INPUT_BACKGROUND_COLOR;
}

Color barBackgroundColor(BuildContext context) {
  return isDark(context)
      ? Constants.BAR_BACKGROUND_COLOR_DARK
      : Constants.BAR_BACKGROUND_COLOR;
}
