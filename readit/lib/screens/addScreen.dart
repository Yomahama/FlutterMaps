import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readit/database.dart';
import 'package:readit/models/book.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart' as flush;
import 'package:readit/utility.dart';

class AddBookScreen extends StatefulWidget {
  final book;

  AddBookScreen(this.book);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  String _title = '';
  String _author = '';
  DateTime _dateTime = DateTime.now();
  double _review = 1;
  String _pages = '0'; //int
  String _description = '';
  String _imageUrl = '';

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  _pickImage() {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());

      setState(() {
        _imageUrl = imgString;
      });
    });
  }

  @override
  void dispose() {
    //You can save your page here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.book != null
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context, _removeBook());
                  })
              : Icon(
                  Icons.info,
                  color: Colors.white,
                )
        ],
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        title: Text(
          widget.book == null ? 'Add book' : 'Update book',
          style: styleTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                Form(
                  key: _formKey1,
                  child: TextFormField(
                    maxLength: 70,
                    decoration: decorationMinimal.copyWith(hintText: 'Title'),
                    initialValue:
                        widget.book != null ? widget.book.title : _title,
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-ząėęįųūčšžĄĖĘĮŲŪČŠŽ0-9\s.,;:"]')),
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey2,
                  child: TextFormField(
                    maxLength: 35,
                    decoration: decorationMinimal.copyWith(hintText: 'Author'),
                    initialValue:
                        widget.book != null ? widget.book.author : _author,
                    onChanged: (value) {
                      setState(() {
                        _author = value;
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-ząėęįųūčšžĄĖĘĮŲŪČŠŽ\s]')),
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey3,
                  child: TextFormField(
                    maxLength: 3,
                    decoration: decorationMinimal.copyWith(hintText: 'Pages'),
                    initialValue: widget.book == null ? '' : widget.book.pages,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _pages = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty || int.parse(value) < 1) {
                        return 'Field can\'t be empty or less than 1';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  child: TextFormField(
                    maxLines: 4,
                    maxLength: 500,
                    initialValue: widget.book != null
                        ? widget.book.description
                        : _description,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-ząėęįųūčšžĄĖĘĮŲŪČŠŽ0-9\s.,:?!%"]')),
                    ],
                    decoration:
                        decorationMinimal.copyWith(hintText: 'Description'),
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Book read date: ', style: styleFields),
                  ],
                ),
                SizedBox(
                  height: 30,
                  child: CupertinoDatePicker(
                      initialDateTime: widget.book == null
                          ? _dateTime
                          : DateTime.parse(widget.book.registrationDate),
                      minimumYear: DateTime.now().year - 1,
                      maximumYear: DateTime.now().year,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (dateTime) {
                        setState(() {
                          _dateTime = dateTime;
                        });
                      }),
                ),
                SizedBox(height: 20),
                Row(children: [
                  Text(
                    'Review (1 - 10):',
                    style: styleFields,
                  ),
                ]),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.grey[500],
                          inactiveTrackColor: Colors.grey[300],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 15.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.brown,
                          overlayColor: Colors.red.withAlpha(32),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.grey[500],
                          inactiveTickMarkColor: Colors.grey[300],
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.brown,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                          value: widget.book != null
                              ? double.parse(widget.book.review)
                              : _review,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: '${_review.toInt()}',
                          onChanged: (value) {
                            setState(
                              () {
                                _review = value;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    widget.book == null || widget.book.image.length == 0
                        ? _imageUrl.length != 0
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child:
                                    Utility.imageFromBase64String2(_imageUrl))
                            : ClipRRect(
                                child: Container(
                                  height: 150,
                                  width: 130,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Utility.imageFromBase64String2(
                                widget.book.image),
                          ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    FloatingActionButton.extended(
                      heroTag: "btn2",
                      onPressed: () => _pickImage(),
                      backgroundColor: Colors.grey,
                      icon: Icon(Icons.add_a_photo_outlined),
                      label: Text(
                        'Add image',
                        style: TextStyle(fontFamily: 'Roboto'),
                      ),
                      elevation: 0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn1",
        onPressed: () => _saveBook(),
        backgroundColor: Colors.grey,
        icon: Icon(Icons.save),
        label: Text(
          widget.book == null ? 'Save book' : 'Update book',
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        elevation: 0,
      ),
    );
  }

  Future<void> _removeBook() async {
    await DBProvider.db.removeBook(widget.book);

    flush.Flushbar(
      message: 'Book removed.',
      duration: Duration(milliseconds: 800),
    ).show(context);
  }

  Future<void> _saveBook() async {
    if (_formKey1.currentState.validate() &&
        _formKey2.currentState.validate() &&
        _formKey3.currentState.validate()) {
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(_dateTime);

      Book book = new Book(
        _title == '' && widget.book != null ? widget.book.title : _title,
        _author == '' && widget.book != null ? widget.book.author : _author,
        formattedDate == formatter.format(DateTime.now()) && widget.book != null
            ? widget.book.registrationDate
            : formattedDate,
        _review.toInt().toString() == '1' && widget.book != null
            ? widget.book.review
            : _review.toInt().toString(),
        _pages.toString() == '0' && widget.book != null
            ? widget.book.pages
            : _pages.toString(),
        _description == '' && widget.book != null
            ? widget.book.description
            : _description,
        _imageUrl == '' && widget.book != null ? widget.book.image : _imageUrl,
      );

      if (widget.book != null) {
        Navigator.pop(
            context, DBProvider.db.updateBook(book, widget.book.image));
      } else {
        Navigator.pop(context, DBProvider.db.addBook(book));
      }

      flush.Flushbar(
        message: widget.book == null ? 'Book added.' : 'Book updated.',
        duration: Duration(milliseconds: 800),
      ).show(context);
    }
  }

  var styleTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    letterSpacing: 2.0,
    color: Colors.grey,
  );

  var styleFields = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15,
    color: Colors.grey,
  );

  var decorationMinimal = InputDecoration(
    hintStyle: new TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.brown, width: 2.5),
    ),
  );
}
