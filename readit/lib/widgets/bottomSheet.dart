import 'package:flutter/material.dart';
import 'package:readit/models/book.dart';

class CustomBottomSheet extends StatelessWidget {
  final Book book;
  final String spentTime;

  CustomBottomSheet(this.book, this.spentTime);

  final double sizedBoxHeight = 10.0;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
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
              const Divider(thickness: 2.0),
              SizedBox(height: sizedBoxHeight),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  book.description.isEmpty
                      ? "No description added."
                      : book.description,
                  style: descriptionStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  final style = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 21,
    color: Colors.grey[600],
  );
  final styleAuthor =
      const TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black);

  final descriptionStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 18,
      color: Colors.grey[850],
      fontStyle: FontStyle.italic);
}
