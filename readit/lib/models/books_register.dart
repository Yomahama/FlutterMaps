import 'package:readit/models/book.dart';

class Register {
  List<Book> _books = new List();

  Register(List<Book> booksToAdd) {
    for (Book book in booksToAdd) {
      _books.add(book);
    }
  }

  List<Book> get getBooks => _books;
}
