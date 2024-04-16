import 'dart:io';

import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  Future<bool> exportBirthdaysToXml(List<BirthdayModel> birthdays) async {
    try {
      final file = await _prepareXMLFile(birthdays);

      await Share.shareXFiles([XFile(file.path)]);

      file.delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<File> _prepareXMLFile(List<BirthdayModel> birthdays) async {
    final excel = Excel.createExcel();
    excel.rename(excel.sheets.values.first.sheetName, "Birthdays");
    final sheet = excel.sheets.values.first;

    sheet.appendRow([
      const TextCellValue("Date"),
      const TextCellValue("Name"),
      const TextCellValue("Note")
    ]);

    for (final birthday in birthdays) {
      sheet.appendRow([
        DateCellValue(
            year: birthday.birthdayDate.year,
            month: birthday.birthdayDate.month,
            day: birthday.birthdayDate.day),
        TextCellValue(birthday.personName),
        TextCellValue(birthday.note),
      ]);
    }

    for (final row in sheet.rows) {
      final dateCell = row[0]!;
      dateCell.cellStyle = (dateCell.cellStyle ?? CellStyle()).copyWith(
        numberFormat: const CustomDateTimeNumFormat(formatCode: 'dd.mm.yyyy'),
      );
    }

    final tempDirectory = await getTemporaryDirectory();
    final filePath =
        "${tempDirectory.path}/birthdays exported${DateTime.now().toString()}.xlsx";
    final file = File(filePath);
    await file.writeAsBytes(excel.save()!);

    return file;
  }
}
