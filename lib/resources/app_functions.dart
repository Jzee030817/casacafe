import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppFunctions {
  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}
