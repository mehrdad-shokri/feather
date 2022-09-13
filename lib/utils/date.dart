import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

DateTime zeroDateTime(DateTime source) {
  return DateTime(source.year, source.month, source.day);
}

bool isSameDay(DateTime? source, DateTime? destination) {
  if (source != null && destination != null) {
    DateTime sourceZero = zeroDateTime(source);
    DateTime destZero = zeroDateTime(destination);
    return sourceZero.difference(destZero).inDays == 0;
  }
  return false;
}

bool isAfterDate(DateTime? source, DateTime? destination) {
  if (source == null || destination == null) return false;
  DateTime sourceZero = zeroDateTime(source);
  DateTime destZero = zeroDateTime(destination);
  return sourceZero.difference(destZero).inDays > 0;
}

bool isBeforeDate(DateTime? source, DateTime? destination) {
  if (source == null || destination == null) return false;
  DateTime sourceZero = zeroDateTime(source);
  DateTime destZero = zeroDateTime(destination);
  return sourceZero.difference(destZero).inDays < 0;
}

bool isSameOrBeforeDate(DateTime? source, DateTime? destination) {
  if (source == null || destination == null) return false;
  DateTime sourceZero = zeroDateTime(source);
  DateTime destZero = zeroDateTime(destination);
  return sourceZero.difference(destZero).inDays <= 0;
}

bool isSameOrAfterDate(DateTime? source, DateTime? destination) {
  if (source == null || destination == null) return false;
  DateTime sourceZero = zeroDateTime(source);
  DateTime destZero = zeroDateTime(destination);
  return sourceZero.difference(destZero).inDays >= 0;
}

int diffInDays(DateTime source, DateTime dest) {
  return zeroDateTime(source).difference(zeroDateTime(dest)).inDays;
}

int diffInMinutes(DateTime source, DateTime dest) {
  return source.difference(dest).inMinutes;
}

bool isSameOrAfterTime(DateTime a, DateTime b) =>
    a.difference(b).inSeconds >= 0;

bool isSameOrBeforeTime(DateTime a, DateTime b) =>
    a.difference(b).inSeconds <= 0;

bool isNight(DateTime date, DateTime sunrise, DateTime sunset) =>
    isSameOrAfterTime(date, sunset) || isSameOrAfterTime(sunrise, date);

String formatDate(DateTime date, {String? format}) {
  if (format != null) {
    return DateFormat(format).format(date);
  }
  return DateFormat.MMMMEEEEd().format(date);
}

String formatDateRelatively(DateTime date, AppLocalizations t,
    {String? format}) {
  String formatted = formatDate(date, format: format);
  int diff = diffInDays(date, DateTime.now());
  if (diff == 0) {
    return '${t.today}, $formatted';
  } else if (diff == 1) {
    return '${t.tomorrow}, $formatted';
  } else {
    return '${formatDate(date, format: 'EEEE')}, $formatted';
  }
}

String formatTime(DateTime date) {
  String timeFormat = DateFormat('hh:mm a').format(date);
  if (timeFormat.startsWith('0')) {
    return timeFormat.substring(
      1,
    );
  }
  return timeFormat;
}
