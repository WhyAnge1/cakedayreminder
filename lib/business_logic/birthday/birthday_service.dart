import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/constants/database_constants.dart';
import 'package:collection/collection.dart';

import '../database/database.dart';

class BirthdayService {
  Future<Map<DateTime, List<BirthdayModel>>> getAllBirthdays() async {
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
      final groupedBirthdays = groupBy(combinedbirthdays,
          (BirthdayModel model) => model.currentYearBirthdayDate);

      return groupedBirthdays;
    }

    return {};
  }

  Future<List<BirthdayModel>> getTodayBirthdays() async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    final allBirthdays = await database.birthdayDao.getAll();

    await database.close();

    return allBirthdays
        .where((e) =>
            e.birthdayDate.month == DateTime.now().month &&
            e.birthdayDate.day == DateTime.now().day)
        .toList();
  }

  Future<void> updateBirthday(BirthdayModel model) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    await database.birthdayDao.updateModel(model);

    await database.close();
  }

  Future<void> saveBirthday(BirthdayModel model) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    await database.birthdayDao.insertModel(model);

    await database.close();
  }

  Future<void> deleteBirthday(BirthdayModel model) async {
    final database =
        await $FloorAppDatabase.databaseBuilder(DataBaseConstants.name).build();
    await database.birthdayDao.deleteModel(model);

    await database.close();
  }
}
