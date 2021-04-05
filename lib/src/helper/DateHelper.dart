import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///  await initializeDateFormatting('id_ID', null);

class DateHelper {
  static const date_month_year_hours_minute = "dd MMMM yyyy, HH:mm";
  static const date_month_year_hours_minute2 = "dd/MM/yyyy HH:mm";
  static const date_month_year_hours_minute3 = "dd/MM/yyyy . HH:mm";
  static const date_month = "dd MMM";
  static const date_hours_minute = "HH:mm";
  static const date_month_year = "yyyy-MM-dd";
  static const date_month_year2 = "dd/MM/yyyy";
  static const date_month_year3 = "dd MMM yyyy";
  static const date_month_year4 = "dd-MM-yyyy";
  static const date_month_year5 = "MMMM yyyy";
  static const date_month_year6 = "yyyyMM";
  static const date_month_year7 = "MM yyyy";
  static const date_month_year8 = "yyyy-M-d";
  static const date_month_year9 = "dd MMMM yyyy";

  static const date_default_db = "yyyy-MM-dd HH:mm:ss";
  static const date_default_db2 = "yyyy-MM-dd";
  static const date_default_db3 = "yyyy-MM-ddTHH:mm:ssZ";

  static const date_only_year = "yyyy";
  static const date_only_month = "MM";
  static const date_only_date = "dd";

  static const date_only_month_long = "MMMM";

  static const date_db_only_month = "M";

  bool isExpired(int dateInMilliSecond) {
    var now = DateTime.now();
    var diff =
        now.difference(DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond)) *
            -1;

    if (diff.inSeconds > 0) return false;
    return true;
  }

  DateTime getPastMonth() {
    var date = DateTime.now();
    var prevMonth = new DateTime(date.year, date.month - 1, date.day);
    return prevMonth;
  }

  DateTime convertToDateTime(String date,
      {String oldFormat = date_month_year}) {
    return DateTime(
        int.parse(
            convertFormat(date, oldFormat: oldFormat, format: date_only_year)),
        int.parse(
            convertFormat(date, oldFormat: oldFormat, format: date_only_month)),
        int.parse(
            convertFormat(date, oldFormat: oldFormat, format: date_only_date)));
  }

  String convertFormat(String date,
      {String oldFormat = date_default_db,
      String format = date_month_year_hours_minute,
      String locale = "id_ID"}) {
    if (date == null)
      return "";
    else if (date.isEmpty) return "";
    DateFormat dateFormat = DateFormat(oldFormat);
    DateTime dateTime = dateFormat.parse(date);
    DateFormat newFormat = DateFormat(format, locale);
    return newFormat.format(dateTime);
  }

  String convertFormatFromInt(int dateInMilliSecond,
      {String format = date_month_year_hours_minute, String locale = "id_ID"}) {
    if (dateInMilliSecond == null) return "";
    DateTime time = DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond);
    DateFormat newFormat = DateFormat(format, locale);
    return newFormat.format(time);
  }

  String convertFormatFromDateTime(DateTime date,
      {String format = date_month_year_hours_minute, String locale = "id_ID"}) {
    if (date == null) return "";
    DateFormat newFormat = DateFormat(format, locale);
    return newFormat.format(date);
  }

  int convertDateFromSecondToMilliSecond(int dateInMilliSecond) {
    return DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond)
        .millisecondsSinceEpoch;
  }

  String getDifferentDate(int dateInMilliSecond) {
    String aMoment = "Baru saja";
    String secondAgo = " detik yang lalu";
    String minuteAgo = " menit yang lalu";
    String hourAgo = " jam yang lalu";
    String dayAgo = " hari yang lalu";
    final formatTime = new DateFormat('dd MM yyyy at hh:mm');

    var now = DateTime.now();
    var diff =
        now.difference(DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond));

    var result = "";
    if (diff.inDays != 0) {
      if (diff.inDays > 28) {
        result = formatTime
            .format(new DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond));
      } else {
        result = diff.inDays.toString() + dayAgo;
      }
    } else if (diff.inHours != 0) {
      result = diff.inHours.toString() + hourAgo;
    } else if (diff.inMinutes != 0) {
      result = diff.inMinutes.toString() + minuteAgo;
    } else if (diff.inSeconds != 0) {
      result = diff.inSeconds.toString() + secondAgo;
    } else {
      result = aMoment;
    }

    return result;
  }

  String getDateLeft(int dateInMilliSecond) {
    String minuteAgo = " menit lagi";
    String hourAgo = " jam lagi";
    String dayAgo = " hari lagi";

    var now = DateTime.now();
    var diff =
        now.difference(DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond)) *
            -1;

    var result = "";
    if (diff.inDays > 0) {
      result = diff.inDays.toString() + dayAgo;
    } else if (diff.inHours > 0) {
      result = diff.inHours.toString() + hourAgo;
    } else if (diff.inMinutes > 0) {
      result = diff.inMinutes.toString() + minuteAgo;
    } else if (diff.inSeconds > 0) {
      result = "Akan ditutup";
    } else {
      result = "Ditutup";
    }

    return result;
  }

  String getDateLeftInNumber(int dateInMilliSecond) {
    var now = DateTime.now();
    var diff =
        now.difference(DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond)) *
            -1;

    var result = "";
    if (diff.inHours > 0) {
      result += diff.inHours.toString() + " : ";
    } else {
      result += "00 : ";
    }

    if (diff.inMinutes > 0) {
      result += diff.inMinutes.toString() + " : ";
    } else {
      result += "00 : ";
    }

    if (diff.inSeconds > 0) {
      result += diff.inSeconds.toString();
    } else {
      result += "00";
    }

    return result;
  }

  DateTime convertIntToDatetime(int dateInMilliSecond) {
    return DateTime.fromMillisecondsSinceEpoch(dateInMilliSecond);
  }

  ///isbefore not work for today
  bool isBeforeOrSameDay(DateTime firstTime, DateTime endTime) {
    var cond = false;
    if (firstTime.isBefore(endTime)) cond = true;
    if (firstTime.day == endTime.day &&
        firstTime.month == endTime.month &&
        firstTime.year == endTime.year) cond = true;
    return cond;
  }

  bool isAfterOrSameDay(DateTime firstTime, DateTime endTime) {
    var cond = false;
    if (endTime.isAfter(firstTime)) cond = true;
    if (firstTime.day == endTime.day &&
        firstTime.month == endTime.month &&
        firstTime.year == endTime.year) cond = true;
    return cond;
  }

  bool isSameDay(DateTime firstTime, DateTime endTime) {
    var cond = false;
    if (firstTime.day == endTime.day &&
        firstTime.month == endTime.month &&
        firstTime.year == endTime.year) cond = true;
    return cond;
  }

  String convertTimeOfDayToString(TimeOfDay timeOfDay) {
    var hour = "";
    if (timeOfDay.hour > 9)
      hour = "${timeOfDay.hour}";
    else
      hour = "0${timeOfDay.hour}";

    var minute = "";
    if (timeOfDay.minute > 9)
      minute = "${timeOfDay.minute}";
    else
      minute = "0${timeOfDay.minute}";
    return "$hour:$minute:00";
  }

  /// "10:10:10"
  TimeOfDay convertStringToTimeOfDay(String time) {
    var splitTime = time.split(":");

    int hour;
    if (splitTime[0].startsWith("0"))
      hour = int.parse(splitTime[0].substring(1));
    else
      hour = int.parse(splitTime[0]);

    int minute;
    if (splitTime[1].startsWith("0"))
      minute = int.parse(splitTime[1].substring(1));
    else
      minute = int.parse(splitTime[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
