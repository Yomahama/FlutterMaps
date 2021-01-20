import 'package:flutter/material.dart';
import 'package:readit/bloc/book_bloc.dart';
import 'package:readit/screens/addScreen.dart';
import 'package:readit/screens/mainScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(Readit());

class Readit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookBloc>(
      create: (context) => BookBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => MainScreen(),
            '/add': (context) => const AddBookScreen(null),
          }),
    );
  }
}
