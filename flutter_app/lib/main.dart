import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  GoogleMapController _mapController;

  // Sets the style of an app which is in assets folder in json format (editable)
  void _toggleMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/map_style.json');

    _mapController.setMapStyle(style);
  }

  // Creates marker icon (uploads from the assets folder)
  BitmapDescriptor _markerIcon;

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/markers/map.png');
  }

  // Adds markers of places in the map
  Set<Marker> _markers = HashSet<Marker>();

  void _setMarkers() {
    Marker marker1 = Marker(
      markerId: MarkerId('0'),
      position: LatLng(55.692045, 21.153976),
      infoWindow: InfoWindow(title: "McDonald"),
      icon: _markerIcon,
      //onTap: () => _showInfoDialog(),
    );
    Marker marker2 = Marker(
        markerId: MarkerId('1'),
        position: LatLng(55.686992, 21.145443),
        infoWindow: InfoWindow(title: 'Hesburger'),
        icon: _markerIcon);

    _markers.add(marker1);
    _markers.add(marker2);
  }

  // Recreates map which was set in controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _toggleMapStyle();
    _setMarkers();
  }

  // Gets the permission of location (for android users only)
  void _getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }

  int _selectedIndex;

  void _onTappedItem(int index) {
    setState(() {
      index = _selectedIndex;
    });
  }

  // This function is called once, when app is loaded.
  void initState() {
    super.initState();
    _getLocationPermission();
    _setMarkerIcon();
    //_setMarkers();
  }

  // static List<Widget> _widgetOptions = <Widget>[
  //   GoogleMap(
  //     initialCameraPosition:
  //         CameraPosition(target: LatLng(55.7033, 21.1443), zoom: 15),
  //   ),
  //   Container(
  //     color: Colors.red,
  //   ),
  //   Container(
  //     color: Colors.yellow,
  //   )
  // ];

  // App
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "KLAIPĖDA",
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 10.0,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 35.0,
          backgroundColor: HexColor('212121'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition:
              CameraPosition(target: LatLng(55.7033, 21.1443), zoom: 15),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          //_widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_dash),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.info),
            )
          ],
          currentIndex: 0,
          onTap: _onTappedItem,
          activeColor: Colors.white,
        ));
  }
}

// this is for test purposes
