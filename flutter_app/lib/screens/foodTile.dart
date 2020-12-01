import 'package:flutter/material.dart';
import 'package:flutter_app/models/foodMarker.dart';
import 'package:flutter_app/themes/textStyle.dart';

class FoodTile extends StatelessWidget {
  final FoodMarker foodMarker;
  final Function navigateToPin;
  FoodTile({this.foodMarker, this.navigateToPin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () => navigateToPin(foodMarker.latLng),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
              color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodMarker.title,
                        style: tileTextBig,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: 15,
                            color: Colors.yellow[700],
                          ),
                          SizedBox(width: 8),
                          Text(
                            foodMarker.address,
                            style: tileTextSmall,
                          ) // Address
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 15,
                            color: Colors.yellow[700],
                          ),
                          SizedBox(width: 8),
                          Text(
                            foodMarker.number,
                            style: tileTextSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      getStars(double.parse(foodMarker.rating),
                          int.parse(foodMarker.ratingsCount)),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                child: Image.asset(
                  "assets/food_data/${foodMarker.imageSource}",
                  height: 110,
                  width: 170,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getStars(double rating, int ratingCount) {
    List<Widget> list = new List<Widget>();

    list.add(Icon(
      Icons.star_outlined,
      size: 15,
      color: Colors.yellow[700],
    ));
    list.add(SizedBox(width: 8));

    if (rating == 0.0) {
      list.add(Text(
        'Not rated yet',
        style: tileTextSmall,
      ));
    } else {
      int fullStars = rating.floor();

      for (int i = 0; i < fullStars; i++) {
        list.add(Icon(
          Icons.star,
          size: 15,
          color: Colors.yellow[700],
        ));
      }

      for (int i = 0; i < 5 - fullStars; i++) {
        list.add(Icon(
          Icons.star_border,
          size: 15,
          color: Colors.yellow[700],
        ));
      }
    }

    list.add(SizedBox(width: 8));
    list.add(Text('($ratingCount)', style: tileTextSmall));

    return new Row(children: list);
  }
}
