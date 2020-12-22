import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:readit/models/book.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'books.db'),
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE books (
          title TEXT, author TEXT, registrationDate TEXT, review TEXT, pages TEXT, description TEXT, image TEXT
        )
        ''');
    }, version: 1);
  }

  addBook(Book book) async {
    final db = await database;

    var res = await db.rawInsert('''
      INSERT INTO books (
        title, author, registrationDate, review, pages, description, image
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      book.title,
      book.author,
      book.registrationDate,
      book.review,
      book.pages,
      book.description,
      book.image
    ]);

    return res;
  }

  Future<List<Book>> getBooks() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("books");

    return List.generate(maps.length, (i) {
      return Book(
        maps[i]['title'],
        maps[i]['author'],
        maps[i]['registrationDate'],
        maps[i]['review'],
        maps[i]['pages'],
        maps[i]['description'],
        maps[i]['image'],
      );
    });
  }

  Future<void> removeContents() async {
    final db = await database;

    await db.execute("DELETE FROM books");
  }

  Future<void> updateBook(Book book, String oldImage) async {
    final db = await database;

    await db.rawUpdate('''
    UPDATE books
    SET title = ?, author = ?, registrationDate = ?, review = ?, pages = ?, description = ?, image = ?
    WHERE image = ?
    ''', [
      book.title,
      book.author,
      book.registrationDate,
      book.review,
      book.pages,
      book.description,
      book.image,
      oldImage
    ]);
  }

  Future<void> removeBook(Book book) async {
    final db = await database;

    await db.rawDelete('''
    DELETE FROM books 
    WHERE title = ? AND author = ? AND registrationDate = ? AND review = ? AND pages = ? AND description = ? AND image = ?
    ''', [
      book.title,
      book.author,
      book.registrationDate,
      book.review,
      book.pages,
      book.description,
      book.image
    ]);
  }
}
