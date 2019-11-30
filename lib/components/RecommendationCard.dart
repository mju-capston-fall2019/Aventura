import 'package:aventura/models/AttractionModel.dart';
import 'package:aventura/models/GeolocationModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class RecommendationCard extends StatefulWidget {
  final AttractionModel attraction;
  final GeolocationModel userLocation;

  const RecommendationCard({Key key, this.attraction, this.userLocation})
      : super(key: key);

  @override
  _RecommendationCardState createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  var _distance;

  @override
  void initState() {
    Geolocator()
        .distanceBetween(
            widget.userLocation.latitude,
            widget.userLocation.longitude,
            widget.attraction.geolocationData.latitude,
            widget.attraction.geolocationData.longitude)
        .then((distance) {
      setState(() {
        _distance = (distance * 0.001).toStringAsFixed(1); // meter -> km
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: 250.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Chip(
                      label: new Text(
                        widget.attraction.type,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black38,
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Center(
                  child: Container(
                      child: widget.attraction.imageUrls == null
                          ? Image.asset('assets/no-image.png',
                              height: 180, fit: BoxFit.fitHeight)
                          : CachedNetworkImage(
                              imageUrl: widget.attraction.imageUrls[0],
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                              height: 180,
                              fit: BoxFit.fitHeight,
                            )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        "$_distance Km from here",
                        style: TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(widget.attraction.enName,
                          style: TextStyle(fontSize: 25.0),
                          softWrap: false,
                          overflow: TextOverflow.fade),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
