import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static const String imgKey = 'IMAGE_KEY';

  static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(imgKey, value);
  }

  static Future<String> getImageFromPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(imgKey);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String2(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      height: 130,
      width: 110,
      fit: BoxFit.fitWidth,
    );
  }

  static Image imageFromBase64String1(
      String base64String, BuildContext context) {
    return Image.memory(base64Decode(base64String),
        width: 80, height: 100, fit: BoxFit.fitHeight);
  }
}
