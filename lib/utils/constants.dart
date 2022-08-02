// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static final Color PRIMARY_COLOR = Colors.blue.shade300;
  static final Color PRIMARY_COLOR_DARK = Colors.blue.shade500;
  static final Color PRIMARY_COLOR_LIGHT = Colors.blue.shade200;

  static final Color SECONDARY_COLOR = Colors.pink.shade300;
  static final Color SECONDARY_COLOR_DARK = Colors.pink.shade400;
  static final Color SECONDARY_COLOR_LIGHT = Colors.pink.shade200;

  static const Color ERROR_COLOR = Color.fromRGBO(237, 46, 126, 1);
  static const Color ERROR_COLOR_DARK = Color.fromRGBO(195, 0, 82, 1);
  static const Color ERROR_COLOR_LIGHT = Color.fromRGBO(255, 242, 247, 1);
  static const Color SUCCESS_COLOR = Color.fromRGBO(0, 186, 136, 1);
  static const Color SUCCESS_COLOR_DARK = Color.fromRGBO(0, 186, 136, 1);
  static const Color WARNING_COLOR = Color.fromRGBO(244, 183, 64, 1);
  static const Color WARNING_COLOR_LIGHT = Color.fromRGBO(255, 240, 212, 1);
  static const Color WARNING_COLOR_DARK = Color.fromRGBO(162, 107, 0, 1);

  static const Color TEXT_BLACK_COLOR = Color.fromRGBO(20, 20, 43, 1);
  static const Color TEXT_BLACK_COLOR_DARK = Color.fromRGBO(235, 235, 212, 1.0);
  static const Color TEXT_BODY_COLOR = Color.fromRGBO(78, 75, 102, 1.0);
  static const Color TEXT_BODY_COLOR_DARK = Color.fromRGBO(203, 203, 203, 1);
  static const Color TEXT_LABEL_COLOR = Color.fromRGBO(110, 113, 145, 1);
  static const Color TEXT_LABEL_COLOR_DARK = Color.fromRGBO(145, 142, 110, 1.0);
  static const Color PLACEHOLDER_COLOR = Color.fromRGBO(160, 163, 189, 1);
  static const Color PLACEHOLDER_COLOR_DARK = Color.fromRGBO(95, 92, 66, 1.0);
  static const Color LINE_COLOR = Color.fromRGBO(214, 216, 231, 1);
  static const Color LINE_COLOR_DARK = Color.fromRGBO(41, 39, 24, 1.0);

  static const Color BACKGROUND_COLOR = Color.fromRGBO(239, 243, 247, 1.0);
  static const Color BACKGROUND_COLOR_DARK = Color.fromRGBO(16, 12, 8, 1.0);
  static const Color INPUT_BACKGROUND_COLOR = Color.fromRGBO(239, 240, 246, 1);
  static const Color INPUT_BACKGROUND_COLOR_DARK =
      Color.fromRGBO(16, 15, 9, 1.0);

  static const double CAPTION_FONT_SIZE = 12;
  static const double S2_FONT_SIZE = 14;
  static const double S1_FONT_SIZE = 16;
  static const double H6_FONT_SIZE = 18;
  static const double H5_FONT_SIZE = 21;
  static const double H4_FONT_SIZE = 24;
  static const double H3_FONT_SIZE = 28;
  static const double H2_FONT_SIZE = 31;
  static const double H1_FONT_SIZE = 34;
  static const FontWeight REGULAR_FONT_WEIGHT = FontWeight.w400;
  static const FontWeight MEDIUM_FONT_WEIGHT = FontWeight.w500;
  static const FontWeight DEMI_BOLD_FONT_WEIGHT = FontWeight.w600;
  static const FontWeight BOLD_FONT_WEIGHT = FontWeight.bold;
  static const String APPLICATION_DEFAULT_FONT = 'Roboto';
  static const List<String> APPLICATION_FALLBACK_FONTS = ['sans-serif'];
  static const EdgeInsets PAGE_PADDING = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets CARD_INNER_PADDING =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static final ShapeBorder CARD_SHAPE =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
}
