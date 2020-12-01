import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/themes/textStyle.dart';
import 'package:hexcolor/hexcolor.dart';

class AddPlace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pridėti naują vietą',
          style: mainTextStyle,
        ),
        toolbarHeight: 50.0,
        backgroundColor: HexColor('212121'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () => _showInfoDialog(context,
                'Įvedę duomenys apie naują maitinimo vietą, užklausa bus siunčiama administratoriui. Užklausai praėjus validaciją, vieta automatiškai bus pridėta žemėlpayje.'),
          ),
        ],
      ),
      body: Container(
        color: Colors.amber,
        child: Column(
            // children: [
            //   Text('Koordinatės'),
            //   Row(
            //     children: [
            //       TextField(
            //         decoration:
            //             inputDecoration.copyWith(hintText: 'ilguma, platuma'),
            //       ),
            //       IconButton(
            //           icon: Icon(Icons.info_outline),
            //           onPressed: () => _showInfoDialog(context,
            //               'Koordinates galite rasti, suradę žemėlapyję tikslią vietą. Įklijuokite ilgumą ir platumą, atskirtus kableliu.'))
            //     ],
            //   ),
            //   Text('Vietos pavadinimas'),
            //   TextField(decoration: inputDecoration),
            //   Text('Adresas'),
            //   TextField(decoration: inputDecoration),
            //   Text('Numeris'),
            //   TextField(decoration: inputDecoration),
            //   RaisedButton(
            //     onPressed: null,
            //     child: Text('PRIDĖTI NUOTRAUKĄ'),
            //   ),
            //   RaisedButton(
            //     onPressed: null,
            //     child: Text('SIŲSTI UŽKLAUSĄ'),
            //   ),
            // ],
            ),
      ),
    );
  }

  _showInfoDialog(BuildContext context, String text) {
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      content: Text(text),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
