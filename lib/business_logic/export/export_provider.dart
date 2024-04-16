import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:cakeday_reminder/business_logic/export/export_service.dart';
import 'package:cakeday_reminder/main.dart';
import 'package:flutter/material.dart';

class ExportProvider extends ChangeNotifier {
  final _exportService = getIt.get<ExportService>();
  final _birthdayService = getIt.get<BirthdayService>();

  Future<bool> exportBirthdaysAsXml() async {
    final birthdays = await _birthdayService.getAllBirthdays();
    final result = await _exportService.exportBirthdaysToXml(birthdays);

    return result;
  }
}
