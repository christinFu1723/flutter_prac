class TimeUtil {
  static String DateTime2YMD(DateTime date) {
    String month = date.month >= 10 ? date.month.toString() : '0${date.month}';

    String day = date.day >= 10 ? date.day.toString() : '0${date.month}';

    return '${date.year}-$month-$day';
  }
}
