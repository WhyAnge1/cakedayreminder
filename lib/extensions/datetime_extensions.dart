extension DateTimeExtension on DateTime {
  bool isToday() {
    final today = DateTime.now();
    return month == today.month && day == today.day;
  }

  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return month == tomorrow.month && day == tomorrow.day;
  }

  bool isInSevenDays() {
    final now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final endOfWeek = now.add(const Duration(days: 6));

    return (this == now || isAfter(now)) &&
        (this == endOfWeek || isBefore(endOfWeek));
  }
}
