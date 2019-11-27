import 'package:aventura/models/AttractionModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecommendationCard extends StatelessWidget {
  final AttractionModel attraction;
  const RecommendationCard(this.attraction);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: 250.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets
                  .only(
                  right: 8.0,
                  left: 8.0,
                  top: 4.0),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(
                    label: new Text(
                      attraction.type,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black38,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets
                  .symmetric(
                  horizontal: 8.0,
                  vertical: 4.0),
              child: Container(
                  child: attraction.imageUrls == null ? Text("") : CachedNetworkImage(
                      imageUrl: attraction.imageUrls[0],
                      placeholder: (context, url) => new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                      height: 180,
                      fit: BoxFit.fitHeight,
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      //TODO: Create Dynamic distance in card using user's current geo-location
                      "1.5 Km from here",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets
                        .symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                        attraction.enName,
                        style: TextStyle(fontSize: 25.0),
                        softWrap: false,
                        overflow: TextOverflow.fade
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
