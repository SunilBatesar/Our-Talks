import 'package:flutter/material.dart';

class DatetimePars {
  static String getFormatedTime(BuildContext context, String time) {
    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMsgTime(
      {required BuildContext context,
      required String time,
      bool seeYear = false}) {
    final sendTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    final nowTime = DateTime.now();

    if (nowTime.day == sendTime.day &&
        nowTime.month == sendTime.month &&
        nowTime.year == sendTime.year) {
      return TimeOfDay.fromDateTime(sendTime).format(context);
    } else {
      return seeYear
          ? "${sendTime.day} ${_getMonthName(sendTime)} ${sendTime.year}"
          : "${sendTime.day} ${_getMonthName(sendTime)}";
    }
  }

  static String _getMonthName(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        throw ArgumentError('Invalid month: $date. Must be between 1 and 12.');
    }
  }

  // ****
  static String getLastActiveTime(BuildContext context, String lastActive) {
    final i = int.tryParse(lastActive) ?? -1;
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return "Last seen today at $formattedTime";
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen yesterday at $formattedTime";
    }
    String month = _getMonthName(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }
}
