import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tracking_health/model/transaction.dart' as trans;
import 'package:tracking_health/model/user.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  static const _usersTable = 'users';

  static const idPerson = 'id';
  static const firstName = 'first_name';
  static const lastName = 'last_name';

  static const _transactionsTable = 'transactions';

  static const id = 'id';
  static const nameHas = 'name_has';
  static const surnameHas = 'surname_has';
  static const nameNeed = 'name_need';
  static const surnameNeed = 'surname_need';
  static const money = 'money';

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    return initDB();
  }

  Future<Database> initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'data.db'),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE $_transactionsTable($id INTEGER PRIMARY KEY, $nameHas TEXT, $surnameHas TEXT, $nameNeed TEXT, $surnameNeed TEXT, $money DOUBLE)");
        db.execute(
            "CREATE TABLE $_usersTable($idPerson INTEGER PRIMARY KEY, $firstName TEXT, $lastName TEXT)");

        return db;
      },
      version: 1,
    );
  }

  //Transaction methods
  Future<List<trans.Transaction>> getTransactions() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('$_transactionsTable');

    return List.generate(maps.length, (i) {
      return trans.Transaction.fromMap(maps[i]);
    });
  }

  Future<void> insertTransaction(trans.Transaction transaction) async {
    final db = await database;

    await db.insert('$_transactionsTable', transaction.toMap());
  }

  Future<void> deleteTransaction(int transactionId) async {
    final db = await database;

    await db.delete(
      '$_transactionsTable',
      where: '$id = ?',
      whereArgs: [transactionId],
    );
  }

  //User methods (using raws methods)
  Future<List<User>> getUsers() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_usersTable);

    return List.generate(maps.length, (i) {
      return User(
        maps[i][id],
        maps[i][firstName],
        maps[i][lastName],
      );
    });
  }

  Future<void> insertUser(User user) async {
    final db = await database;

    await db.rawInsert('''
    INSERT INTO $_usersTable (
      $firstName, $lastName
    ) VALUES (?, ?)
    ''', [
      user.firstName,
      user.lastName,
    ]);
  }
}
