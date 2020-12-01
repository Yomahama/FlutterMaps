import 'dart:collection';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/foodMarker.dart';
import 'package:flutter_app/screens/addPlaceScreen.dart';
import 'package:flutter_app/screens/foodBottomSheet.dart';
import 'package:flutter_app/screens/foodTile.dart';
import 'package:flutter_app/screens/radiusBottomSheet.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/src/widgets/navigator.dart';

import 'net/generalMethods.dart';
import 'net/jsonMethods.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  bool loading = true;

  void _onTappedItem(int index) {
    setState(() {
      //MapsLoad().then(_currentIndex = index)
      _currentIndex = index;

      _checkIcon();
    });
  }

  void _checkIcon() {
    if (customIcon.icon != Icons.search) {
      customIcon = Icon(
        Icons.search,
        size: 30,
        color: Colors.grey,
      );
      customSearchBar = Text(
        'Skanaus!',
        style: TextStyle(
          fontFamily: 'Roboto Regular',
          fontSize: 20,
          letterSpacing: 6.0,
          color: Colors.white,
          //fontFamily: 'Roboto',
        ),
      );
    }
  }

  LatLng _currentLocation = LatLng(55.7033, 21.1443);
  //LatLng _klaipedaLocation = LatLng(55.7033, 21.1443);

  void _centerKlaipedaLocation() {
    setState(() {
      _currentLocation = LatLng(55.7033, 21.1443);
    });

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 15)));
  }

  Icon customIcon = Icon(
    Icons.search,
    color: Colors.grey,
    size: 30,
  );

  List<FoodMarker> _newFoodList = [];

  void _searchForTiles(String input) {
    if (_currentIndex == 0 && _foodList.length != 0) {
      setState(() {
        _newFoodList = _foodList
            .where((food) =>
                food.title.toLowerCase().contains(input.toLowerCase()) ||
                food.address.toLowerCase().contains(input.toLowerCase()))
            .toList();
      });
    }
  }

  Widget customSearchBar = Text(
    'Skanaus!',
    style: TextStyle(
      fontFamily: 'Roboto Regular',
      fontSize: 20,
      letterSpacing: 6.0,
      color: Colors.white,
    ),
  );

  void _showSearchBar(int index) {
    _newFoodList = _foodList;

    if (index == 0) {
      if (customIcon.icon == Icons.search) {
        setState(() {
          customIcon = Icon(
            Icons.cancel,
            size: 26,
            color: Colors.grey,
          );

          customSearchBar = TextField(
              onChanged: (text) => _searchForTiles(text),
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Ieškoti vietų'),
              style: TextStyle(color: Colors.white, fontSize: 16));
        });
      } else {
        setState(() {
          customIcon = Icon(
            Icons.search,
            size: 30,
            color: Colors.grey,
          );
          customSearchBar = Text(
            'Skanaus!',
            style: TextStyle(
              fontFamily: 'Roboto Regular',
              fontSize: 20,
              letterSpacing: 6.0,
              color: Colors.white,
              //fontFamily: 'Roboto',
            ),
          );
        });
      }
    } else {
      _showSheetRadius();
    }
  }

  double _getDistance(String latLng) {
    var coordinates = latLng.split(',');

    double distance = Geolocator.distanceBetween(
      _currentLocation.latitude,
      _currentLocation.longitude,
      double.parse(coordinates[0]),
      double.parse(coordinates[1]),
    );

    return distance;
  }

  // This function is called once, when app is loaded.
  void initState() {
    super.initState();
    getLocationPermission();
    _getFood();
    _setRedMarker();
  }

  void _navigateToSelectedPin(String latLng) async {
    try {
      _checkIcon();

      var coordinates = latLng.split(',');

      setState(() {
        _currentIndex = 1;
        _currentLocation =
            LatLng(double.parse(coordinates[0]), double.parse(coordinates[1]));
      });

      await _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation, zoom: 3)));
    } on Exception catch (_) {
      _navigateToSelectedPin(latLng);
    }
  }

  final _mainKey = GlobalKey();

  List<FoodMarker> _foodList = [];
  // App
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ListView.builder(
        itemCount: _newFoodList.length,
        itemBuilder: (context, index) {
          var value = _newFoodList[index];
          return FoodTile(
              foodMarker: value, navigateToPin: _navigateToSelectedPin);
        },
      ),
      _maps(),
    ];

    return Scaffold(
      key: _mainKey,
      appBar: _currentIndex == 1
          ? AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPlace())),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.location_city,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onPressed: () => _centerKlaipedaLocation(),
                ),
                IconButton(
                  icon: customIcon,
                  onPressed: () => _showSearchBar(_currentIndex),
                ),
              ],
              title: customSearchBar,
              toolbarHeight: 50.0,
              backgroundColor: HexColor('212121'),
            )
          : AppBar(
              centerTitle: true,
              actions: [
                IconButton(
                  icon: customIcon,
                  onPressed: () => _showSearchBar(_currentIndex),
                ),
              ],
              title: customSearchBar,
              toolbarHeight: 50.0,
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
          )
        ],
        currentIndex: _currentIndex,
        onTap: _onTappedItem,
        activeColor: Colors.white,
      ),
    );
  }

  GoogleMapController _mapController;

  // Sets the style of an app which is in assets folder in json format (editable)
  void _toggleMapStyle() async {
    String time = isDay();

    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/$time');

    _mapController.setMapStyle(style);
  }

  // Creates marker icon (uploads from the assets folder)
  BitmapDescriptor _markerIcon;

  Future _setRedMarker() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/markers/map.png');
  }

  Future _setGreenMarker() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/markers/map_green2.png');
  }

  Set<Marker> _markers = HashSet<Marker>();

  void _setMarkerData(FoodMarker marker) {
    setState(() {
      _showSheetData(marker);
    });
  }

  void _showSheetData(FoodMarker food) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FoodBottomSheet(food: food);
        });
  }

  double _distance = 0.0;

  void _showSheetRadius() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return RadiusBottomSheet(
            distance: _distance,
          );
        });
  }

  void _getFood() async {
    List<FoodMarker> foods = await getFoodList();

    setState(() {
      _foodList = foods;
      _newFoodList = List.from(_foodList);
    });
  }

  // Sets marker for each place
  void setMarkers(double distance) async {
    List<FoodMarker> foods = await getFoodList();

    if (distance == 0.0) {
      //await _setRedMarker();
      for (var food in foods) {
        var coordinates = food.latLng.split(',');
        Marker marker = new Marker(
          markerId: MarkerId(food.id),
          position: LatLng(
              double.parse(coordinates[0]), double.parse(coordinates[1])),
          infoWindow: InfoWindow(title: food.title),
          icon: _markerIcon,
          onTap: () => _setMarkerData(food),
        );

        setState(() {
          _markers.add(marker);
        });
      }
    } else {
      for (var food in foods) {
        double distanceBetween = _getDistance(
            food.latLng); // Distance between _currentLocation and foodPlace

        var coordinates = food.latLng.split(',');
        print(distanceBetween);
        if (distanceBetween <= distance) {
          await _setGreenMarker();
          Marker marker = new Marker(
            markerId: MarkerId(food.id),
            position: LatLng(
                double.parse(coordinates[0]), double.parse(coordinates[1])),
            infoWindow: InfoWindow(title: food.title),
            icon: _markerIcon,
            onTap: () => _setMarkerData(food),
          );

          setState(() {
            _markers.add(marker);
          });
        } else {
          await _setRedMarker();
          Marker marker = new Marker(
            markerId: MarkerId(food.id),
            position: LatLng(
                double.parse(coordinates[0]), double.parse(coordinates[1])),
            infoWindow: InfoWindow(title: food.title),
            icon: _markerIcon,
            onTap: () => _setMarkerData(food),
          );

          setState(() {
            _markers.add(marker);
          });
        }
      }
    }
  }

  // Recreates map which was set in controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _toggleMapStyle();
    setMarkers(0.0);
    loading = false;
  }

  // GoogleMamps exctracted widget
  Widget _maps() {
    return new GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 15),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      //zoomControlsEnabled: false,
    );
  }
}

// Vietos pridėjimas
//TODO Duombazėj laikyti informaciją apie visas maisto vietas
//TODO Vartotojams ir adminui bus skirtingos programėlės (adminas turi patvirtinti maisto vietą)
//TODO Kaip tai vyksta? vartotojui pridėjus vietą ji įdedama į kitą (ne pagrindinį) json turinio folderį
//TODO adminui rodo visas (pending) vietas, jei paspaudi, jog su vieta viskas gerai, ji nukeliama į pagrindinį json folderį

//Reitingai
//TODO Vartotojas žemėlapio bottomSheete gali reitinguoti vietą
//TODO pareitingavus

//Loadingas
//TODO Kol kraunasi žemėlapis jo vietoj loading widgetas (placeholderių widgetus pasižiūrėt)
