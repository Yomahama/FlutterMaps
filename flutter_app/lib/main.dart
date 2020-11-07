import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/foodMarker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey:
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=kebabai&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyBhOFdbqSqGtFoWJIL6K4ezlRgzwtzWXio');
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

    if (hour >= 18 || hour <= 8) {
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
  bool isActive = false;

  // This function is called once, when app is loaded.
  void initState() {
    super.initState();
    _getNearbyPlaces();
    _setMarkerIcon();
  }

  // App
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Container(
        color: Colors.deepPurpleAccent,
        child: Text('i duombaze!'),
      ),
      _maps(),
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
        .loadString('assets/map_styles/$time');

    _mapController.setMapStyle(style);
  }

  // Creates marker icon (uploads from the assets folder)
  BitmapDescriptor _markerIcon;

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/markers/map.png');
  }

  Set<Marker> _markers = HashSet<Marker>();

  void _setMarkerData(FoodMarker marker) {
    setState(() {
      _appTitle = marker.title;

      _showSheetData(marker.imageSource);
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

  //https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyBhOFdbqSqGtFoWJIL6K4ezlRgzwtzWXio
  void _getNearbyPlaces() async {
    var location = Location(55.7033, 21.1443);
    final result = await _places.searchNearbyWithRadius(location, 10);
    setState(() {
      if (result.status == 'OK') {
        result.results.forEach((f) {
          final marker = new Marker(
            position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
            infoWindow: InfoWindow(title: '${f.name}, $f.types?.first'),
            icon: _markerIcon,
            markerId: MarkerId(f.id),
          );

          _markers.add(marker);
        });
      } else {
        print("nepavyko-------------------------------------------");
      }
    });
  }

  // Loads json file of places to eat from assets
  Future<String> _loadJsonFromAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  // Sets marker for each place
  void _setMarkers() async {
    String jsonString = await _loadJsonFromAsset('assets/food_data/foods.json');
    var foodsJson = jsonDecode(jsonString);

    for (var food in foodsJson) {
      FoodMarker foodMarker = FoodMarker.fromJson(food);

      var coordinates = foodMarker.latLng.split(',');

      Marker marker = new Marker(
        markerId: MarkerId(foodMarker.id),
        position:
            LatLng(double.parse(coordinates[0]), double.parse(coordinates[1])),
        infoWindow: InfoWindow(title: foodMarker.title),
        icon: _markerIcon,
        onTap: () => _setMarkerData(foodMarker),
      );

      _markers.add(marker);
    }
  }

  // Recreates map which was set in controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _toggleMapStyle();
    _setMarkers();
  }

  // GoogleMamps exctracted widget
  Widget _maps() {
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
