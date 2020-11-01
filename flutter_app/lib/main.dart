import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/maps.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _widgetOptions = <Widget>[
    Container(
      color: Colors.red,
    ),
    Maps(),
    Container(
      color: Colors.yellow,
    )
  ];

  int _currentIndex = 1;

  void _onTappedItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String appBarTitle = getApp

  // App
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            getAppBarTitle(),
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 10.0,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 35.0,
          backgroundColor: HexColor('212121'),
        ),
        body: _widgetOptions[_currentIndex],
        bottomNavigationBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_dash),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.info),
            )
          ],
          currentIndex: 1,
          onTap: _onTappedItem,
          activeColor: Colors.white,
        ));
  }
}
