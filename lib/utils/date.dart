import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

int diffInMinutes(TimeOfDay source, TimeOfDay dest) {
  return (dest.hour * 60 + dest.minute) - (source.hour * 60 + source.minute);
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

String formatTime(DateTime date) {
  String timeFormat = DateFormat('hh:mm a').format(date);
  if (timeFormat.startsWith('0')) {
    return timeFormat.substring(
      1,
    );
  }
  return timeFormat;
}
