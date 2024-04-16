import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:cakeday_reminder/business_logic/notifications/notification_service.dart';
import 'package:cakeday_reminder/main.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final _notificationService = getIt.get<NotificationService>();
  final _birthdayService = getIt.get<BirthdayService>();

  bool isReloadingNotifications = false;

  Future reloadNotifications() async {
    isReloadingNotifications = true;
    notifyListeners();

    _notificationService.cancelAllNotifications();

    final groupedBirthdays = await _birthdayService.getGroupedBirthdays();

    for (final date in groupedBirthdays.keys) {
      await _birthdayService.setupNewNotificationForBirthdayByDate(
          date, groupedBirthdays[date]!);
    }

    isReloadingNotifications = false;
    notifyListeners();
  }
}
