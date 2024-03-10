import 'package:floor/floor.dart';
import 'package:intl/intl.dart';

@entity
class BirthdayModel {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String personName;
  DateTime birthdayDate;
  String note;

  String get bithdayDateDisplayString =>
      DateFormat('d MMMM').format(birthdayDate);

  DateTime get currentYearBirthdayDate =>
      DateTime(DateTime.now().year, birthdayDate.month, birthdayDate.day);

  BirthdayModel({
    this.id,
    required this.personName,
    required this.birthdayDate,
    this.note = '',
  });
}
