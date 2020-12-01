import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const mainTextStyle =
    TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Roboto Regular');

const inputDecoration = InputDecoration(
  //value -> hintText
  fillColor: Colors.white,
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white, width: 2.0),
    //borderRadius: BorderRadius.circular()),
  ),
);

const tileTextSmall = TextStyle(fontSize: 12, fontFamily: 'Roboto Regular');

const tileTextBig = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontFamily: 'Roboto Regular',
  letterSpacing: 2.0,
);
