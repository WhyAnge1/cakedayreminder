// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BirthdayDao? _birthdayDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BirthdayModel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `personName` TEXT NOT NULL, `birthdayDate` INTEGER NOT NULL, `note` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BirthdayDao get birthdayDao {
    return _birthdayDaoInstance ??= _$BirthdayDao(database, changeListener);
  }
}

class _$BirthdayDao extends BirthdayDao {
  _$BirthdayDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _birthdayModelInsertionAdapter = InsertionAdapter(
            database,
            'BirthdayModel',
            (BirthdayModel item) => <String, Object?>{
                  'id': item.id,
                  'personName': item.personName,
                  'birthdayDate': _dateTimeConverter.encode(item.birthdayDate),
                  'note': item.note
                }),
        _birthdayModelUpdateAdapter = UpdateAdapter(
            database,
            'BirthdayModel',
            ['id'],
            (BirthdayModel item) => <String, Object?>{
                  'id': item.id,
                  'personName': item.personName,
                  'birthdayDate': _dateTimeConverter.encode(item.birthdayDate),
                  'note': item.note
                }),
        _birthdayModelDeletionAdapter = DeletionAdapter(
            database,
            'BirthdayModel',
            ['id'],
            (BirthdayModel item) => <String, Object?>{
                  'id': item.id,
                  'personName': item.personName,
                  'birthdayDate': _dateTimeConverter.encode(item.birthdayDate),
                  'note': item.note
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BirthdayModel> _birthdayModelInsertionAdapter;

  final UpdateAdapter<BirthdayModel> _birthdayModelUpdateAdapter;

  final DeletionAdapter<BirthdayModel> _birthdayModelDeletionAdapter;

  @override
  Future<List<BirthdayModel>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM BirthdayModel',
        mapper: (Map<String, Object?> row) => BirthdayModel(
            id: row['id'] as int?,
            personName: row['personName'] as String,
            birthdayDate: _dateTimeConverter.decode(row['birthdayDate'] as int),
            note: row['note'] as String));
  }

  @override
  Future<List<BirthdayModel>> getById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM BirthdayModel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BirthdayModel(
            id: row['id'] as int?,
            personName: row['personName'] as String,
            birthdayDate: _dateTimeConverter.decode(row['birthdayDate'] as int),
            note: row['note'] as String),
        arguments: [id]);
  }

  @override
  Future<int> insertModel(BirthdayModel model) {
    return _birthdayModelInsertionAdapter.insertAndReturnId(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertItems(List<BirthdayModel> items) {
    return _birthdayModelInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateModel(BirthdayModel model) {
    return _birthdayModelUpdateAdapter.updateAndReturnChangedRows(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteModel(BirthdayModel model) async {
    await _birthdayModelDeletionAdapter.delete(model);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
