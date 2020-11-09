import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/foodMarker.dart';
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

    if (hour >= 18 || hour <= 8) {
      return false;
    }

    return true;
  }

  int _currentIndex = 0;

  void _onTappedItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Global key for main widget
  final _mainKey = GlobalKey();

  bool isActive = false;

  LatLng _currentLocation = LatLng(55.7033, 21.1443);

  void _centerUserLocation() async {
    var location = await Location().getLocation();

    setState(() {
      _currentLocation = LatLng(location.latitude, location.longitude);
    });
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 15)));
  }

  void _centerKlaipedaLocation() {
    setState(() {
      _currentLocation = LatLng(55.7033, 21.1443);
    });

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 15)));
  }

  Icon customIcon = Icon(
    Icons.search,
    size: 30,
  );

  // Title of the app bar
  String _appTitle = "SKANAUS!";

  TextEditingController _textController = new TextEditingController();

  textListener() {
    print(_textController);
  }

  Widget customSearchBar = Text(
    'example',
    style: TextStyle(
      fontSize: 15,
      letterSpacing: 8.0,
      color: Colors.yellow[700],
      //fontFamily: 'Roboto',
    ),
  );

  void _showSearchBar(int index) {
    if (customIcon.icon == Icons.search) {
      setState(() {
        customIcon = Icon(Icons.cancel);

        customSearchBar = TextField(
            controller: _textController,
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Ieškoti vietų'),
            style: TextStyle(color: Colors.white, fontSize: 16));
      });
    } else {
      setState(() {
        customIcon = Icon(Icons.search);
        customSearchBar = Text(
          _appTitle,
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 8.0,
            color: Colors.yellow[700],
            //fontFamily: 'Roboto',
          ),
        );
      });
    }
  }

  // This function is called once, when app is loaded.
  void initState() {
    super.initState();
    _textController.addListener(textListener());
    //_getNearbyPlaces();
    _getFoodLength();
    _setMarkerIcon();
  }

  int _listCount = 0;
  List<FoodMarker> _foodList = [];
  // App
  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ListView.builder(
        itemCount: _listCount,
        itemBuilder: (context, index) {
          var value = _foodList[index];
          return FoodTile(
            foodMarker: value,
          ); //FoodTile(foodMarker: _foodList[index]);
        },
      ),
      _maps(),
      Container(
        color: Colors.yellow,
      )
    ];

    return Scaffold(
      key: _mainKey,
      appBar: _currentIndex == 1
          ? AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.adjust_outlined,
                    size: 30,
                  ),
                  onPressed: () => _centerUserLocation()),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.location_city, size: 30),
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
        activeColor: Colors.yellow[700],
      ),
    );
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

  // Loads json file of places to eat from assets
  Future<String> _loadJsonFromAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  void _getFoodLength() async {
    String jsonString = await _loadJsonFromAsset('assets/food_data/foods.json');
    var foodsJson = jsonDecode(jsonString);

    int count = 0;

    for (var food in foodsJson) {
      FoodMarker foodMarker = FoodMarker.fromJson(food);
      _foodList.add(foodMarker);
      count++;
    }

    setState(() {
      _listCount = count;
    });
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
      initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 15),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,

      //zoomControlsEnabled: false,
    );
  }
}

class FoodTile extends StatelessWidget {
  final FoodMarker foodMarker;

  FoodTile({this.foodMarker});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        height: 100,
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_pin, size: 15),
                        SizedBox(width: 8),
                        Text(
                          foodMarker.address,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ) // Address
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 15,
                        ),
                        SizedBox(width: 8),
                        Text(foodMarker.number,
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Image.network(
                foodMarker.imageSource,
                height: 100,
                width: 170,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FoodBottomSheet extends StatelessWidget {
  final FoodMarker food;

  FoodBottomSheet({this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff29404E),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                food.title,
                style: TextStyle(
                    letterSpacing: 5.0,
                    fontSize: 25.0,
                    color: Colors.yellow[700]),
              ),
            ),
            SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food.imageSource,
                width: MediaQuery.of(context).size.width - 30,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 15),
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
                  style: TextStyle(fontSize: 20),
                ),
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 20,
                    color: Colors.yellow[700],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(food.number, style: TextStyle(fontSize: 20))
                ],
              ),
            ),
          ],
        ));
  }
}
