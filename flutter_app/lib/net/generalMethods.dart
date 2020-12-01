import 'package:location/location.dart';

String isDay() {
  String day = 'map_style_day.json';
  String night = 'map_style_night.json';

  var hour = DateTime.now().hour;

  if (hour >= 18 || hour <= 8) {
    return night;
  }

  return day;
}

void getLocationPermission() async {
  await Location().getLocation();
}
