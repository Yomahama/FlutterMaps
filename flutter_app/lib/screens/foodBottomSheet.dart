import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/foodMarker.dart';

class FoodBottomSheet extends StatelessWidget {
  final FoodMarker food;

  FoodBottomSheet({this.food});

  Future<String> getRatings() async {
    var res = await rootBundle.loadString('assets/food_data/ratings.json');

    var resBody = json.decode(res);

    print(resBody['myRating']);

    return resBody['myRating'];
  }

  @override
  Widget build(BuildContext context) {
    double _myRating = 0.0;
    double _generalRating = 0.0;

    return Container(
      color: Color(0xff29404E),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              food.title,
              style: TextStyle(
                  fontFamily: 'Roboto Regular',
                  letterSpacing: 5.0,
                  fontSize: 25.0,
                  color: Colors.white),
            ),
          ),
          Divider(color: Colors.white),
          SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/food_data/${food.imageSource}",
              width: MediaQuery.of(context).size.width - 30,
              fit: BoxFit.fill,
              height: 200,
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(children: [
              Icon(
                Icons.location_pin,
                size: 20,
                color: Colors.yellow[700],
              ),
              SizedBox(width: 8),
              Text(
                food.address,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto Regular',
                ),
              ),
            ]),
          ),
          SizedBox(height: 22),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 20,
                  color: Colors.yellow[700],
                ),
                SizedBox(width: 8),
                Text(food.number,
                    style:
                        TextStyle(fontSize: 16, fontFamily: 'Roboto Regular'))
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 15),
              stars(_myRating, _generalRating),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                text(_myRating),
              ],
            ),
          )
        ],
      ),
    );
  }

  void writeJson(int rating) {
    String ratingString = rating.toDouble().toString();

    print(ratingString);
  }

  Widget stars(double _myRating, double _generalRating) {
    List<Widget> list = new List<Widget>();

    list.add(Icon(Icons.star, size: 20, color: Colors.yellow[700]));

    list.add(SizedBox(width: 8));

    if (_myRating > 0.0) {
      int fullStars = _generalRating.floor();

      for (int i = 0; i < fullStars; i++) {
        list.add(Icon(Icons.star, size: 20, color: Colors.yellow[700]));
        list.add(SizedBox(width: 3));
      }

      for (int i = 0; i < 5 - fullStars; i++) {
        list.add(Icon(Icons.star_border, size: 20, color: Colors.yellow[700]));
        list.add(SizedBox(width: 3));
      }
    } else {
      for (int i = 0; i < 5; i++) {
        list.add(IconButton(
          icon: Icon(Icons.star_border, size: 20, color: Colors.yellow[700]),
          onPressed: () => writeJson(i + 1),
        ));
      }
    }

    return new Row(children: list);
  }
}

Widget text(double myrating) {
  if (myrating == 0.0) {
    return Text(
      'Paspauskite norimo reitingo žvaigždutę.',
      style: TextStyle(
          fontSize: 16, fontFamily: 'Roboto Regular', color: Colors.grey),
    );
  } else {
    return Text(
      'Bendras visų vartotojų reitingas.',
      style: TextStyle(
          fontSize: 16, fontFamily: 'Roboto Regular', color: Colors.grey),
    );
  }
}
