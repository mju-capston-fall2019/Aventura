import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  MapWidget({this.name, this.country, this.latitude, this.longitude});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  _getMarker() {
    return Marker(
      markerId: MarkerId("attracrion"),
      position: LatLng(widget.latitude, widget.longitude),
      infoWindow: InfoWindow(title: widget.name),
    );
  }

  _getMyMarker() {
    return Marker(
      markerId: MarkerId("my"),
      position: LatLng(40.416950, -3.715267),
      infoWindow: InfoWindow(title: "my location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
    );
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
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 15.5,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              _getMarker(),
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
              margin: const EdgeInsets.only(bottom: 50),
              width: 330,
              height: 150,
              //color: Colors.white,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F1.jpg?alt=media&token=31458340-e640-4317-9543-604cf387518f",
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.pop(context);
        },
        label: Text('back!'),
      ),
    );
  }
}
