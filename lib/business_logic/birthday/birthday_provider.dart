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

  Future addBirthday(BirthdayModel newBirthday) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    var newModelId = await database.birthdayDao.insertModel(newBirthday);
    await database.close();

    await _setupNotification(newBirthday, newModelId);

    refreshBirthdays();
  }

  Future removeBirthday(BirthdayModel existBirthday) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    await database.birthdayDao.deleteModel(existBirthday);
    await database.close();

    _notificationService.cancelNotification(existBirthday.id!);

    refreshBirthdays();
  }

  Future updateBirthday(BirthdayModel existBirthday) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    var existModelId = await database.birthdayDao.updateModel(existBirthday);
    await database.close();

    _notificationService.cancelNotification(existBirthday.id!);
    await _setupNotification(existBirthday, existModelId);

    refreshBirthdays();
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
      var insertedBirthdaysId =
          await database.birthdayDao.insertItems(importedBirthdays);
      await database.close();

      for (int i = 0; i < importedBirthdays.length; i++) {
        await _setupNotification(importedBirthdays[i], insertedBirthdaysId[i]);
      }

      refreshBirthdays();

      return true;
    } else {
      return false;
    }
  }

  Future _setupNotification(BirthdayModel birthday, int id) async {
    final year = birthday.currentYearBirthdayDate.isAfter(DateTime.now())
        ? DateTime.now().year
        : DateTime.now().year + 1;
    final notificationDate = DateTime(
        year, birthday.birthdayDate.month, birthday.birthdayDate.day, 9, 0, 0);

    await _notificationService.scheduleNotification(
      id,
      'Don\'t miss todays cakeday!',
      '${birthday.personName} is celebrating today!',
      notificationDate,
    );
  }
}
