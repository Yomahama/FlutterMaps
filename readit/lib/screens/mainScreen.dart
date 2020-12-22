import 'package:flutter/material.dart';
import 'package:readit/models/book.dart';
import 'package:readit/widgets/bookTileNew.dart';
import 'package:readit/database.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Set<Book> _books = {};
  Set<Book> _newBooks = {};
  bool _searchButtonPressed = false;

  void initState() {
    super.initState();
    //DBProvider.db.removeContents();
    _getBooks();
  }

  Icon customIcon = Icon(
    Icons.search,
    size: 30,
    color: Colors.grey,
  );

  Widget titleText = Text(
    'Book shelf',
    style: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
      letterSpacing: 2.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: titleText,
        actions: [
          IconButton(icon: customIcon, onPressed: () => _showSearchBar())
        ],
        elevation: 2,
        toolbarHeight: 50,
      ),
      body: RefreshIndicator(
        onRefresh: () => _getBooks(),
        child: Container(
          child: _newBooks.length > 0
              ? Scrollbar(
                  child: ListView.builder(
                    itemCount: _newBooks.length,
                    itemBuilder: (context, index) => BookTileNew(
                        _newBooks.elementAt(index), spentTimeDates(index)),
                  ),
                )
              : _books.length > 0
                  ? Container()
                  : ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) => Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 300, left: 100),
                          child: Text(
                            'Book shelf is empty!\nClick add book button to add a book.',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Roboto'),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.grey,
        icon: Icon(Icons.add),
        label: Text(
          'Add book',
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        elevation: 0,
      ),
    );
  }

  String spentTimeDates(int index) {
    Set<Book> copy = Set.from(_books);

    if (index == 0 && _books.length > 1) {
      DateTime date2 = DateTime.parse(copy.elementAt(1).registrationDate);
      DateTime date1 = DateTime.parse(copy.elementAt(0).registrationDate);

      int diff = date2.difference(date1).inDays;

      return diff.toString();
    } else if (index == 0) {
      return '0';
    } else {
      DateTime date2 = DateTime.parse(copy.elementAt(index).registrationDate);
      DateTime date1 =
          DateTime.parse(copy.elementAt(index - 1).registrationDate);

      int diff = date2.difference(date1).inDays;

      return diff.toString();
    }
  }

  void _searchForTiles(String input) {
    if (_books.length != 0) {
      setState(() {
        _newBooks = _books
            .toList()
            .where((book) =>
                book.title.toLowerCase().contains(input.toLowerCase()) ||
                book.author.toLowerCase().contains(input.toLowerCase()))
            .toSet();
      });
    }
  }

  void _showSearchBar() {
    _newBooks = _books;

    if (!_searchButtonPressed) {
      setState(() {
        _searchButtonPressed = true;

        customIcon = Icon(
          Icons.cancel,
          size: 30,
          color: Colors.grey,
        );

        titleText = TextField(
            onChanged: (text) => _searchForTiles(text),
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for books or authors'),
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Roboto'));
      });
    } else {
      setState(() {
        _searchButtonPressed = false;

        customIcon = Icon(
          Icons.search,
          size: 30,
          color: Colors.grey,
        );

        titleText = Text(
          'Book shelf',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.grey,
          ),
        );
      });
    }
  }

  Future<void> _getBooks() async {
    List<Book> booksList = await DBProvider.db.getBooks();
    Set<Book> books = booksList.toSet();

    setState(() {
      _books = books;
      _newBooks = books;
    });
  }
}
