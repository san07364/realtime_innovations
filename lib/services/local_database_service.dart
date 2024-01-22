import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  late final Database _database;

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'employee.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id integer primary key autoincrement, name text not null, role text not null, startDate text not null, endDate text )',
        );
      },
      version: 1,
    );
  }

  Future<void> create({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    await _database.insert(table, data);
  }

  Future<List<Map<String, Object?>>> find(
      {required String table, String? orderBy}) async {
    return await _database.query(table, orderBy: orderBy);
  }

  Future<void> deleteById({
    required String table,
    required int id,
  }) async {
    await _database.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, Object?>>> findById({
    required String table,
    required int id,
  }) async {
    return await _database.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateById({
    required String table,
    required Map<String, Object?> data,
    required int id,
  }) async {
    await _database.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDb() async {
    await _database.close();
  }
}
