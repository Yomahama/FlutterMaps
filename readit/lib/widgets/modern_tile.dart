import 'package:flutter/material.dart';
import 'package:readit/models/book.dart';
import 'package:readit/screens/addScreen.dart';
import 'package:readit/utility.dart';
import 'package:readit/widgets/bottomSheet.dart';

class ModernTile extends StatelessWidget {
  final Book book;
  //F8F9F3

  ModernTile(this.book);

  @override
  Widget build(BuildContext context) {
    final Image image = Utility.imageFromBase64String1(book.image, context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: InkWell(
        onDoubleTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddBookScreen(book))),
        onTap: () => _showBottomSheet(context, book, 'time'),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: book.image.isNotEmpty ? image : emptyImage(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        book.title,
                        style: styleTitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'by: ${book.author}',
                        style: styleAuthor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ratingAndPages(book),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Record date: ${book.registrationDate}',
                        style: styleNumbers,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Spent time reading: 15 days',
                        style: styleNumbers,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ratingAndPages(Book book) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          size: 15,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(book.review, style: styleNumbers),
        const SizedBox(width: 10),
        const Icon(Icons.circle, size: 3, color: Colors.grey),
        const SizedBox(width: 10),
        const Icon(
          Icons.menu_book_outlined,
          size: 15,
          color: Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(book.pages, style: styleNumbers),
        const SizedBox(width: 10),
        const Icon(Icons.circle, size: 3, color: Colors.grey),
        const SizedBox(width: 10),
        Text(book.years, style: styleNumbers),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, Book book, String spentTime) {
    showModalBottomSheet<dynamic>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return CustomBottomSheet(book, spentTime);
        });
  }

  Widget emptyImage(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      width: 80,
      height: 110, //MediaQuery.of(context).size.height - 700,
      child: const Icon(
        Icons.image,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget emptyImageTest(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Container(
        color: Colors.grey[300],
        width: 80,
        child: const Icon(
          Icons.image,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  final styleTitle = const TextStyle(
      fontFamily: 'Roboto', fontWeight: FontWeight.w500); //fontSize: 20.0

  final styleAuthor = const TextStyle(fontFamily: 'Roboto'); //, fontSize: 15.0

  final styleNumbers =
      const TextStyle(fontFamily: 'Roboto', color: Colors.grey);
}
