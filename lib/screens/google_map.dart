import 'dart:async';
import 'package:aventura/models/AttractionModel.dart';
import 'package:aventura/models/GeolocationModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatefulWidget {
  final AttractionModel attraction;
  final GeolocationModel myLocation;

  MapWidget({this.attraction, this.myLocation});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  int index=1;
  String _distance='';
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    Geolocator().distanceBetween(
      widget.myLocation.latitude,
      widget.myLocation.longitude,
      widget.attraction.geolocationData.latitude,
      widget.attraction.geolocationData.longitude)
      .then((distance) {
        setState(() {
          _distance = (distance * 0.001).toStringAsFixed(1); // meter -> km
        });
      });
  }

  _getAttractionMarker() {
    return Marker(
      markerId: MarkerId("attracrion"),
      position: LatLng(widget.attraction.geolocationData.latitude, widget.attraction.geolocationData.longitude),
      infoWindow: InfoWindow(title: widget.attraction.enName),
    );
  }

  _getMyMarker() {
    return Marker(
      markerId: MarkerId("my"),
      position: LatLng(widget.myLocation.latitude, widget.myLocation.longitude),
      infoWindow: InfoWindow(title: "my location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
    );
  }

  _onTap(int index) {
    setState(() {
      this.index = index;
    });
    switch (index) {
      case 0:
        _goToTMyLocation();
        break;
      case 1:
        _goToTAttractionLocation();
        break;
      case 2:
        String url =
            "https://www.google.com/maps/dir/?api=1&origin=${widget.attraction.geolocationData.latitude},${widget.attraction.geolocationData.longitude}&destination=${widget.myLocation.latitude},${widget.myLocation.longitude}&travelmode=driving&dir_action=navigate";
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
      target: LatLng(widget.attraction.geolocationData.latitude, widget.attraction.geolocationData.longitude),
      zoom: 15.5,
    );
  }

  _getMyCameraPosition() {
    return CameraPosition(
      target: LatLng(widget.myLocation.latitude, widget.myLocation.longitude),
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
                      widget.attraction.imageUrls[0],
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
                          widget.attraction.koName,
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
                          widget.attraction.country,
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
                          _distance+' km',
                          style: TextStyle(
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
        currentIndex: index,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            title: index==0 ? Text('∙') : Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            title: index==1 ? Text('∙') : Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            title: index==2 ? Text('∙') : Text(''),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onTap,
      ),
    );
  }
}
