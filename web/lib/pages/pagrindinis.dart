import 'package:flutter/material.dart';

class Pagrindinis extends StatefulWidget {
  @override
  _PagrindinisState createState() => _PagrindinisState();
}

class _PagrindinisState extends State<Pagrindinis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
          ),
          Container(
            color: Colors.red,
          )
        ],
      ),
    );
  }

  Widget buildLeftSide() {
    return Flexible(
      child: Column(
        children: [
          Container(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget buildRightSide() {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
