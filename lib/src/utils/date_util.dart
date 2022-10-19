/*
 * ---------------------------
 * File : date_util.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateUtil {
  /// date with readable month name
  ///[nMonthFDate] = 'dd MMMM yyyy'
  static const String nMonthFDate = 'dd MMMM yyyy';

  /// date with readable month name and time
  ///[nMonthFDateTime] = 'dd MMMM yyyy HH:mm'
  static const String nMonthFDateTime = 'dd MMMM yyyy HH:mm';

  /// date with readable month name only
  ///[nMonth]= 'MMMM'
  static const String nMonth = 'MMMM';

  /// time for 24 without seconds
  ///[time24]= 'HH:mm'
  static const String time24 = 'HH:mm';

  /// time for 24
  ///[fTime24]= 'HH:mm:ss'
  static const String fTime24 = 'HH:mm:ss';

  /// database dateTime format
  /// [dbDateTime] =  "yyyy-MM-dd HH:mm:ss"
  static const String dbDateTime = "yyyy-MM-dd HH:mm:ss";

  static DateTime? getDateFromString(
      {required String dateString, String? dateFormat = dbDateTime}) {
    return DateFormat(dateFormat).parse(dateString);
  }

  static DateTime? utcDateTimeToLocal(
    String? stringDateTime, {
    String? dateFormat = "yyyy-MM-ddTHH:mm:ss",
    bool utc = true,
  }) {
    return stringDateTime == null
        ? null
        : DateFormat(dateFormat).parse(stringDateTime, utc).toLocal();
  }

  ///time must be valid format
  ///[time] = [fTime24]
  static DateTime? utcTimeToLocalDateTime(String time, {DateTime? date}) {
    DateTime now = date ?? DateTime.now();
    String dateX = "${now.year}-${now.month}-${now.day} $time";

    return DateUtil.utcDateTimeToLocal(dateX, dateFormat: DateUtil.dbDateTime);
  }

  static String getStringDate(DateTime? date, {String format = "dd.MM.yyyy"}) {
    if (date == null) {
      return "";
    }
    initializeDateFormatting();
    return DateFormat(format).format(date);
  }

  static DateTime mostRecentSunday(DateTime date) =>
      DateTime(date.year, date.month, date.day - date.weekday % 7);

  static DateTime mostRecentMonday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  static DateTime mostRecentWeekday(DateTime date, int weekday) =>
      DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);

  static String localToUtcString(DateTime? date) {
    if (date == null) {
      return "";
    }

    DateTime newDate =
        DateTime(date.year, date.month, date.day, date.hour, date.minute);

    return newDate.toUtc().toIso8601String();
  }
}

//accepted formats
// "2012-02-27 13:27:00"
// "2012-02-27 13:27:00.123456789z"
// "2012-02-27 13:27:00,123456789z"
// "20120227 13:27:00"
// "20120227T132700"
// "20120227"
// "+20120227"
// "2012-02-27T14Z"
// "2012-02-27T14+00:00"
// "-123450101 00:00:00 Z": in the year -12345.
// "2002-02-27T14:00:00-0500": Same as "2002-02-27T19:00:00Z"
// print(new DateFormat('').parse('')); // 1970-01-01 00:00:00.000
// print(new DateFormat('MM').parse('02')); // 1970-02-01 00:00:00.000
// print(new DateFormat('yyyy').parse('2020')); // 2020-01-01 00:00:00.000
// print(new DateFormat('MM/yyyy').parse('01/2020')); // 2020-01-01 00:00:00.000
// print(new DateFormat('MMM yyyy').parse('Feb 2020')); // 2020-02-01 00:00:00.000
// print(new DateFormat('MMMM yyyy').parse('March 2020')); // 2020-03-01 00:00:00.000
// print(new DateFormat('yyyy/MM/dd').parse('2020/04/03')); // 2020-04-03 00:00:00.000
// print(new DateFormat('yyyy/MM/dd HH:mm:ss').parse('2020/04/03 17:03:02')); // 2020-04-03 17:03:02.000
// print(new DateFormat('EEEE dd MMMM yyyy HH:mm:ss \'GMT\'').parse('Wednesday 28 October 2020 01:02:03 GMT')); // 2020-10-28 01:02:03.000
// print(new DateFormat('EEE d/LLLL/yyyy hh:mm:ss G').parse('Wed 10/January/2020 15:02:03 BC')); // 2020-01-10 15:02:03.000
// print(new DateFormat('yyyyy.MMMM.dd GGG hh:mm aaa').parse('02020.July.10 AD 11:09 PM')); // 2020-07-10 23:09:00.000
