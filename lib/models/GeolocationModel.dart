class GeolocationModel {
  double latitude;
  double longitude;

  GeolocationModel(this.latitude, this.longitude);
  @override
  String toString() {
    return 'GeolocationModel{latitude: $latitude, longitude: $longitude}';
  }

}
