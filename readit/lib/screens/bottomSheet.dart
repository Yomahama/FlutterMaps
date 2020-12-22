import 'package:flutter/material.dart';
import 'package:readit/models/book.dart';

class CustomBottomSheet extends StatelessWidget {
  Book book;
  String spentTime;

  CustomBottomSheet(this.book, this.spentTime);

  final double sizedBoxHeight = 10.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(book.title, style: style),
            SizedBox(height: sizedBoxHeight),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  book.author,
                  style: styleAuthor,
                )),
            Divider(thickness: 2.0),
            SizedBox(height: sizedBoxHeight),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${book.description}',
                style: descriptionStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  var style = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 21,
    color: Colors.grey[600],
  );
  var styleAuthor =
      TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black);

  var descriptionStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 18,
      color: Colors.grey[850],
      fontStyle: FontStyle.italic);
}
