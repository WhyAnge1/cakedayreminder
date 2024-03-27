import 'dart:io';

import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:cakeday_reminder/business_logic/import/import_service.dart';
import 'package:cakeday_reminder/main.dart';
import 'package:flutter/material.dart';

class ImportProvider extends ChangeNotifier {
  final _importService = getIt.get<ImportService>();
  final _birthdayService = getIt.get<BirthdayService>();

  Future<bool> importBirthdaysFromFile(String filePath) async {
    var importedBirthdays =
        await _importService.importBirthdaysFromExel(File(filePath));

    if (importedBirthdays.isNotEmpty) {
      await _birthdayService.addBirthdays(importedBirthdays);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
