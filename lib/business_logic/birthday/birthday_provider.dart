import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:cakeday_reminder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BirthdayProvider extends ChangeNotifier {
  final _birthdayService = getIt.get<BirthdayService>();

  Map<DateTime, List<BirthdayModel>> birthdayList = {};

  Future addBirthday(BirthdayModel birthday) async {
    await _birthdayService.addBirthday(birthday);

    refreshBirthdays();
  }

  Future removeBirthday(BirthdayModel birthday) async {
    await _birthdayService.removeBirthday(birthday);

    refreshBirthdays();
  }

  Future updateBirthday(BirthdayModel birthday) async {
    await _birthdayService.updateBirthday(birthday);

    refreshBirthdays();
  }

  Future refreshBirthdays() async {
    birthdayList = await _birthdayService.getGroupedBirthdays();

    notifyListeners();
  }
}
