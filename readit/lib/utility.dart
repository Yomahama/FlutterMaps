import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static const String IMG_KEY = 'IMAGE_KEY';

  static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(IMG_KEY, value);
  }

  static Future<String> getImageFromPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(IMG_KEY);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String2(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      height: 150,
      width: 130,
      fit: BoxFit.fitWidth,
    );
  }

  static Image imageFromBase64String1(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      width: 80,
      height: 100,
      fit: BoxFit.fitWidth,
    );
  }
}
