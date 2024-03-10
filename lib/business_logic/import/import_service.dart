import 'dart:io';

import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:excel/excel.dart';

class ImportService {
  final _birthdayService = BirthdayService();

  Future<bool> importBirthdaysFromExel(File exelFile) async {
    var result = false;

    try {
      var bytes = exelFile.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      var table = excel.tables[excel.tables.keys.first];

      if (table != null) {
        for (var row in table.rows) {
          DateTime? birthday;
          String? name;
          String? note;

          if (row[0]?.value is DateCellValue) {
            var dateValue = row[0]?.value as DateCellValue;
            birthday = DateTime(dateValue.year, dateValue.month, dateValue.day);
          }

          if (row[1]?.value is TextCellValue) {
            var textValue = row[1]?.value as TextCellValue;
            name = textValue.value;
          }

          if (row[2]?.value is TextCellValue) {
            var textValue = row[2]?.value as TextCellValue;
            note = textValue.value;
          }

          if (birthday != null && name != null) {
            var model = BirthdayModel(
              birthdayDate: birthday,
              personName: name,
              note: note ?? '',
            );

            await _birthdayService.saveBirthday(model);
          }
        }

        result = true;
      }
    } catch (e) {}

    return result;
  }
}
