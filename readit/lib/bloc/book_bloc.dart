import 'package:readit/database.dart';
import 'package:readit/events/book_event.dart';
import 'package:readit/events/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  @override
  BookState get initialState => BooksLoading();

  @override
  Stream<BookState> mapEventToState(BookEvent event) async* {
    final DBProvider _db = DBProvider.db;

    Stream<BookState> _reloadBooks() async* {
      final books = await _db.getBooks();
      yield BooksLoaded(books);
    }

    if (event is LoadBooks) {
      yield BooksLoading();
      yield* _reloadBooks();
    } else if (event is AddBook) {
      _db.addBook(event.book);
      yield* _reloadBooks();
    } else if (event is DeleteBook) {
      _db.removeBook(event.id);
      yield* _reloadBooks();
    } else if (event is UpdateBook) {
      _db.updateBook(event.book, event.id);
      yield* _reloadBooks();
    }
  }
}
