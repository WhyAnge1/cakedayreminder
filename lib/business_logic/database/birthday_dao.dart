import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class BirthdayDao {
  @Query('SELECT * FROM BirthdayModel')
  Future<List<BirthdayModel>> getAll();

  @Query('SELECT * FROM BirthdayModel WHERE id = :id')
  Future<List<BirthdayModel>> getById(int id);

  @insert
  Future<int> insertModel(BirthdayModel model);

  @insert
  Future<List<int>> insertItems(List<BirthdayModel> items);

  @update
  Future<int> updateModel(BirthdayModel model);

  @delete
  Future<void> deleteModel(BirthdayModel model);
}
