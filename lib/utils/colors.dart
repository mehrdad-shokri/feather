import 'dart:io';

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

Color backgroundColor(BuildContext context) {
  return isDark(context)
      ? Constants.BACKGROUND_COLOR_DARK
      : Constants.BACKGROUND_COLOR;
}

Color placeholderColor(BuildContext context) {
  return isDark(context)
      ? Constants.PLACEHOLDER_COLOR_DARK
      : Constants.PLACEHOLDER_COLOR;
}

Color appbarBackIconColor(BuildContext context) {
  return isDark(context) ? Colors.white : Colors.black;
}

bool isDark(BuildContext context) {
  if (isCupertino(context)) {
    return CupertinoTheme.of(context).brightness == Brightness.dark;
  }
  return Theme.of(context).brightness == Brightness.dark;
}

Color cardColor(BuildContext context) {
  return isDark(context) ? Colors.grey.shade800 : Colors.grey.shade100;
}
