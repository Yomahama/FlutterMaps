import 'package:flutter/material.dart';

class ChooseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          spacing: 10.0,
          children: [
            Expanded(
              child: RaisedButton(
                onPressed: null,
                child: Text('Fitness progress'),
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: null,
                child: Text('Health tracking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexColor {}
