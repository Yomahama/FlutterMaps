import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:readit/models/book.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  static const _tableName = 'books';

  static const id = '_id';
  static const title = 'title';
  static const author = 'author';
  static const registrationDate = 'registrationDate';
  static const review = 'review';
  static const years = 'years';
  static const pages = 'pages';
  static const description = 'description';
  static const image = 'image';

  Future<Database> get database async {
    if (_database != null) return _database;

    return initDB();
  }

  Future<Database> initDB() async {
    return openDatabase(join(await getDatabasesPath(), 'books3.db'),
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_tableName (
           $id INTEGER PRIMARY KEY,
           $title TEXT,
           $author TEXT,
           $registrationDate TEXT,
           $review TEXT,
           $pages TEXT,
           $years TEXT,
           $description TEXT,
           $image TEXT
        )
        ''');
    }, version: 1);
  }

  Future<Book> addBook(Book book) async {
    final db = await database;

    await db.rawInsert('''
      INSERT INTO $_tableName (
        $title, $author, $registrationDate, $review, $pages, $years, $description, $image
      ) VALUES (?, ?, ?, ?, ?,? , ?, ?)
    ''', [
      book.title,
      book.author,
      book.registrationDate,
      book.review,
      book.pages,
      book.years,
      book.description,
      book.image
    ]);

    return book;
  }

  Future<List<Book>> getBooks() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Book(
          id: int.parse(maps[i][id].toString()),
          title: maps[i][title].toString(),
          author: maps[i][author].toString(),
          registrationDate: maps[i][registrationDate].toString(),
          review: maps[i][review].toString(),
          pages: maps[i][pages].toString(),
          years: maps[i][years].toString(),
          description: maps[i][description].toString(),
          image: maps[i][image].toString());
    });
  }

  Future<void> removeContents() async {
    final Database db = await database;

    await db.execute("DELETE FROM $_tableName");
  }

  Future<Book> updateBook(Book book, int bookId) async {
    final db = await database;

    await db.rawUpdate('''
    UPDATE $_tableName
    SET $title = ?, $author = ?, $registrationDate = ?, $review = ?, $pages = ?, $years = ?, $description = ?, $image = ?
    WHERE $id = ?
    ''', [
      book.title,
      book.author,
      book.registrationDate,
      book.review,
      book.pages,
      book.years,
      book.description,
      book.image,
      bookId
    ]);

    return book;
  }

  Future<void> removeBook(int bookId) async {
    final db = await database;

    await db.rawDelete('''
    DELETE FROM $_tableName 
    WHERE $id = ? 
    ''', [bookId]);
  }
}
