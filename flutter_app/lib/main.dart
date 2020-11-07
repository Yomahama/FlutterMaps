import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_app/maps.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDay() {
    var hour = DateTime.now().hour;

    if (hour >= 18 && hour <= 8) {
      return false;
    }

    return true;
  }

  int _currentIndex = 1;

  void _onTappedItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Global key for main widget
  final _mainKey = GlobalKey();

  // Title of the app bar
  String _appTitle = "KLAIPĖDA";

  // This function is called once, when app is loaded.
  void initState() {
    super.initState();
    _setMarkerIcon();
  }

  // App
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Container(
        color: Colors.red,
      ),
      _Maps(),
      Container(
        color: Colors.yellow,
      )
    ];

    return Scaffold(
        key: _mainKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _appTitle, //getAppBarTitle(),
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 10.0,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 35.0,
          backgroundColor: HexColor('212121'),
        ),
        body: _widgetOptions[_currentIndex],
        bottomNavigationBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_dash),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.info),
            )
          ],
          currentIndex: 1,
          onTap: _onTappedItem,
          activeColor: Colors.white,
        ));
  }

  GoogleMapController _mapController;

  // Sets the style of an app which is in assets folder in json format (editable)
  void _toggleMapStyle() async {
    String day = 'map_style_day.json';
    String night = 'map_style_night.json';

    var time = "";

    if (_isDay()) {
      time = day;
    } else {
      time = night;
    }

    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/${night}');

    _mapController.setMapStyle(style);
  }

  // Creates marker icon (uploads from the assets folder)
  BitmapDescriptor _markerIcon;

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/markers/map.png');
  }

  Set<Marker> _markers = HashSet<Marker>();

  void _setMarkerData(String name, String src) {
    setState(() {
      _appTitle = name;

      _showSheetData(src);
    });
  }

  void _showSheetData(String src) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              color: Colors.grey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      _appTitle,
                      style: TextStyle(
                        letterSpacing: 10.0,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Image.network(
                      src,
                      width: 8000,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Reviews',
                      style: TextStyle(
                        letterSpacing: 10.0,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  void _setMarkers() {
    Marker marker1 = Marker(
      markerId: MarkerId('0'),
      position: LatLng(55.692045, 21.153976),
      infoWindow: InfoWindow(title: "McDonald"),
      icon: _markerIcon,
      onTap: () => _setMarkerData("MCDONALD",
          'https://upload.wikimedia.org/wikipedia/commons/5/5c/McDonald%27s_klaipeda.jpg'),
    );
    Marker marker2 = Marker(
      markerId: MarkerId('1'),
      position: LatLng(55.686992, 21.145443),
      infoWindow: InfoWindow(title: 'Hesburger'),
      icon: _markerIcon,
      onTap: () => _setMarkerData('HESBURGER',
          'https://www.hesburger.lt/clients/hesburger/output/ravintolakuva.php?id=28161'),
    );

    _markers.add(marker1);
    _markers.add(marker2);
  }

  // Recreates map which was set in controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _toggleMapStyle();
    _setMarkers();
  }

  // GoogleMamps exctracted widget
  Widget _Maps() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition:
          CameraPosition(target: LatLng(55.7033, 21.1443), zoom: 15),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,

      //zoomControlsEnabled: false,
    );
  }
}
