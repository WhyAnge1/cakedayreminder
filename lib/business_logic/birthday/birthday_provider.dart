import 'dart:io';

import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/constants/database_constants.dart';
import 'package:cakeday_reminder/business_logic/database/database.dart';
import 'package:cakeday_reminder/business_logic/import/import_service.dart';
import 'package:cakeday_reminder/business_logic/notifications/notification_service.dart';
import 'package:cakeday_reminder/main.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BirthdayProvider extends ChangeNotifier {
  final _importService = getIt.get<ImportService>();
  final _notificationService = getIt.get<NotificationService>();

  Map<DateTime, List<BirthdayModel>> birthdayList = {};

  Future addBirthday(BirthdayModel birthday) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    await database.birthdayDao.insertModel(birthday);
    await database.close();

    await _removeOldNotification(birthday.currentYearBirthdayDate);

    await refreshBirthdays();

    await _setupNewNotification(birthday.currentYearBirthdayDate);
  }

  Future removeBirthday(BirthdayModel birthday) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    await database.birthdayDao.deleteModel(birthday);
    await database.close();

    await _removeOldNotification(birthday.currentYearBirthdayDate);

    await refreshBirthdays();

    await _setupNewNotification(birthday.currentYearBirthdayDate);
  }

  Future updateBirthday(BirthdayModel birthday) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    await database.birthdayDao.updateModel(birthday);
    await database.close();

    await _removeOldNotification(birthday.currentYearBirthdayDate);

    await refreshBirthdays();

    await _setupNewNotification(birthday.currentYearBirthdayDate);
  }

  Future refreshBirthdays() async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    final allBirthdays = await database.birthdayDao.getAll();
    await database.close();

    if (allBirthdays.isNotEmpty) {
      allBirthdays.sort((a, b) {
        final monthComparison =
            a.birthdayDate.month.compareTo(b.birthdayDate.month);
        if (monthComparison != 0) {
          return monthComparison;
        }
        return a.birthdayDate.day.compareTo(b.birthdayDate.day);
      });

      final firstBirthday = allBirthdays.firstWhere((e) =>
          e.birthdayDate.month >= DateTime.now().month &&
          e.birthdayDate.day >= DateTime.now().day);
      final birthdaysAfterToday = allBirthdays.sublist(
          allBirthdays.indexOf(firstBirthday), allBirthdays.length);
      final birthdaysBeforeToday =
          allBirthdays.sublist(0, allBirthdays.indexOf(firstBirthday));
      final combinedbirthdays = birthdaysAfterToday + birthdaysBeforeToday;

      birthdayList = groupBy(combinedbirthdays,
          (BirthdayModel model) => model.currentYearBirthdayDate);
    } else {
      birthdayList = {};
    }

    notifyListeners();
  }

  Future<bool> importBirthdaysFromFile(String filePath) async {
    var importedBirthdays =
        await _importService.importBirthdaysFromExel(File(filePath));

    if (importedBirthdays.isNotEmpty) {
      final database = await $FloorAppDatabase
          .databaseBuilder(DataBaseConstants.name)
          .build();
      await database.birthdayDao.insertItems(importedBirthdays);
      await database.close();

      for (final birthday in importedBirthdays) {
        await _removeOldNotification(birthday.currentYearBirthdayDate);
      }

      refreshBirthdays();

      for (final birthday in importedBirthdays) {
        await _setupNewNotification(birthday.currentYearBirthdayDate);
      }

      return true;
    } else {
      return false;
    }
  }

  Future _setupNewNotification(DateTime birthdayListKey) async {
    if (birthdayList.containsKey(birthdayListKey) &&
        birthdayList[birthdayListKey]!.isNotEmpty) {
      final birthdaysThisDay = birthdayList[birthdayListKey]!;
      final hasMultipleBirthdays = birthdaysThisDay.length > 1;

      final year =
          birthdaysThisDay.first.currentYearBirthdayDate.isAfter(DateTime.now())
              ? DateTime.now().year
              : DateTime.now().year + 1;
      final notificationDate = DateTime(
          year,
          birthdaysThisDay.first.birthdayDate.month,
          birthdaysThisDay.first.birthdayDate.day,
          9,
          0,
          0);

      var notificationId =
          birthdaysThisDay.fold<int>(0, (sum, model) => sum + model.id!);
      var notificationTitle =
          'Don\'t miss todays ${hasMultipleBirthdays ? ('${birthdaysThisDay.length} cakedays') : 'cakeday'}!';
      var notificationBody =
          '${birthdaysThisDay.map((e) => e.personName).join(", ")} ${hasMultipleBirthdays ? 'are' : 'is'} celebrating today!';

      await _notificationService.scheduleNotification(
        notificationId,
        notificationTitle,
        notificationBody,
        notificationDate,
      );
    }
  }

  Future _removeOldNotification(DateTime birthdayListKey) async {
    if (birthdayList.containsKey(birthdayListKey) &&
        birthdayList[birthdayListKey]!.isNotEmpty) {
      final birthdaysThisDay = birthdayList[birthdayListKey]!;
      var notificationId =
          birthdaysThisDay.fold<int>(0, (sum, model) => sum + model.id!);

      await _notificationService.cancelNotification(notificationId);
    }
  }
}
