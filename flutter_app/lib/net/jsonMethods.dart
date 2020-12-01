import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_app/models/foodMarker.dart';

final path = 'assets/food_data/foods.json';

// Loads json file of places to eat from assets
Future<List<FoodMarker>> getFoodList() async {
  String json = await rootBundle.loadString(path);

  var foodJson = jsonDecode(json);

  Set<FoodMarker> set = new Set();

  for (var food in foodJson) {
    FoodMarker foodMarker = FoodMarker.fromJson(food);

    set.add(foodMarker);
  }

  return set.toList();
}
