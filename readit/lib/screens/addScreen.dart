import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readit/bloc/book_bloc.dart';
import 'package:readit/events/book_event.dart';
import 'package:readit/models/book.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart' as flush;
import 'package:readit/utility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readit/widgets/datetime_picker_button.dart';
import 'package:reviews_slider/reviews_slider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBookScreen extends StatefulWidget {
  final Book book;

  const AddBookScreen(this.book);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final Book _current = Book(
    id: null,
    title: '',
    author: '',
    registrationDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    review: '2',
    pages: '',
    years: '',
    description: '',
    image: '',
  );

  bool _titleIsEntered = false;
  bool _authorIsEntered = false;
  bool _pagesIsEntered = false;
  bool _yearsIsEntered = false;
  bool _descriptionIsEntered = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerAuthor.dispose();
    _controllerPages.dispose();
    _controllerYears.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();

  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerAuthor = TextEditingController();
  TextEditingController _controllerPages = TextEditingController();
  TextEditingController _controllerYears = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();

  void _initializeController() {
    if (widget.book != null) {
      _controllerTitle = TextEditingController(text: widget.book.title);
      _controllerAuthor = TextEditingController(text: widget.book.author);
      _controllerPages = TextEditingController(text: widget.book.pages);
      _controllerYears = TextEditingController(text: widget.book.years);
      _controllerDescription =
          TextEditingController(text: widget.book.description);
      _titleIsEntered = true;
      _authorIsEntered = true;
      _pagesIsEntered = true;
      _yearsIsEntered = true;

      if (widget.book.description.isNotEmpty) {
        _descriptionIsEntered = true;
      }
    }
  }

  // ignore: avoid_void_async
  void _pickImageFromCamera() async {
    final cameraPermission = await Permission.camera.status;

    if (cameraPermission.isUndetermined) {
      await Permission.camera.request();

      if (await Permission.camera.status.isGranted) {
        ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
          final String imgString =
              Utility.base64String(imgFile.readAsBytesSync());

          setState(() => _current.image = imgString);
        });
      } else {
        return;
      }
    } else if (cameraPermission.isDenied ||
        cameraPermission.isPermanentlyDenied ||
        cameraPermission.isRestricted) {
      return;
    } else {
      ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
        final String imgString =
            Utility.base64String(imgFile.readAsBytesSync());

        setState(() => _current.image = imgString);
      });
    }
  }

  // ignore: avoid_void_async
  void _pickImageFromGallery() async {
    final galleryPermission = await Permission.storage.status;

    if (galleryPermission.isUndetermined) {
      await Permission.storage.request();

      if (await Permission.storage.status.isGranted) {
        ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
          final String imgString =
              Utility.base64String(imgFile.readAsBytesSync());

          setState(() => _current.image = imgString);
        });
      } else {
        return;
      }
    } else if (galleryPermission.isDenied ||
        galleryPermission.isPermanentlyDenied ||
        galleryPermission.isRestricted) {
      return;
    } else {
      ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
        final String imgString =
            Utility.base64String(imgFile.readAsBytesSync());

        setState(() => _current.image = imgString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F8F9F3'),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          widget.book != null
              ? IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onPressed: () async {
                    await _areYouSureWantToDelete();
                    print("Pradeta");
                    //Navigator.pop(context);
                  })
              : const Icon(null)
        ],
        toolbarHeight: 50,
        backgroundColor: Colors.grey[200],
        title: Text(
          widget.book == null ? 'Add book' : 'Update book',
          style: styleTitle,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              titleForm(),
              const SizedBox(height: 15),
              authorForm(),
              const SizedBox(height: 15),
              Row(
                children: [
                  pagesForm(),
                  const SizedBox(width: 15),
                  yearForm(),
                ],
              ),
              const SizedBox(height: 15),
              descriptionForm(),
              const SizedBox(height: 10),
              DatetimePickerButton(
                onDateChanged: (date) {
                  setState(() => _current.registrationDate = date);
                },
              ),
              const SizedBox(height: 15),
              Row(children: [
                Text(
                  'How enjoyable was the book?',
                  style: styleFields,
                ),
              ]),
              const SizedBox(height: 10),
              ReviewSlider(
                onChange: (int val) => _current.review = (val).toString(),
                initialValue: widget.book == null
                    ? int.parse(_current.review)
                    : int.parse(widget.book.review),
              ),
              //const SizedBox(height: 15),
              Row(
                children: [
                  widget.book == null || widget.book.image.isEmpty
                      ? _current.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Utility.imageFromBase64String2(
                                  _current.image))
                          : ClipRRect(
                              child: Container(
                                height: 130,
                                width: 110,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child:
                              Utility.imageFromBase64String2(widget.book.image),
                        ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  FloatingActionButton.extended(
                    heroTag: "btn2",
                    onPressed: () {
                      _pickImage();
                    },
                    backgroundColor: Colors.grey,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text(
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
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn1",
        onPressed: () => _saveBook(),
        backgroundColor: Colors.grey,
        icon: const Icon(Icons.save),
        label: Text(
          widget.book == null ? 'Save book' : 'Update book',
          style: const TextStyle(fontFamily: 'Roboto'),
        ),
        elevation: 0,
      ),
    );
  }

  void _pickImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                  title: const Text("Gallery",
                      style: TextStyle(fontFamily: 'Roboto')),
                  trailing: const Icon(Icons.photo),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  }),
              ListTile(
                  title: const Text("Camera"),
                  trailing: const Icon(Icons.camera),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  }),
            ],
          );
        });
  }

  void _areYouSureWantToDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Delete book",
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        content: const Text(
          "Are you sure to delete book?",
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              _removeBook();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/", (Route<dynamic> route) => false);
            },
            child: const Text(
              "Yes",
              style: TextStyle(fontFamily: 'Roboto'),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "No",
              style: TextStyle(fontFamily: 'Roboto'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _removeBook() async {
    // ignore: await_only_futures
    await BlocProvider.of<BookBloc>(context).add(DeleteBook(widget.book.id));

    flush.Flushbar(
      message: 'Book removed.',
      duration: const Duration(seconds: 1),
    ).show(context);
  }

  Future<void> _saveBook() async {
    if (_formKey1.currentState.validate() &&
        _formKey2.currentState.validate() &&
        _formKey3.currentState.validate() &&
        _formKey4.currentState.validate()) {
      _formKey1.currentState.save();
      _formKey2.currentState.save();
      _formKey3.currentState.save();
      _formKey4.currentState.save();
      _formKey5.currentState.save();

      //final String formattedDate = DateFormat('yyyy-MM-dd').format(_dateTime);

      if (widget.book != null) {
        Navigator.pop(
            context,
            BlocProvider.of<BookBloc>(context)
                .add(UpdateBook(_current, widget.book.id)));
      } else {
        Navigator.pop(
            context, BlocProvider.of<BookBloc>(context).add(AddBook(_current)));
      }

      flush.Flushbar(
        message: widget.book == null ? 'Book added.' : 'Book updated.',
        duration: const Duration(seconds: 1),
      ).show(context);
    }
  }

  Widget buildIcon(bool textIsEntered) {
    if (textIsEntered) {
      return const Icon(Icons.clear);
    } else {
      return const Icon(null);
    }
  }

  Widget titleForm() {
    return Form(
      key: _formKey1,
      child: TextFormField(
        controller: _controllerTitle,
        textInputAction: TextInputAction.next,
        maxLength: 70,
        decoration: textInputDecoration.copyWith(
            suffixIcon: IconButton(
              icon: buildIcon(_titleIsEntered),
              onPressed: () {
                _controllerTitle.clear();
                setState(() => _titleIsEntered = false);
              },
            ),
            hintText: 'Title',
            counterText: ''),
        onChanged: (_) {
          setState(() {
            _checkTitleController();
          });
        },
        onSaved: (val) => _current.title = val,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'[A-Za-ząėęįųūčšžĄĖĘĮŲŪČŠŽ0-9\s.,;:"]')),
        ],
        validator: (value) {
          if (value.isEmpty) {
            return "Field can't be empty";
          }
          return null;
        },
      ),
    );
  }

  void _checkTitleController() {
    if (_controllerTitle.text.isNotEmpty) {
      _titleIsEntered = true;
    } else {
      _titleIsEntered = false;
    }
  }

  Widget authorForm() {
    return Form(
      key: _formKey2,
      child: TextFormField(
        controller: _controllerAuthor,
        textInputAction: TextInputAction.next,
        maxLength: 35,
        decoration: textInputDecoration.copyWith(
          hintText: 'Author',
          counterText: '',
          suffixIcon: IconButton(
            onPressed: () {
              _controllerAuthor.clear();
              setState(() => _authorIsEntered = false);
            },
            icon: buildIcon(_authorIsEntered),
          ),
        ),
        onChanged: (_) {
          setState(() {
            _checkAuthorController();
          });
        },
        onSaved: (val) => _current.author = val,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'[A-Za-ząėęįųūčšžĄĖĘĮŲŪČŠŽ\s]')),
        ],
        validator: (value) {
          if (value.isEmpty) {
            return "Field can't be empty";
          }
          return null;
        },
      ),
    );
  }

  void _checkAuthorController() {
    if (_controllerAuthor.text.isNotEmpty) {
      _authorIsEntered = true;
    } else {
      _authorIsEntered = false;
    }
  }

  Widget pagesForm() {
    return Flexible(
      child: Form(
        key: _formKey3,
        child: TextFormField(
          controller: _controllerPages,
          textInputAction: TextInputAction.next,
          maxLength: 5,
          decoration: textInputDecoration.copyWith(
            hintText: 'Pages',
            counterText: '',
            suffixIcon: IconButton(
              onPressed: () {
                _controllerPages.clear();
                setState(() => _pagesIsEntered = false);
              },
              icon: buildIcon(_pagesIsEntered),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          onChanged: (_) {
            setState(() {
              _checkPagesController();
            });
          },
          onSaved: (val) => _current.pages = val,
          validator: (value) {
            if (value.isEmpty || int.parse(value) < 1) {
              return "Empty or less than 1";
            }
            return null;
          },
        ),
      ),
    );
  }

  void _checkPagesController() {
    if (_controllerPages.text.isNotEmpty) {
      _pagesIsEntered = true;
    } else {
      _pagesIsEntered = false;
    }
  }

  Widget yearForm() {
    return Flexible(
      child: Form(
        key: _formKey4,
        child: TextFormField(
          controller: _controllerYears,
          textInputAction: TextInputAction.next,
          maxLength: 4,
          decoration: textInputDecoration.copyWith(
            hintText: 'Year',
            counterText: '',
            suffixIcon: IconButton(
              onPressed: () {
                _controllerYears.clear();
                setState(() => _yearsIsEntered = false);
              },
              icon: buildIcon(_yearsIsEntered),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          onChanged: (_) {
            setState(() {
              _checkYearController();
            });
          },
          onSaved: (val) => _current.years = val,
          validator: (value) {
            if (value.isEmpty || int.parse(value) > DateTime.now().year) {
              return "Empty or incorrect.";
            }
            return null;
          },
        ),
      ),
    );
  }

  void _checkYearController() {
    if (_controllerYears.text.isNotEmpty) {
      _yearsIsEntered = true;
    } else {
      _yearsIsEntered = false;
    }
  }

  Widget descriptionForm() {
    return Form(
      key: _formKey5,
      child: TextFormField(
        controller: _controllerDescription,
        textInputAction: TextInputAction.done,
        maxLines: 4,
        maxLength: 500,
        onChanged: (_) {
          setState(() {
            _checkDescriptionForm();
          });
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'[A-Za-ząėęįųūčšžĄĖĘĮŲŪČŠŽ0-9\s.,:?!%"]')),
        ],
        decoration: textInputDecoration.copyWith(
            suffixIcon: IconButton(
              onPressed: () {
                _controllerDescription.clear();
                setState(() => _descriptionIsEntered = false);
              },
              icon: buildIcon(_descriptionIsEntered),
            ),
            hintText: 'Description',
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 0)),
        onSaved: (val) => _current.description = val,
      ),
    );
  }

  void _checkDescriptionForm() {
    if (_controllerDescription.text.isNotEmpty) {
      _descriptionIsEntered = true;
    } else {
      _descriptionIsEntered = false;
    }
  }

  TextStyle styleTitle = const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    letterSpacing: 2.0,
    color: Colors.grey,
  );

  TextStyle styleFields = const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15,
    color: Colors.grey,
  );

  InputDecoration decorationMinimal = const InputDecoration(
    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.brown, width: 2.5),
    ),
  );

  InputDecoration textInputDecoration = InputDecoration(
    hintStyle:
        const TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: 15),
    filled: true,
    contentPadding: const EdgeInsets.only(left: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
