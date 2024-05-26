// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birthday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BirthdayModel _$BirthdayModelFromJson(Map<String, dynamic> json) =>
    BirthdayModel(
      id: (json['id'] as num?)?.toInt(),
      personName: json['personName'] as String,
      birthdayDate: DateTime.parse(json['birthdayDate'] as String),
      note: json['note'] as String? ?? '',
    );

Map<String, dynamic> _$BirthdayModelToJson(BirthdayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personName': instance.personName,
      'birthdayDate': instance.birthdayDate.toIso8601String(),
      'note': instance.note,
    };
