import 'package:flutter/material.dart';
import 'package:flutter_app/themes/textStyle.dart';

class RadiusBottomSheet extends StatefulWidget {
  double distance;

  RadiusBottomSheet({Key key, @required this.distance}) : super(key: key);

  @override
  _RadiusBottomSheetState createState() => _RadiusBottomSheetState();
}

class _RadiusBottomSheetState extends State<RadiusBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text('Pasirinkite ieškojimo plotą', style: mainTextStyle),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.black12,
            ),
            child: Slider(
              value: widget.distance,
              min: 0.0,
              max: 15.0,
              divisions: 15,
              activeColor: Colors.yellow[700],
              inactiveColor: Colors.yellow[700],
              label: '${widget.distance}km',
              onChanged: (val) {
                setState(() {
                  widget.distance = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
