import 'package:readit/models/book.dart';

abstract class BookState {}

class BooksLoading extends BookState {}

class BooksLoaded extends BookState {
  final List<Book> books;

  BooksLoaded(this.books) : super();
}
