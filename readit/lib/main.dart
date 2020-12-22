import 'package:flutter/material.dart';
import 'package:readit/screens/addScreen.dart';
import 'package:readit/screens/mainScreen.dart';

void main() => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/add': (context) => AddBookScreen(null),
        }));
