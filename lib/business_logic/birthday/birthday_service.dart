import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/constants/app_constants.dart';
import 'package:cakeday_reminder/business_logic/database/database.dart';
import 'package:cakeday_reminder/business_logic/notifications/notification_service.dart';
import 'package:cakeday_reminder/extensions/datetime_extensions.dart';
import 'package:cakeday_reminder/main.dart';
import 'package:collection/collection.dart';

class BirthdayService {
  final _notificationService = getIt.get<NotificationService>();

  Future addBirthday(BirthdayModel birthday) async {
    final database = await $FloorAppDatabase
        .databaseBuilder(AppConstants.dataBaseName)
        .build();
    await database.birthdayDao.insertModel(birthday);
    await database.close();

    var thisDateBirthdays =
        await _getAllBirthdaysByDate(birthday.currentYearBirthdayDate);

    await setupNewNotificationForBirthdayByDate(
        birthday.currentYearBirthdayDate, thisDateBirthdays);
  }

  Future addBirthdays(List<BirthdayModel> birthdays) async {
    final database = await $FloorAppDatabase
        .databaseBuilder(AppConstants.dataBaseName)
        .build();
    await database.birthdayDao.insertItems(birthdays);
    await database.close();

    for (final date in birthdays.map((e) => e.currentYearBirthdayDate)) {
      final thisDateBirthdays = await _getAllBirthdaysByDate(date);

      await setupNewNotificationForBirthdayByDate(date, thisDateBirthdays);
    }
  }

  Future removeBirthday(BirthdayModel birthday) async {
    final database = await $FloorAppDatabase
        .databaseBuilder(AppConstants.dataBaseName)
        .build();
    await database.birthdayDao.deleteModel(birthday);
    await database.close();

    var thisDateBirthdays =
        await _getAllBirthdaysByDate(birthday.currentYearBirthdayDate);

    await setupNewNotificationForBirthdayByDate(
        birthday.currentYearBirthdayDate, thisDateBirthdays);
  }

  Future updateBirthday(BirthdayModel birthday) async {
    final database = await $FloorAppDatabase
        .databaseBuilder(AppConstants.dataBaseName)
        .build();
    await database.birthdayDao.updateModel(birthday);
    await database.close();

    var thisDateBirthdays =
        await _getAllBirthdaysByDate(birthday.currentYearBirthdayDate);

    await setupNewNotificationForBirthdayByDate(
        birthday.currentYearBirthdayDate, thisDateBirthdays);
  }

  Future<Map<DateTime, List<BirthdayModel>>> getGroupedBirthdays() async {
    final allBirthdays = await getAllBirthdays();

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
          e.currentYearBirthdayDate.isToday() ||
          e.currentYearBirthdayDate.isAfter(DateTime.now()));
      final birthdaysAfterToday = allBirthdays.sublist(
          allBirthdays.indexOf(firstBirthday), allBirthdays.length);
      final birthdaysBeforeToday =
          allBirthdays.sublist(0, allBirthdays.indexOf(firstBirthday));
      final combinedbirthdays = birthdaysAfterToday + birthdaysBeforeToday;

      return groupBy(combinedbirthdays,
          (BirthdayModel model) => model.currentYearBirthdayDate);
    } else {
      return {};
    }
  }

  Future<List<BirthdayModel>> getAllBirthdays() async {
    final database = await $FloorAppDatabase
        .databaseBuilder(AppConstants.dataBaseName)
        .build();
    final allBirthdays = await database.birthdayDao.getAll();
    await database.close();

    return allBirthdays;
  }

  Future<List<BirthdayModel>> _getAllBirthdaysByDate(DateTime date) async {
    final database = await $FloorAppDatabase
        .databaseBuilder(AppConstants.dataBaseName)
        .build();
    final allBirthdays = await database.birthdayDao.getAll();
    await database.close();

    return allBirthdays
        .where((e) => e.currentYearBirthdayDate == date)
        .toList();
  }

  Future setupNewNotificationForBirthdayByDate(
      DateTime birthdayDate, List<BirthdayModel> birthdaysThisDay) async {
    await _removeOldNotifications(birthdaysThisDay);

    if (birthdaysThisDay.isNotEmpty) {
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

      final notificationId =
          birthdaysThisDay.fold<int>(0, (sum, model) => sum + model.id!);
      final notificationTitle =
          'Don\'t miss todays ${hasMultipleBirthdays ? ('${birthdaysThisDay.length} cakedays') : 'cakeday'}!';
      final notificationBody =
          '${birthdaysThisDay.map((e) => e.personName).join(", ")} ${hasMultipleBirthdays ? 'are' : 'is'} celebrating today!';

      await _notificationService.scheduleMultipleNotifications(
        notificationId,
        notificationTitle,
        notificationBody,
        notificationDate,
        AppConstants.countOfYearsForNotifications,
      );
    }
  }

  Future _removeOldNotifications(List<BirthdayModel> birthdaysThisDay) async {
    if (birthdaysThisDay.isNotEmpty) {
      var notificationId =
          birthdaysThisDay.fold<int>(0, (sum, model) => sum + model.id!);

      await _notificationService.cancelMultipleNotifications(
        notificationId,
        AppConstants.countOfYearsForNotifications,
      );
    }
  }
}
