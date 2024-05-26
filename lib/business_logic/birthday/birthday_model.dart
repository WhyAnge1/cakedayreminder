import 'package:floor/floor.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'birthday_model.g.dart';

@entity
@JsonSerializable()
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

  factory BirthdayModel.fromJson(Map<String, dynamic> json) =>
      _$BirthdayModelFromJson(json);

  Map<String, dynamic> toJson() => _$BirthdayModelToJson(this);
}
