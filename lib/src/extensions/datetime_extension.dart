/*
 * ---------------------------
 * File : datetime_extension.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime? other) {
    return other == null
        ? false
        : year == other.year && month == other.month && day == other.day;
  }

  bool isAfterOnlyDate(DateTime other) {
    DateTime thisDate = copyWith(year: year, month: month, day: day);
    DateTime otherDate =
        copyWith(year: other.year, month: other.month, day: other.day);
    return thisDate.isAfter(otherDate);
  }

  int compareToOnlyDate(DateTime other) {
    DateTime thisDate = copyWith(year: year, month: month, day: day);
    DateTime otherDate =
        copyWith(year: other.year, month: other.month, day: other.day);
    return thisDate.compareTo(otherDate);
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
