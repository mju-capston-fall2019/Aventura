import 'dart:async';
import 'package:aventura/components/RecommendationCard.dart';
import 'package:aventura/models/GeolocationModel.dart';
import 'package:aventura/models/AttractionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'area_info_page.dart';

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  AnimationController animationController;
  CurvedAnimation curvedAnimation;
  var cardIndex = 0;
  var now = new DateTime.now();

  String userName = "Hey";
  int numOfNearAttractions = 0;
  static LatLng userLatLng;
  Future<List<AttractionModel>> _getNearAttractions;

  Future<List<String>> getThumbnailImageUrl(String id) async {
    try {
      final StorageReference storageReference = FirebaseStorage().ref().child(id);
      List<String> urls = new List(3);
      urls[0] = await storageReference.child('1.jpg').getDownloadURL();
      urls[1] = await storageReference.child('2.jpg').getDownloadURL();
      urls[2] = await storageReference.child('3.jpg').getDownloadURL();
      return urls;
    } catch (e) {
      print('Error in getThumbnailImageUrl!\n');
      print(e);
      return null;
    }
  }

  Future<void> getLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator = Geolocator();
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();

    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        print('denied');
        break;
      case GeolocationStatus.disabled:
      case GeolocationStatus.restricted:
        print('restricted');
        break;
      case GeolocationStatus.unknown:
        print('unknown');
        break;
      case GeolocationStatus.granted:
        await Geolocator()
            .getCurrentPosition(desiredAccuracy: prefix0.LocationAccuracy.high)
            .then((Position _position) {
          if (_position != null) {
            setState(() {
              userLatLng = LatLng(
                _position.latitude,
                _position.longitude,
              );
            });
          }
        });
        break;
    }
  }

  Future<List<AttractionModel>> getNearAttractions() async {
    // get Country name by coordinate
    final coordinates =
        new Coordinates(userLatLng.latitude, userLatLng.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var cc = addresses[0].countryCode;

    // get attractions by country name
    var querySnapshot = await Firestore.instance
        .collection("Attractions")
        .where('countryCode', isEqualTo: cc)
        .getDocuments();
    var userLocationAttractions = querySnapshot.documents;

    // calculate distance between attraction and current location

    List<AttractionModel> attractions = [];

    for (int i = 0; i < userLocationAttractions.length; i++) {
      var attraction = new AttractionModel(
          userLocationAttractions[i].documentID,
          userLocationAttractions[i].data["country"],
          userLocationAttractions[i].data["type"],
          new GeolocationModel(
              userLocationAttractions[i].data["geolocationData"].latitude,
              userLocationAttractions[i].data["geolocationData"].longitude),
          userLocationAttractions[i].data["enName"],
          userLocationAttractions[i].data["koName"],
          userLocationAttractions[i].data["enSummaryDesc"],
          userLocationAttractions[i].data["koSummaryDesc"]);
      await Geolocator()
          .distanceBetween(
              userLatLng.latitude,
              userLatLng.longitude,
              attraction.geolocationData.latitude,
              attraction.geolocationData.longitude)
          .then((distance) {
        attraction.distance =
            double.parse((distance * 0.001).toStringAsFixed(1)); // meter -> km

        // push when attraction's distance less than 100km
        if (attraction.distance < 100) {
          attractions.add(attraction);
        }
      });
    }

    // sort attractions by distance
    attractions.sort((a, b) => a.distance.compareTo(b.distance));

    // take 3 attractions by distance
    var attractionList = attractions.take(3).toList();

    // get image urls
    for(int i=0; i<attractionList.length; i++){
      attractionList[i].imageUrls = await getThumbnailImageUrl(attractionList[i].id);
    }

    setState(() {
      numOfNearAttractions = attractionList.length;
    });

    return attractionList;
  }

  Future<void> kimchi() async {
    var posts = await Firestore.instance.collection("Attractions").where('country', isEqualTo: "Korea").getDocuments();

    final DocumentReference postRef = Firestore.instance.document('posts/123');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'likesCount': postSnapshot.data['likesCount'] + 1});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    FirebaseAuth.instance.currentUser().then((user) {
      userName = user.email.split('@')[0];
    });
    getLocation().then((val) {
      _getNearAttractions = getNearAttractions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var userLocation = Provider.of<GeolocationModel>(context);
    if (userLocation == null) {
      // Wait Permission to access user's location
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(186, 104, 200, 1),
                Color.fromRGBO(74, 22, 140, 1)
              ])),
          child: Center(
            child: Text(
              "Wait permission... :)",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(186, 104, 200, 1),
                Color.fromRGBO(74, 22, 140, 1)
              ])),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 20.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              DateFormat('EEEE').format(now).toString(),
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
                            child: Text(
                              DateFormat('MMM d').format(now).toString(),
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            "$userName, You have $numOfNearAttractions places to go!\n",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  height: 400.0,
                  child: FutureBuilder<List<AttractionModel>>(
                      future: _getNearAttractions,
                      builder: (BuildContext context, AsyncSnapshot<List<AttractionModel>> attractions) {
                        switch (attractions.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return new Text('Awaiting result...');
                          default:
                            if (attractions.hasError)
                              return new Text('Error: ${attractions.error}');
                            else
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: attractions.data.length,
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return new GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => AreaInfo(attraction: attractions.data[index], userLocation: userLocation,),
                                              ),
                                            );
                                          },
                                          onHorizontalDragEnd: (details) {
                                            animationController =
                                                AnimationController(
                                                    vsync: this,
                                                    duration: Duration(milliseconds: 400));
                                            curvedAnimation =
                                                CurvedAnimation(
                                                    parent: animationController,
                                                    curve: Curves.easeOut);
                                            if (details.velocity.pixelsPerSecond.dx > 0) {
                                              if (cardIndex > 0) {
                                                cardIndex--;
                                              }
                                            } else {
                                              if (cardIndex < attractions.data.length - 1) {
                                                cardIndex++;
                                              }
                                            }
                                            setState(() {
                                              scrollController.animateTo(
                                                  (cardIndex) * 260.0,
                                                  duration: Duration(milliseconds: 400),
                                                  curve: Curves.easeOut);
                                            });
                                            animationController.forward();
                                          },
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: RecommendationCard(
                                                  attraction: attractions.data[index],
                                                  userLocation: userLocation)),
                                        );
                                  });
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
