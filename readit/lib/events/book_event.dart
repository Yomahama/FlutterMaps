import 'package:readit/models/book.dart';

abstract class BookEvent {}

class AddBook extends BookEvent {
  final Book book;

  AddBook(this.book) : super();
}

class DeleteBook extends BookEvent {
  final int id;

  DeleteBook(this.id) : super();
}

class UpdateBook extends BookEvent {
  final Book book;
  final int id;

  UpdateBook(this.book, this.id) : super();
}

class LoadBooks extends BookEvent {}
