import 'package:flutter/material.dart';
import 'package:readit/models/book.dart';
import 'package:readit/screens/addScreen.dart';
import 'package:readit/widgets/bottomSheet.dart';
import 'package:readit/utility.dart';

class BookTileNew extends StatefulWidget {
  final Book book;
  final String spentTime;

  const BookTileNew(this.book, this.spentTime);

  @override
  _BookTileNewState createState() => _BookTileNewState();
}

class _BookTileNewState extends State<BookTileNew> {
  String subString(String title) {
    if (title.length > 25) return title.substring(0, 18) + '...';

    return title;
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width - 399;
    double fontSizeTitle = MediaQuery.of(context).size.width - 395;

    return InkWell(
      onDoubleTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddBookScreen(widget.book))),
      onTap: () => _showBottomSheet(context, widget.book, widget.spentTime),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height - 700, //741
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1),
                    color: Colors.black26),
              ]),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: widget.book.image.length != 0
                      ? Utility.imageFromBase64String1(
                          widget.book.image, context)
                      : Container(
                          child: Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          color: Colors.grey[300],
                          width: 80,
                          height: 100,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 25, 10), //25
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(subString(widget.book.title),
                                            style: styleTitle.copyWith(
                                                fontSize: fontSizeTitle))
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      endIndent: 50,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.book.author,
                                          style: styleAuthor.copyWith(
                                              fontSize: fontSize),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Text(
                                          'Record date: ${widget.book.registrationDate}',
                                          style: styleNumbers.copyWith(
                                              fontSize: fontSize),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 54),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 15,
                                                      color: Colors.grey,
                                                    ),
                                                    Text(
                                                      widget.book.review,
                                                      style:
                                                          styleNumbers.copyWith(
                                                              fontSize:
                                                                  fontSize),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Text(
                                          'Time spent reading: ${widget.spentTime} days',
                                          style: styleNumbers.copyWith(
                                              fontSize: fontSize),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 32),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.menu_book_outlined,
                                                      size: 15,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      widget.book.pages,
                                                      style:
                                                          styleNumbers.copyWith(
                                                              fontSize:
                                                                  fontSize),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Book book, String spentTime) {
    showModalBottomSheet<dynamic>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return CustomBottomSheet(book, spentTime);
        });
  }

  var styleTitle = TextStyle(
      fontFamily: 'Roboto', fontWeight: FontWeight.w500); //fontSize: 20.0

  var styleAuthor = TextStyle(fontFamily: 'Roboto'); //, fontSize: 15.0

  var styleNumbers =
      TextStyle(fontFamily: 'Roboto', color: Colors.grey); //, fontSize: 15.0
}
