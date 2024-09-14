
// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerProvider with ChangeNotifier {
  static var _countdownDuration = const Duration(minutes: 10);
  Duration duration = const Duration();

  Timer? timer;
  bool countDown = true;
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];
  List weeks = [
    'sun',
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
  ];

  DateTime? defDate = DateTime.parse("0000-00-00 00:00:00");

  startTimer({required DateTime date, String? hours}) {
    // var parsedDate = DateTime.parse('$hours');

    var currenttime = DateTime.now();
    var currentHour = currenttime.hour;
    var currentMinutes = currenttime.minute;
    var currentSeconds = currenttime.second;
    // var cutoftime = date;
    // var cutoftimeHour = cutoftime.hour;
    // var cutoftimeMinutes = cutoftime.minute;
    // var cutoftimeSeconds = cutoftime.second;
    var hour = 22 - currentHour;
    var minutes = 60 - currentMinutes;
    var seconds = 60 - currentSeconds;

    //
    timerStatus();
    defDate = date;
    notifyListeners();
    _countdownDuration =
        Duration(hours: hour, minutes: minutes, seconds: seconds);
    reset();
    onTimer();
  }

  void reset() {
    if (countDown) {
      duration = _countdownDuration;
    } else {
      duration = const Duration();
    }
    notifyListeners();
  }

  void onTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      const addSeconds = 1;
      final seconds = duration.inSeconds - addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
      notifyListeners();
    });
  }

  //
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<bool> onWillPop() async {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      timer!.cancel();
    }

    // Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }

  int tomDate() {
    DateTime nDate = defDate!.add(const Duration(days: 0, hours: 0));
    return nDate.day;
  }

  String tomWeekDay() {
    String value = DateFormat.E().format(defDate!);
    return value;
  }

  timerStatus() {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      timer!.cancel();
    }
  }
}
