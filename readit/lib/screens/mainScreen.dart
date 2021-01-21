//import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readit/bloc/book_bloc.dart';
import 'package:readit/events/book_event.dart';
import 'package:readit/events/book_state.dart';
import 'package:readit/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spins;
import 'package:readit/widgets/modern_tile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

//F5F3EC

class _MainScreenState extends State<MainScreen> {
  List<Book> _booksForSearch = [];
  List<Book> _books = [];
  bool _searchButtonPressed = false;
  BookBloc _bookBloc;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //DBProvider.db.removeContents();
    _getBooks();
    _controller.addListener(() => _searchForTiles());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#F5F3EC'),
        title: _searchButtonPressed ? rowWithCancel() : rowWithoutCancel(),
        toolbarHeight: 50,
      ),
      body: Container(
        color: HexColor('#F8F9F3'),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (_controller.text.isEmpty) {
              if (state is BooksLoading) {
                return const spins.SpinKitFadingCircle(
                    color: Colors.grey, size: 30.0);
              } else if (state is BooksLoaded && state.books.isNotEmpty) {
                return itemList(state.books);
              }
              return emptyShelf();
            } else if (_booksForSearch.isNotEmpty) {
              return buildSearchListView();
            } else if (_booksForSearch.isEmpty && _books.isNotEmpty) {
              return Container();
            } else {
              return emptyShelf();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add');

          _closeTextField();
        },
        backgroundColor: Colors.grey,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add book',
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        elevation: 0,
      ),
    );
  }

  Widget divider = Divider(
    indent: 10,
    color: Colors.grey[500],
    thickness: 1,
  );

  Widget emptyShelf() {
    return const Center(
      child: Text(
        'Book shelf is empty!\nClick add book button to to add a book.',
        style: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
      ),
    );
  }

  String spentTimeDates(int index, List<Book> copy) {
    if (index == 0 && copy.length > 1) {
      final DateTime date2 = DateTime.parse(copy.elementAt(1).registrationDate);
      final DateTime date1 = DateTime.parse(copy.elementAt(0).registrationDate);

      final int diff = date2.difference(date1).inDays;

      return diff.toString();
    } else if (index == 0) {
      return '0';
    } else {
      final DateTime date2 =
          DateTime.parse(copy.elementAt(index).registrationDate);
      final DateTime date1 =
          DateTime.parse(copy.elementAt(index - 1).registrationDate);

      final int diff = date2.difference(date1).inDays;

      return diff.toString();
    }
  }

  void _closeTextField() {
    _controller.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _searchButtonPressed = false;

      _booksForSearch.addAll(_books);
    });
  }

  Widget cancelButton() {
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()..onTap = () => _closeTextField(),
        text: "Cancel",
        style: const TextStyle(
            color: Colors.blue, fontFamily: 'Roboto', fontSize: 16),
      ),
    );
  }

  Widget rowWithCancel() {
    return Row(children: [
      textField(315),
      const SizedBox(width: 15),
      cancelButton(),
    ]);
  }

  Widget rowWithoutCancel() {
    return Row(
      children: [
        textField(375),
      ],
    );
  }

  Widget itemList(List<Book> books) {
    // if (_books.isEmpty) {
    //   _books = List<Book>.from(books);
    //   _booksForSearch = List<Book>.from(_books);
    // } else if (_books.length != _booksForSearch.length) {
    //   _booksForSearch = List<Book>.from(_books);
    // }
    _books = List<Book>.from(books);
    _booksForSearch = List<Book>.from(books);
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => divider,
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        //return BookTileNew(book, '');
        return ModernTile(book);
      },
    );
  }

  Widget buildSearchListView() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => divider,
      itemCount: _booksForSearch.length,
      itemBuilder: (context, index) {
        final book = _booksForSearch[index];
        return ModernTile(book);
      },
    );
  }

  void _searchForTiles() {
    setState(() {
      _booksForSearch = _books
          .where((book) =>
              book.title
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()) ||
              book.author
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()))
          .toList();
    });
  }

  Widget textField(double width) {
    return Container(
      height: 35,
      width: width,
      child: TextField(
        onTap: () => setState(() => _searchButtonPressed = true),
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: 'Title, author',
        ),
        style: const TextStyle(
            color: Colors.grey, fontSize: 15, fontFamily: 'Roboto'),
      ),
    );
  }

  Future<void> _getBooks() async {
    _bookBloc = BlocProvider.of<BookBloc>(context);
    _bookBloc.add(LoadBooks());
  }

  _showInfoDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Your resume'),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true, child: Text('you have read xx books'))
            ],
          );
        });
  }
}
