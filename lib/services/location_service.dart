import 'dart:async';

import 'package:aventura/models/GeolocationModel.dart';
import 'package:location/location.dart';

class LocationService {
  GeolocationModel _currentLocation;

  Location location = Location();

  // Continuously emit location updates
  StreamController<GeolocationModel> _locationController =
  StreamController<GeolocationModel>.broadcast();

  Stream<GeolocationModel> get locationStream => _locationController.stream;

  LocationService() {
    location.requestPermission().then((granted) {
      if(granted) {
        location.onLocationChanged().listen((locationData){
          _locationController.add(GeolocationModel(
              locationData.latitude,
              locationData.longitude));
        });
      }
    });
  }


  Future<GeolocationModel> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = GeolocationModel(userLocation.latitude, userLocation.longitude);
    } catch(e) {
      print('Could not get the location: $e');
    }
    return _currentLocation;
  }

}