import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatefulWidget {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  //todo - change my location
  final double myLatitude = 40.416950;
  final double myLongitude = -3.615267;

  MapWidget({this.name, this.country, this.latitude, this.longitude});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  _getAttractionMarker() {
    return Marker(
      markerId: MarkerId("attracrion"),
      position: LatLng(widget.latitude, widget.longitude),
      infoWindow: InfoWindow(title: widget.name),
    );
  }

  _getMyMarker() {
    return Marker(
      markerId: MarkerId("my"),
      position: LatLng(widget.myLatitude, widget.myLongitude),
      infoWindow: InfoWindow(title: "my location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
    );
  }

  _onTap(int index) {
    switch (index) {
      //backbutton
//      case 0:
//        Navigator.pop(context);
//        break;
      case 0:
        _goToTMyLocation();
        break;
      case 1:
        _goToTAttractionLocation();
        break;
      case 2:
        String url =
            "https://www.google.com/maps/dir/?api=1&origin=${widget.latitude},${widget.longitude}&destination=${widget.myLatitude},${widget.myLongitude}&travelmode=driving&dir_action=navigate";
        _launchURL(url);
        break;
      default:
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getAttractionCameraPosition() {
    return CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 15.5,
    );
  }

  _getMyCameraPosition() {
    return CameraPosition(
      target: LatLng(widget.myLatitude, widget.myLongitude),
      zoom: 15.5,
    );
  }

  Future<void> _goToTMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_getMyCameraPosition()));
  }

  Future<void> _goToTAttractionLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_getAttractionCameraPosition()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: _getAttractionCameraPosition(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              _getAttractionMarker(),
              _getMyMarker(),
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 10.0),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 20),
              width: 330,
              height: 150,
              //color: Colors.white,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    child: Image.network(
                      //todo  - change img
                      "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/C1gT4r367U5PYYVGxUYH%2F1.jpg?alt=media&token=b5fe592f-7260-4f32-849a-8c02d259ed8c",
                      width: 130,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 200,
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 200,
                        child: Text(
                          widget.country,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 200,
                        child: Text(
                          "1.5km",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          //backbutton
//          BottomNavigationBarItem(
//            icon: Icon(Icons.navigate_before),
//            title: Text(''),
//          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            title: Text(''),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.deepOrangeAccent,
        onTap: _onTap,
      ),
    );
  }
}
