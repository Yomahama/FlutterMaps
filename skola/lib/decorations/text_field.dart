import 'package:flutter/material.dart';

InputDecoration customInputDecoration = InputDecoration(
  hintStyle: const TextStyle(color: Colors.grey),
  fillColor: Colors.grey[200],
  contentPadding: const EdgeInsets.only(left: 10),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(3)
  )
);
