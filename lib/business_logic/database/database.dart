import 'dart:async';
import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/database/birthday_dao.dart';
import 'package:cakeday_reminder/business_logic/database/date_time_converter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [BirthdayModel])
abstract class AppDatabase extends FloorDatabase {
  BirthdayDao get birthdayDao;
}
